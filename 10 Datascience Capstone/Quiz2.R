# The guy in front of me just bought a pound of bacon, a bouquet, and a case of
# You're the reason why I smile everyday. Can you follow me please? It would mean the
# Hey sunshine, can you follow me and make me the
# Very early observations on the Bills game: Offense still struggling but the
# Go on a romantic date at the
# Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my
# Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some
# After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little
# Be grateful for the good times and keep the faith during the
# If this isn't the cutest thing you've ever seen, then you must be

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
                                "en_US.dfm2",
                                en_US.corpus$documents$Source[x],
                                as.character(n),
                                "rds",
                                sep = "."
                        )
                )
        })
} 

(inittime <- Sys.time())
registerDoParallel(cl)
mapply(make.dfm, n, trim)
stopCluster(cl)
(elapsedtime <- Sys.time()-inittime) #37.7min

#------


gc()

rm(en_US.corpus)
en_US.dfm.news <- list()#repeat for each type of data
filestoread <- lapply(n, function(x) paste0("en_US.dfm.US.news.", as.character(x), ".rds"))
en_US.dfm.news <- lapply(1:3, function(x) readRDS(filestoread[[x]]))

#combine dfms
en_US.dfm <- lapply(1:3, function(x) cbind(en_US.dfm.twitter[[x]], en_US.dfm.blogs[[x]], en_US.dfm.news[[x]]))

#extract frequencies
ngrams_dt <- lapply(1:3, function(n) data.table(textstat_frequency(en_US.dfm[[n]])))
 
#summarize frequencies
ngrams_dt <- lapply(1:3, function(x) ngrams_dt[[x]]%>%group_by(feature)%>%summarise(frequency = sum(frequency))%>%arrange(desc(frequency)))

rm(en_US.dfm)
gc()


ngrams_dt$Quadrigrams$first.words <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Quadrigrams$feature), 1, -2)
ngrams_dt$Quadrigrams$last.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Quadrigrams$feature)
ngrams_dt$Trigrams$first.words <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Trigrams$feature), 1, -2)
ngrams_dt$Trigrams$last.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Trigrams$feature)
ngrams_dt$Bigrams$first.words <- str_sub(str_extract(pattern="^.+_", string = ngrams_dt$Bigrams$feature), 1, -2)
ngrams_dt$Bigrams$last.word <- str_extract(pattern="[a-z]+$", string = ngrams_dt$Bigrams$feature)
ngrams_dt <- lapply(1:3, function(x) {
                        ngrams_dt[[x]]%>%
                        select(2:4)%>%
                        group_by(first.words)%>%
                        mutate(probability = frequency/sum(frequency))%>%
                        ungroup()
                        }
                )


names(ngrams_dt) <- c("Quadrigrams", "Trigrams", "Bigrams")



saveRDS(ngrams_dt, "ngrams_dt.rds")
#ngrams_dt <- readRDS("ngrams_dt.rds")

#I think KAtz backoff works as follows: 
#1. predictions from n-1 grams are considered according to their unmodified probabilites
#2. probabilities for predictions from n-2 grams are adjusted down if 

#example:
#query: It would mean <nothing>
#corpus ngrams ordered by frequency:
#quadrigrams: that would mean the, she would mean that, that would mean nothing
#trigrams: would mean the, would mean that, would mean nothing

#thus, although the trigram "would mean nothing" occurs less frequently than "would mean the" or "would mean that"
#it should be given an increased probability because the quadrigrams with "the" and "that" have already been tested.


#sqldf and data.table[i,] are both slower than dplyr::filter


#read in query
queries <- read_lines("quiz3.csv")
trigram = character(); bigram = character(); unigram = character()
for (i in seq_along(queries)){
        query <- str_split(queries[i], boundary("word"), simplify = T)
        len.query <- length(query)
        trigram[i] <- paste(query[(len.query-2):len.query], collapse="_")
        bigram[i] <- paste(query[(len.query-1):len.query], collapse="_")
        unigram[i] <- query[len.query]
}
query.df <- data.frame(trigram, bigram, unigram)

results <- list()
#iteratively searches for queries in dfm_dt until finding ten matches or reaching unigrams
for (i in seq_along(queries)){ 
        results[[i]] <- (ngrams_dt$Quadrigrams%>%filter(first.words == trigram[i]))
        if (nrow(results[[i]])<10){
                moreresults <- (ngrams_dt$Trigrams%>%filter(first.words == bigram[i]))
                results[[i]] <- rbind(results[[i]], moreresults)
        }
        if (nrow(results[[i]])<10){
                moreresults <- (ngrams_dt$Bigrams%>%filter(first.words == unigram[i]))
                results[[i]] <- rbind(results[[i]], moreresults)
        }
        results[[i]] <- results[[i]][1:10,]
}


ngrams_dt$Trigrams%>%filter(first.words == bigram)#%>%filter(last.word%in%c("asleep", "insane","callous","insensitive"))
ngrams_dt$Bigrams%>%filter(first.words == unigram)%>%filter(!last.word %in% stopwords("en"))
