data maps_ch_fmt;
  set maps.switzer2;
  type = "N";
  fmtname = "maps_ch";
  start = id;
  label = idname;
  keep type fmtname start label;
run;

proc format cntlin=maps_ch_fmt;
run;

data mapdata_ch;
  set maps.switzerl end=last;
  by id segment;
  id_c = catx("_", id, segment);
  tipID = catx(id_c, put(id, maps_ch.));
run;

ods graphics / 
  width=1600 height=1200 
  imagemap
  LABELMAX=10000
  tipmax=10000
;
title "CH Maps using MAPS.SWITZERL with density <= 3";

proc sgplot data=mapdata_ch;
  * reduce number to get less border points;
  where density <= 3;
  polygon x=x y=y id = id_c /
    group=id
    fill
    outline
    lineattrs=(color=black)
    tip=(tipID)
  ;
  format id maps_ch.;
  xaxis display=none;
  yaxis display=none;
run;

PROC SQL;
  CREATE TABLE WORK.ch_attr_kanton AS 
    SELECT DISTINCT
      t1.ID1 
      , t1.ISO
      , t1.ID1NAME
      , t1.ID1NameU
      /* id1name_u2 */

  , (unicode(t1.ID1NameU)) AS id1name_u2
  FROM
    MAPSGFK.SWITZERLAND_ATTR t1
  ;
QUIT;

data gfkid2kt;
  set ch_attr_kanton;
  fmtname = "gfkid2kt";
  type = "C";
  start = id1;
  label = catx("_", id1, id1name_u2);
  keep fmtname type start label;
run;

proc format cntlin=gfkid2kt;
run;

data mapdata_chgfk;
  set mapsgfk.switzerland end=last;
  * ohne liechtenstein;
  where id1 le "CH-26";

  by id id1 segment;
  id_c = catx("_", id, id1, segment);
  ktname = put(id1, $gfkid2kt40.);
run;

title "CH Maps using MAPSGFK.SWITZERLAND with density <= 3";

proc sgplot data=mapdata_chgfk;
  * reduce number to get less border points;
  where density <= 3;
  polygon x=x y=y id = id_c /
    group=ktname
    fill
    outline
    lineattrs=(color=black)
    tip=(ktname)
  ;
  xaxis display=none;
  yaxis display=none;

run;

proc gremove
  data=mapsgfk.switzerland
  out=map_gfk_ch
;
  by id1;
  id id;
run;

data mapdata_chgfk_kt;
  set map_gfk_ch end=last;

  * ohne liechtenstein;
  where id1 le "CH-26";
  by id1 segment;
  id_c = catx("_", id1, segment);
  ktname = put(id1, $gfkid2kt40.);
run;

title "CH Maps using MAPSGFK.SWITZERLAND without inner boundaries with density <= 4";
proc sgplot data=mapdata_chgfk_kt;
  * reduce number to get less border points;
  where
    density <= 4
  ;
  polygon x=long y=lat id = id_c /
    group=ktname
    fill
    outline
    lineattrs=(color=black)
    tip=(ktname)
  ;
  xaxis display=none;
  yaxis display=none;

run;
title;

* find center of polygon ;
proc sql;
  create table ch_scatter as
    select
      ktname
      , avg(long) as longavg
      , avg(lat) as latavg
    from
      mapdata_chgfk_kt
    group by
      ktname
  ;
quit;

* add mapdata and center of polygon together ;
data poly_scatter;
  set mapdata_chgfk_kt ch_scatter; 
run;

title "CH Maps using MAPSGFK.SWITZERLAND without inner boundaries with density <= 3";
title2 "Polygon center marked";
proc sgplot data=poly_scatter noautolegend;
  * reduce number to get less border points;
  where
    density <= 4
  ;
  polygon x=long y=lat id = id_c /
    group=ktname
    fill
    outline
    lineattrs=(color=black)
    tip=(ktname)
  ;

  scatter x=longavg y=latavg  /
    markerattrs=(symbol=plus size=10 color=cxff0000)
    datalabel=ktname
  ;

  xaxis display=none;
  yaxis display=none;
run;
title;
