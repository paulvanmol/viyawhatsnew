/*Using OECD XML Rest Api: */

*filename oecddata url 'https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/QNA/AUS+AUT.GDP+B1_GE.CUR+VOBARSA.Q/all?startTime=2009-Q2&endTime=2011-Q4&format=compact_v2'; 
%let homedir=%sysget(HOME);
%let homedir=c:/workshop;
%let path=&homedir/viyawhatsnew; 
%let xmlpath = &path/sdmx_query/;

filename map "&xmlpath.map.txt";
filename resp "&xmlpath.resp.txt";
proc http 
    URL="https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/QNA/BEL+AUT+NLD+DEU+FRA.GDP+B1_GE.CUR+VOBARSA.Q/all?startTime=2007-Q1&endTime=2022-Q4&format=compact_v2" 
    METHOD="GET"
    OUT=resp;
run;quit;

libname resp XMLv2 automap=REPLACE xmlmap=map;

proc datasets;
copy out=WORK in=resp;
run;quit;


proc sql;
%if %sysfunc(exist(WORK.QUERY_FOR_OBS1)) %then %do;
    drop table WORK.QUERY_FOR_OBS1;
%end;
%if %sysfunc(exist(WORK.QUERY_FOR_OBS1,VIEW)) %then %do;
    drop view WORK.QUERY_FOR_OBS1;
%end;
quit;
;
PROC SQL;
	CREATE TABLE WORK.QUERY_FOR_OBS1 AS
		SELECT
			(t2.DataSet_ORDINAL),
			(t2.Series_ORDINAL),
			(t2.Series_LOCATION),
			(t2.Series_SUBJECT),
			(t2.Series_MEASURE),
			(t2.Series_FREQUENCY),
			(t2.Series_TIME_FORMAT),
			(t2.Series_UNIT),
			(t2.Series_POWERCODE),
			(t2.Series_REFERENCEPERIOD),
			(t1.Series_ORDINAL) AS Series_ORDINAL1,
			(t1.Obs_ORDINAL),
			(t1.Obs_TIME),
			input(compress(t1.Obs_TIME,'-'),yyq6.) as Date format=yyq. ,
			(t1.Obs_OBS_VALUE),
			(t5.CompactData_ORDINAL),
			(t5.Header_ORDINAL),
			(t5.ID),
			(t5.Test),
			(t5.Truncated),
			(t5.'Prepared'n) FORMAT=IS8601DT19. INFORMAT=IS8601DT19.,
			(t6.Header_ORDINAL) AS Header_ORDINAL1,
			(t6.Sender_ORDINAL),
			(t6.Sender_id),
			(t7.DataSet_ORDINAL) AS DataSet_ORDINAL1,
			(t7.Annotations_ORDINAL),
			(t8.Annotations_ORDINAL) AS Annotations_ORDINAL1,
			(t8.Annotation_ORDINAL),
			(t8.AnnotationTitle),
			(t8.AnnotationURL)
		FROM
			WORK.OBS t1
				INNER JOIN WORK.SERIES t2 ON (t1.Series_ORDINAL = t2.Series_ORDINAL)
				INNER JOIN WORK.DATASET t3 ON (t2.DataSet_ORDINAL = t3.DataSet_ORDINAL)
				INNER JOIN WORK.COMPACTDATA t4 ON (t3.CompactData_ORDINAL = t4.CompactData_ORDINAL)
				INNER JOIN WORK.'HEADER'n t5 ON (t3.CompactData_ORDINAL = t5.CompactData_ORDINAL)
				INNER JOIN WORK.SENDER t6 ON (t5.Header_ORDINAL = t6.Header_ORDINAL)
				INNER JOIN WORK.ANNOTATIONS t7 ON (t3.DataSet_ORDINAL = t7.DataSet_ORDINAL)
				INNER JOIN WORK.ANNOTATION t8 ON (t7.Annotations_ORDINAL = t8.Annotations_ORDINAL)
	;
QUIT;
RUN;

proc sgplot data=work.query_for_obs1;
styleattrs datacontrastcolors=(cx1b9e77
cxd95f02
cx7570b3
cxe7298a
cx66a61e) datacolors=(cx1b9e77
cxd95f02
cx7570b3
cxe7298a
cx66a61e); 
title "Evolution of GDP in EUR by Country (Source OECD)";
label series_location="Country"; 
vline date /response=Obs_OBS_VALUE group=series_location name="gdpcurve" curvelabel 
      lineattrs=(thickness=5);
yaxis type=log label="GDP in EUR";
xaxis fitpolicy=thin notimesplit label=" "; 
quit; 
