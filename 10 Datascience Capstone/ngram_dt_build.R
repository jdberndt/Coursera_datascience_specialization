
library(stringr); library(quanteda); library(readtext) 
library(doParallel); library(parallel)
library(ggplot2); library(data.table); library(dplyr); library(readr)


cl <- makeCluster((detectCores()-1), type = "FORK")
registerDoParallel(cl)

en_US.corpus <- corpus(readtext("final/en_US/", docvarsfrom = "filenames", docvarnames = c("Language", "Source")))

stopCluster(cl)
gc()

make.dfm <- function(n, trim) {
        lapply(1:3, function(x, ...) {
                temp <- dfm(
                        en_US.corpus$documents$texts[x],
                        remove_punct = T,
                        remove_numbers = T,
                        remove_twitter = T,
                        ngrams = n
                )
                temp <- dfm_trim(temp, trim)
                saveRDS(
                        temp,
                        paste(
                                "en_US.dfm",
                                en_US.corpus$documents$Source[x],
                                as.character(n),
                                "rds",
                                sep = "."
                        )
                )
        })
} 



n <- 4:2
trim <- c(2,5,10)
(inittime <- Sys.time())
registerDoParallel(cl)
mapply(make.dfm, n, trim)
stopCluster(cl)
(elapsedtime <- Sys.time()-inittime) #37.7min

#------


gc()

rm(en_US.corpus)
en_US.dfm.news <- list()#repeat manually for each type of data
filestoread <- lapply(5:2, function(x) paste0("en_US.dfm2.US.news.", as.character(x), ".rds"))
en_US.dfm.news <- lapply(1:4, function(x) readRDS(filestoread[[x]]))
en_US.dfm.blogs <- list()#repeat manually for each type of data
filestoread <- lapply(5:2, function(x) paste0("en_US.dfm2.US.blogs.", as.character(x), ".rds"))
en_US.dfm.blogs <- lapply(1:4, function(x) readRDS(filestoread[[x]]))
en_US.dfm.twitter <- list()#repeat manually for each type of data
filestoread <- lapply(5:2, function(x) paste0("en_US.dfm2.US.twitter.", as.character(x), ".rds"))
en_US.dfm.twitter <- lapply(1:4, function(x) readRDS(filestoread[[x]]))

#combine dfms
en_US.dfm <- lapply(1:4, function(x) cbind(en_US.dfm.twitter[[x]], en_US.dfm.blogs[[x]], en_US.dfm.news[[x]]))

#extract frequencies and term to dt
ngrams_dt <- lapply(1:4, function(n) data.table(textstat_frequency(en_US.dfm[[n]])))

#sum frequencies across data types
ngrams_dt <- lapply(1:4, function(x) ngrams_dt[[x]]%>%group_by(feature)%>%summarise(frequency = sum(frequency))%>%arrange(desc(frequency)))
ngrams_dt2 <- lapply(1:4, function(x) ngrams_dt[[x]]%>%filter(frequency > 5))
rm(en_US.dfm)
gc()

names(ngrams_dt) <- c("Pentagrams", "Quadrigrams", "Trigrams", "Bigrams")
ngrams_dt$Pentagrams$query.phrase <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Pentagrams$feature), 1, -2)
ngrams_dt$Pentagrams$predicted.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Pentagrams$feature)
ngrams_dt$Quadrigrams$query.phrase <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Quadrigrams$feature), 1, -2)
ngrams_dt$Quadrigrams$predicted.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Quadrigrams$feature)
ngrams_dt$Trigrams$query.phrase <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Trigrams$feature), 1, -2)
ngrams_dt$Trigrams$predicted.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Trigrams$feature)
ngrams_dt$Bigrams$query.phrase <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Bigrams$feature), 1, -2)
ngrams_dt$Bigrams$predicted.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Bigrams$feature)
ngrams_dt <- lapply(1:4, function(x) {
                        ngrams_dt[[x]]%>%
                        select(2:4)%>% #removes 'feature' variable
                        group_by(query.phrase)%>%
                        mutate(probability = frequency/sum(frequency))%>% #calculates "inclass" probabilities, i.e. stupid back off
                        ungroup()
                        }
                )
ngrams_dt <- lapply(1:4, function(x) ngrams_dt[[x]][,c(2,3,1,4)])#rearrange columns

ngrams_dt[[5]] <- stopwords("en")
ngrams_dt[[6]] <- as.character(read.table("profane.txt", header = F)$V1)

names(ngrams_dt) <- c("Pentagrams", "Quadrigrams", "Trigrams", "Bigrams", "stopwords", "profanity") #add names

saveRDS(ngrams_dt, "ngrams_dt.rds")
#ngrams_dt <- readRDS("ngrams_dt.rds")
