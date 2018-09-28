#Course dataset:
<https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip>


#Resources:
<https://en.wikipedia.org/wiki/Natural_language_processing>  
<https://cran.r-project.org/web/views/NaturalLanguageProcessing.html>  
<https://www.jstatsoft.org/article/view/v025i05>  

#Videos and Slides from Stanford Natural Language Processing course  
<https://www.youtube.com/user/OpenCourseOnline/search?query=NLP>  
<https://web.stanford.edu/~jurafsky/NLPCourseraSlides.html>  

#Task 0:  
-Obtaining the data - Can you download the data and load/manipulate it in R?  
-Familiarizing yourself with NLP and text mining - Learn about the basics of natural language processing and how it relates to the data science process you have learned in the Data Science Specialization.  

##Questions to consider  
What do the data look like?  
Where do the data come from?  
Can you think of any other data sources that might help you in this project?  
What are the common steps in natural language processing?  
What are some common issues in the analysis of text data?  
What is the relationship between NLP and the concepts you have learned in the Specialization?  

#Task1:  

Tokenization - identifying appropriate tokens such as words, punctuation, and numbers. Writing a function that takes a file as input and returns a tokenized version of it.  
  
Profanity filtering - removing profanity and other words you do not want to predict.  
resource: <http://www.cs.cmu.edu/~biglou/resources/bad-words.txt>
download.file("http://www.cs.cmu.edu/~biglou/resources/bad-words.txt", destfile = "profane.txt", method = "curl")
profane <- read.table("profane.txt", header = F)


-loading data in chunks, create file connections, see ?connections  
-consider random sampling of lines to read, ribnom  
-see also quanteda::corpus_sample()
file.size("final/en_US/en_US.blogs.txt")/2^20


##Regex:  
^ start of string  
$ end of string  
\\< start of word  
\\> end of word  
[0-9] any number  
[a-z] any letter  
. any character except \n  
[Aa] "a" of either case  
(A|B) exactly "A" or "B"  
[^A] not"A"  
* matches at least 0 times  
+ matches at least 1 time  
? matches at most 1 time, optional string  
{n} matches exactly n times  
{n,} matches at least n times  
{,n} matches at most n times  
{n,m} matches between n and m times  

##indexing a corpus made with the "tm" package  
tm::VCorpus() creates a corpora from strings or a directory of files (DirSource()), e.g. an attributed list of lists called "corpus" where:  
corpus[[1]][[1]][1:10] prints the first ten lines of the first document in the corpus  
corpus[[1]][[2]] prints the meta data of the first document in the corpus  
as.character(corpus[1])[1:10] prints the first ten lines of the first document in the corpus  

##tokenizing  
see ?stringr::boundary and ?readr::tokenize and ?quanteda::tokens
other packages to consider:
cleanNLP https://cran.r-project.org/web/packages/cleanNLP/vignettes/case_study.html

##quanteda  
<http://docs.quanteda.io/articles/quickstart.html#currently-available-corpus-sources>  
associated packages (readtext, spacyr, quanteda.corpora, quanteda.dictionaries)  
e.g. corpus[[1]][1:10]%>%map(~tokens(., remove_punct = T)) #applies tokenization to first ten lines of corpus  
mydfm <- dfm(corpus) #creates document term matrix  
summary(corpus) #summarizes tokens, sentences, etc. from each document in corpus  

> summary(corpus)
Corpus consisting of 3 documents:

              Text  Types   Tokens Sentences docvar1    docvar2
   en_US.blogs.txt 482432 42840140   2072941      en   US.blogs
    en_US.news.txt 431664 39918314   1867522      en    US.news
 en_US.twitter.txt 566951 36719658   2588551      en US.twitter

Source: /Users/jason/Coursera_datascience_specialization/10 Datascience Capstone/* on x86_64 by jason
Created: Tue Aug 21 12:54:48 2018
Notes: 

#Task2: EDA  
1. Exploratory analysis - perform a thorough exploratory analysis of the data, understanding the distribution of words and relationship between the words in the corpora.
library(readtext); library(quanteda); library(parallel); library(doParallel)
setwd("~/Coursera_datascience_specialization/10 Datascience Capstone")

corpus <- corpus(readtext("final/en_US/", docvarsfrom = "filenames"))
cl <- makeForkCluster(3)
registerDoParallel(cl)
init <- Sys.time()
init
trigramdfm <- dfm(corpus, tolower = T, remove_punct = T, remove_numbers = T, remove_twitter = T, ngrams = 3)
elasped <- Sys.time() - init
stopCluster(cl)


mydfm <- dfm(corpus, tolower = T, remove_punct = T, remove_numbers = T, ngrams = 1)
mydfm2 <- dfm_trim(mydfm, min_termfreq = 2)
mydfm3 <- dfm_trim(mydfm2, min_termfreq = 3)
mydfm4 <- dfm_trim(mydfm3, min_termfreq = 4)
mydfm5 <- dfm_trim(mydfm4, min_termfreq = 5)
topfeatures(mydfm5, groups = "docvar2")
topfeatures(mydfm5)
   one   said   just    get   like     go   time    can    day   year 
307902 305186 304843 301290 301118 266898 258628 248756 222912 214750 

textstat_frequency(mydfm5, n=10, groups="docvar2")
barplot(height = topfeatures(mydfm5,100), names.arg = names(topfeatures(mydfm5,100)), las=2, horiz = T, cex.names = 0.7)
textplot_wordcloud(mydfm, max_words=100, random_order = FALSE,
                   rotation = .25, 
                   color = RColorBrewer::brewer.pal(8,"Dark2"))
kwic(corpus[[1]][[1]][1:10], "just")
> mydfm5[,1:3]
Document-feature matrix of: 3 documents, 3 features (0% sparse).
3 x 3 sparse Matrix of class "dfm"
                   features
docs                  year thereaft  oil
  en_US.blogs.txt    66651      218 5897
  en_US.news.txt    106627      150 6055
  en_US.twitter.txt  41472       21 1452
> ncol(mydfm5)
[1] 124962
> names(mydfm5[,1:5])
NULL
> colnames(mydfm5[,1:5])
[1] "year"     "thereaft" "oil"      "field"    "platform"
>mydfm6 <- dfm_sort(mydfm5, margin = "features")
> colnames(mydfm6[,1:5])
[1] "one"  "said" "just" "get"  "like"

2. Understand frequencies of words and word pairs - build figures and tables to understand variation in the frequencies of words and word pairs in the data.

Questions to consider

Some words are more frequent than others - what are the distributions of word frequencies?
What are the frequencies of 2-grams and 3-grams in the dataset?
How many unique words do you need in a frequency sorted dictionary to cover 50% of all word instances in the language? 90%?
How do you evaluate how many of the words come from foreign languages?
Can you think of a way to increase the coverage -- identifying words that may not be in the corpora or using a smaller number of words in the dictionary to cover the same number of phrases?

Steps to create model:
#search trigrams
pattern <- #extract pattern from user input
hitindices <- grep("^thanks_for_", colnames(trigramsmall))
hitprobs <- trigramsmall[,hitindices]/length(hitindices)
tophits <- topfeatures(hitprobs,3)

if (length(tophits) < 3){
#search bigrams
tophits <- 
}

if (length(tophits) < 3){
#search unigrams
tophits <- 
}

