#Project 1 
#Data Analytics with R program 
#Objective :- To crawl, parse and extract all articles published in DNA Research Journal
#2020 Spring

#Journal Name: DNA Research
#Journal Main page url link:-https://academic.oup.com/dnaresearch
projectdnares <- function(a){
  
  library(bitops)
  library(RCurl)
  library(XML)
  library(stringr)
  #a <- 2019
  required_output <- matrix(c("Title",  "Authors",  "Author  Affiliations",  "Correspondence  Author",  "Correspondence  Author's Email", "Publish Date", "Abstract", "Keywords", "Full Paper","DOI"),1,10)
  write.table(required_output, "Summary.csv", row.names = FALSE, col.names=FALSE, sep = ",",append = F)
  site.url = "https://academic.oup.com/dnaresearch/"
  base.url <- "https://academic.oup.com"
  y <- 1993
  z <- a - y
  #Journal has issues from 1994 till 2019 with 1994 labelled as Vol 1.
  x <- toString(z)
  year <- x
  #for loop runs till 26 which is 2019
  for (year in x:26) {
  print(c("your input year is ",year))
  URL.temp.1 <- paste(site.url, "issue/", year,"/", sep="")
  #Each Volume has 6 issues
  for(i in 1:6) {
    URL <- paste(URL.temp.1,toString(i),"/", sep="")
    main.page = readLines(paste(URL, sep=""))
    options(warn=-1)
    
    doc = htmlParse(main.page, asText=TRUE)
    article.list <- xpathSApply(doc, "//*[@id='ArticleList']", xmlValue)
    #article.id.index <- gregexpr("https://doi.org/10.1093/dnares/((([0-9]+)(.)([0-9]+)(.)([0-9]+))|(([a-z]+)([0-9]+))", article.list)
    article.id.index <- gregexpr("https://doi.org/10.1093/dnares/((([0-9]+)(.)([0-9]+)(.)([0-9]+))|(([a-z]+)([0-9]+)))", article.list)
    article.id.index.1 <- gregexpr("(([0-9]+)(.)([0-9]+)(.)([0-9]+))$", article.list)
    article.id = regmatches(article.list, article.id.index)
    print(article.id)
    
for (id in article.id[[1]]){
  article.page.content <- readLines(id)
  atricle.doc <- htmlParse(article.page.content, asText=TRUE)
  DOIData <- xpathSApply(atricle.doc, "//*[@id='Toolbar']/li[1]/a")
  DOIData <- as(DOIData[[1]], "character")
  DOI1 <- gregexpr("data-article-id=(.*?) ", DOIData)
  DOI2 <- regmatches(DOIData, DOI1)
  DOI <- gsub("data-article-id=\"| |\"", "", DOI2[[1]][1])
  print ("DOI")
  print (DOI)
  DOI<-paste(DOI,collapse = ",")
  link.content <- gregexpr("href=(.*?)>", DOIData)
  links <- regmatches(DOIData, link.content)
  articlelink <- gsub("href=\"|\"|>", "", links[[1]][1])
  print ("ARTICLE FULL LINK")
  FullLink <- paste(base.url,articlelink, sep="")
  print (FullLink)
  FullLink<-paste(FullLink,collapse = ",")
  #atricle.doc<-str_replace_all(atricle.doc,"[\r\n]","")
  title <- str_trim(xpathSApply(atricle.doc, "//*[@id='ContentColumn']/div[2]/div[1]/div/div/h1", xmlValue)[[1]])
  print ("ARTICLE TITLE:")
  print (title)
  title<-paste(title,collapse = ",")
  Pdate <- as(xpathSApply(atricle.doc, "//*[@id='ContentColumn']/div[2]/div[1]/div/div/div[2]/div[2]/div/div[2]/text()")[[1]],"character")
  print ("ARTICLE PUBLISHED DATE:")
  print (Pdate)
  Pdate<-paste(Pdate,collapse = ",")
  Abstractfull <- xpathSApply(atricle.doc, "//*[@id='ContentTab']/div[1]/div/div/section/p", xmlValue)[[1]]
  print ("ARTICLE ABSTRACT:")
  print (Abstractfull)
  Abstractfull<-paste(Abstractfull,collapse = ",")
  author <- as(xpathSApply(atricle.doc, "//*[@id='ContentColumn']/div[2]/div[1]/div/div/div[1]")[[1]], "character")
  name <- gregexpr("<div class=\"info-card-name\">(.*?)</div>", author)
  nameList <- regmatches(author, name)
  authorName <- gsub("<div class=\"info-card-name\">|</div>", "", nameList[[1]])
  print ("AUTHOR NAMES")
  print (authorName)
  authorName<-paste(authorName,collapse = ",")
  affiliation <-  gregexpr("<div class=\"insititution\">(.*?)</div>", author)
  affiliationList <- regmatches(author, affiliation)
  authorAffiliation <- gsub("<div class=\"insititution\">|</div>", "", affiliationList[[1]])
  if(length(authorAffiliation)==0){
    authorAffiliation <- "NA"}else{
       authorAffiliation<-paste(authorAffiliation,collapse = ",")
    }
  print (authorAffiliation)
  cauth <- gregexpr("<div class=\"info-card-name\">(.*)<div class=\"info-author-correspondence\">", author)
  cauth1 <- regmatches(author, cauth)
  cauth2 <- gregexpr("<div class=\"info-card-name\">(.*?)</div>", cauth1[[1]][1])
  cauthList <- regmatches(cauth1[[1]][1], cauth2)
  cauthName <- gsub("<div class=\"info-card-name\">|</div>", "", tail(cauthList[[1]], 1))
  print ("CORRESPONDING AUTHOR NAME")
  if(length(cauthName)==0){
    cauthName <- "NA"}else{
      cauthName<-paste(authorAffiliation,collapse = ",")
    }
  print (cauthName)
  #cmail <- gregexpr("<a href=\"mailto:(.*?) ", author)
  #cmail1 <- regmatches(author, cmail)
  #cmail2 <- str_sub(cmail1, start = 17, end = -3)
  cmail <- "NA"
  print ("CORRESPONDING AUTHOR MAIL ID")
  print (cmail)
  authorAffiliation<-paste(authorAffiliation,collapse = ",")
  #article.full.article <- xpathSApply(atricle.doc, "//*[@id='ContentTab']/div[1]/div/div/div[2]/div/a", xmlValue)[[1]]
  print ("KEYWORDS:")
  keywords <- xpathSApply(atricle.doc, "//*[@id='ContentTab']/div[1]/div/div/div[2]", xmlValue)
  print(keywords)
  keywords<-paste(keywords,collapse = ",")
  information=c(title, authorName, authorAffiliation, cauthName, cmail, Pdate, Abstractfull, keywords, FullLink, DOI)
  required_output <- matrix(information,1,10)
  write.table(required_output, "Summary.csv", row.names = FALSE, col.names=FALSE, sep = ",",append = T)
  }  
  }
}
}
