
/*
Example 52.2 Retrieving Data by Using Three Quandl Codes

This example shows how to use three Quandl codes of different native frequencies to retrieve quarterly data for corporateprofits after tax (FRED/CP), gross domestic product (FRED/GDP), and total consumer credit owned and securitized, outstanding(TOTALSL). The output is shown in Output 52.2.1. 
*/
 
title 'Retrieve Data for Three Time Series: FRED/CP, FRED/GDP, FRED/TOTALSL';
libname _all_ clear;
options validvarname=any dlcreatedir
  /* sslcalistloc="/SASSecurityCertificateFramework/1.1/cacerts/trustedcerts.pem"*/;

libname mylib "C:/workshop/viyawhatsnew/sdmx_query/quan/doc/";



libname myQ3 sasequan "C:/workshop/viyawhatsnew/sdmx_query/quan/test/"
   OUTXML=fred3
   AUTOMAP=replace
   MAPREF=MyMap
   XMLMAP="C:/workshop/viyawhatsnew/sdmx_query/quan/test/fred3.map"
   APIKEY='mSqQTwCPgzkiy2KxUjzM'
   IDLIST='FRED/CP,FRED/GDP,FRED/TOTALSL'
   FORMAT=xml
   START='2009-07-01'
   END='2013-07-01'
   FREQ='quarterly'
   COLLAPSE='quarterly'
   ;

data mylib.thrall;
   set myQ3.fred3;
   label Value_1 = "Corporate Profits After Tax";
   label Value_2 = "Gross Domestic Product, 1 Decimal";
   label Value_3 = "Total Consumer Credit Owned and Securitized, Outstanding";
run;

proc contents data=mylib.thrall; run;
proc print data=mylib.thrall label; run;

options validvarname=any
   /*sslcalistloc="/SASSecurityCertificateFramework/1.1/cacerts/trustedcerts.pem"*/;

title 'Historical Prices for Oil India Limited';
libname _all_ clear;
libname mylib "C:/workshop/viyawhatsnew/sdmx_query/quan/doc";

/* export QUANDL=/sasusr/playpens/saskff/quan/test/ */

libname myQoil sasequan "C:/workshop/viyawhatsnew/sdmx_query/quan/test"
   apikey='mSqQTwCPgzkiy2KxUjzM'
   idlist='NSE/OIL'
   format=XML
   outXml=oil
   automap=replace
   mapref=MyMap
   xmlmap="C:/workshop/viyawhatsnew/sdmx_query/quan/oil.map"
   start='2013-09-01'
   end='2013-11-05'
   freq='daily'
   collapse='daily'
   ;

data mylib.oilall;
   set myQoil.oil;
run;

proc contents data=mylib.oilall; run;
proc print data=mylib.oilall; run;

