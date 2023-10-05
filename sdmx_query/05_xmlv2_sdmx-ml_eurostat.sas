/*Example Eurostat SDMX data: https://ec.europa.eu/eurostat/web/sdmx-web-services/rest-sdmx-2.1*/
/*
https://ec.europa.eu/eurostat/SDMX/diss-web/rest/data/nama_10_gdp/.CLV10_MEUR.B1GQ.BE/?startperiod=2005&endPeriod=2011
https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/NAMA_10_GDP/?format=sdmx_2.1_generic
*/
%let path=c:\workshop\sdmx;
%let path = &path;

filename map "&path.map.txt";
filename resp "&path.resp.txt";
proc http 
    URL="https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/NAMA_10_GDP/?format=sdmx_2.1_generic" 
    METHOD="GET"
    OUT=resp;
run;quit;

libname resp XMLv2 automap=REPLACE xmlmap=map;
libname estat "C:\workshop\viyawhatsnew\sdmx_query\estat"; 
proc datasets;
copy out=estat in=resp;
run;quit;



PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_OBSVALUE_0000 AS 
   SELECT t1.Obs_ORDINAL, 
          t1.ObsValue_ORDINAL, 
          t1.ObsValue_value1, 
          t3.ObsDimension_ORDINAL, 
          t3.ObsDimension_value1, 
          t2.Series_ORDINAL, 
          t6.DataSet_structureRef, 
          t10.ID, 
          t10.Test, 
          t10.Prepared, 
          t10.DataSetID, 
          t10.Extracted, 
          t11.SeriesKey_ORDINAL, 
          t11.Value_ORDINAL, 
          t11.Value_id, 
          t11.Value_value1, 
          t12.Attributes_ORDINAL, 
          t12.Value1_ORDINAL, 
          t12.Value1_id, 
          t12.Value1_value2
      FROM ESTAT.OBSVALUE t1
           LEFT JOIN ESTAT.OBS t2 ON (t1.Obs_ORDINAL = t2.Obs_ORDINAL)
           LEFT JOIN ESTAT.OBSDIMENSION t3 ON (t1.Obs_ORDINAL = t3.Obs_ORDINAL)
           LEFT JOIN ESTAT.SERIES t4 ON (t2.Series_ORDINAL = t4.Series_ORDINAL)
           LEFT JOIN ESTAT.SERIESKEY t5 ON (t2.Series_ORDINAL = t5.Series_ORDINAL)
           LEFT JOIN ESTAT.DATASET t6 ON (t4.DataSet_ORDINAL = t6.DataSet_ORDINAL)
           LEFT JOIN ESTAT.ATTRIBUTES t8 ON (t1.Obs_ORDINAL = t8.Obs_ORDINAL)
           LEFT JOIN ESTAT.HEADER t10 ON (t6.GenericData_ORDINAL = t10.GenericData_ORDINAL)
           LEFT JOIN (ESTAT.STRUCTURE t7
           LEFT JOIN ESTAT.STRUCTUREUSAGE t9 ON (t7.Structure_ORDINAL = t9.Structure_ORDINAL)) ON (t10.Header_ORDINAL = 
          t7.Header_ORDINAL)
           LEFT JOIN ESTAT.VALUE t11 ON (t5.SeriesKey_ORDINAL = t11.SeriesKey_ORDINAL)
           LEFT JOIN ESTAT.VALUE1 t12 ON (t8.Attributes_ORDINAL = t12.Attributes_ORDINAL),ESTAT.STRUCTURE t7
           LEFT JOIN ESTAT.STRUCTUREUSAGE t9 ON (t7.Structure_ORDINAL = t9.Structure_ORDINAL);
QUIT;
