

con <- file("final/en_US/en_US.twitter.txt", "r")
twitter <- readLines(con, n = 1000)
close(con)
length(twitter) #2360148
library(quanteda)
corpus(twitter)
mydfm <- dfm(twitter)
summary(mydfm)
View(mydfm)
str(mydfm)
library(tm)
inspect(mydfm)
class(twitter)
mycorpus <- corpus(twitter)
summary(mycorpus)
View(twitter)
texts(mycorpus)[2]
texts(mycorpus)[1]
summary(mycorpus)
tokenInfo <- summary(mycorpus)
library(ggplot2); ggplot(data=tokenInfo, aes(x=Sentences, y=Tokens, group = 5))+geom_point()
tokenInfo[which.max(tokenInfo$Tokens),]
tokenInfo[which.max(tokenInfo$Sentences),]
texts(mycorpus)[28]
corpus_subset(mycorpus, subset = Tokens >30)
kwic(mycorpus, "fuck")
kwic(mycorpus, "shit")
head(mycorpus)
head(docvars(mycorpus))
metacorpus(mycorpus)
tokens(mycorpus[1])
tokens(mycorpus[1], remove_punct = T)
library(purrr)
map(mycorpus[1:10], tokens)
map(mycorpus[1:10], tokens(remove_punct = T))
map(mycorpus[1:10], function(x){tokens(x, remove_punct = T)})
mycorpus[1:10]%>%map(~tokens(., remove_punct = T))
