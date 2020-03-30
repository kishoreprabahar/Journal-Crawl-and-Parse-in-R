# Journal-Crawl-and-Parse-in-R

In  this  project,  you  will  build  a  specialized  R  program  to  crawl,  parse  and  extract  useful information  from  online  websites.  Here,  we  select  13  similar  journals  for  this  project. 

Given an input year, your objective is to extract all articles published in/after that year from your  selected  journal.  As  a  start  point,  you  are  required  to  extract  the  following  9  fields  for each article:Title,  Authors,  Author  Affiliations,  Correspondence  Author,  Correspondence  Author's Email, Publish Date, Abstract, Keywords, Full Paper (Text format).
The  Summary.xlsx  file,  which  lists  the  details  about  each  field  in  each  journal.  You  could ignore one or two fields in your implementation, if they are not available (marked as NA) for your  selected  journal.  
Given  an  input  year,  your  program  is  expected  to  crawl  the  journal’s website  automatically,  and  parse  and  extract  useful  fields  for  each  crawled  article.  
The program  is  expected  to  store  the  extracted  information  into  a  plain  file  elegantly.  (One column for one field.)In the final submission, please encapsulate your program into a function which will take the year as a parameter. Please submit both the runnable code and the crawled data. Please make sure  your  stored  data  could  be  easily  read  into  R  again,  as  the  extracted  text  may  contain some special characters. 


Website Crawled: "https://academic.oup.com/dnaresearch/"
