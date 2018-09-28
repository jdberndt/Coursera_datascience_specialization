Quiz1:
        # 1. filesize en_US.blogs.txt 
        #210.2Mb

        # 2. number of lines in en_US.twitter.txt
        con <- file("final/en_US/en_US.twitter.txt", "r")
        twitter <- readLines(con)
        length(twitter) #2360148
        close(con)
        # or [wc -l ./final/en_US/en_US.twitter.txt] at the command prompt
        #str_split(system("wc -l ./final/en_US/en_US.twitter.txt", intern = T), " ")[[1]][2]
        
        # 3. length of longest line in any of 3 en_US data files
        con <- file("final/en_US/en_US.blogs.txt", "r"); blog <- readLines(con); close(con)
        con <- file("final/en_US/en_US.news.txt", "r"); news <- readLines(con); close(con)
        library(stringr)
        max(str_count(twitter)) #140       
        max(str_count(blog)) #40833 
        max(str_count(news))  #11384
        
        # 4. number of lines with "love" divided by number of lines with "hate" in en_US twitter
        sum(grepl("love", twitter))/sum(grepl("hate", twitter)) #4.108592
        
        # 5. what does line with "biostats" say
        twitter[grep("biostats", twitter)] #"i know how you feel.. i have biostats on tuesday and i have yet to study =/"
        grep("biostats", twitter, value = TRUE) #alternative code
        
        # 6. how many tweets with "A computer once beat me at chess, but it was no match for me at kickboxing"
        sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", twitter)) #3
        
#Same thing but using the "tm" package
        #1
        #2
        library(tm)
        corpus <- VCorpus(DirSource("final/en_US", encoding = "UTF-8"), readerControl = list(language = "eng"))
        names(corpus) #[1] "en_US.blogs.txt"   "en_US.news.txt"    "en_US.twitter.txt"
        length(corpus[[3]][[1]])
        #3
        max(str_count(as.character(corpus[[1]]))) #etc.
        #4
        sum(grepl("love", as.character(corpus[[3]])))/sum(grepl("hate", as.character(corpus[[3]]))) #twice as slow as using "twitter" as atomic vector
        #5 and 6 are obvious extensions of the above
        
        