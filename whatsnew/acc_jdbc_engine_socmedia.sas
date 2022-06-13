/*SAS Communities Article: Acccessing Social Media from SAS Viya with embedded CDATA JDBC drivers
https://communities.sas.com/t5/SAS-Communities-Library/Accessing-Social-Media-data-and-more-from-SAS-Viya-with-embedded/ta-p/805117
*/
options sastrace="d,,," sastraceloc=saslog nostsuffix ;
libname test jdbc url="jdbc:dummy" ;

/*JDBC CDATA documentation */
/*
https://go.documentation.sas.com/doc/en/pgmsascdc/v_024/acreldb/p13cscrpcsklv0n1lz082i39xwiw.htm
*/
%let tw_string=%nrbquote(jdbc:twitter:UseAppOnlyAuthentication="True";InitiateOAuth="GETANDREFRESH";OAuthClientSecret="9CySY7Ph1YfW6N4K...";_persist_oauthaccesstokensecret=WhY5Rs6iStfp...) ;

libname tw jdbc
   url="&tw_string" 
   preserve_names=yes ;

/* List tables and views */
proc datasets lib=tw ;
quit ;

/* Search a string */
/* Pseudo-column to specify a search at run time */
data tweets ;
   set tw.tweets(obs=100) ;
   where SearchTerms="Olympics" ;
run ;

/* Extract Trends from another country */
/* WoeId = WhereOnEarth Id */
/* https://www.findmecity.com/index.html */
data trends ;
   set tw.trends ;
   where WoeId="23424819" ;
run ;

/* Get table information */
data _null_ ;
   dsid=open("sashelp.prdsale") ;
   call symput("nbvars",strip(put(attrn(dsid,"NVARS"),8.))) ;
   call symput("nbobs",strip(put(attrn(dsid,"NOBS"),8.))) ;
   dsid=close(dsid) ;
run ;

/* Insert a Tweet */
proc sql ;
   insert into tw.tweets(Text) values ("Hello from GEL: my favorite SASHELP.PRDSALE table has &nbvars variables and &nbobs observations !") ;
quit ;
