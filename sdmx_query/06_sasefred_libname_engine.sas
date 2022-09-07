/*https://support.sas.com/documentation/onlinedoc/ets/132/sasefred.pdf*/
/*
Example 39.1: Retrieving Data for Multiple Time Series
This example shows how to use multiple time series IDs to retrieve the average balance of payment basis
data for the exports (BOPXGS) and imports (BOPMGS) of goods and services for the last 15 years, starting
1997-01-01 and ending 2011-01-01, with an annual frequency.
*/
title 'Retrieve Balance of Payment Data for the Exports and Imports';
libname _all_ clear;
libname fred sasefred "C:\workshop\viyawhatsnew\sdmx_query\freddata"
OUTXML=fredex01
AUTOMAP=replace
MAPREF=MyMap
XMLMAP="C:\workshop\viyawhatsnew\sdmx_query\freddata\fredex01.map"
APIKEY='399eb04a24a59583574beeaa2248db31'
IDLIST='bopxgs,bopmgs'
START='1997-01-01'
END='2011-01-01'
FREQ='a'
OUTPUT=1
AGG='avg'
FORMAT=xml;
data export_import;
set fred.fredex01 ;
run;
proc contents data=export_import; run;
proc print data=export_import; run;

/*https://fred.stlouisfed.org/series/PSUNOUSDM*/

title 'sunflower oil global price';
libname _all_ clear;
libname fred sasefred "C:\workshop\viyawhatsnew\sdmx_query\freddata"
OUTXML=fredex01
AUTOMAP=replace
MAPREF=MyMap
XMLMAP="C:\workshop\viyawhatsnew\sdmx_query\freddata\fredex01.map"
APIKEY='399eb04a24a59583574beeaa2248db31'
IDLIST='PSUNOUSDM'
START='1990-01-01'
END='2022-07-01'
FREQ='m'
OUTPUT=1
AGG='avg'
FORMAT=xml;
data export_import;
set fred.fredex01 ;
run;
proc contents data=export_import; run;
proc print data=export_import; run;

proc sgplot dta=export_import; 
vline date /response=psunousdm;
run; 