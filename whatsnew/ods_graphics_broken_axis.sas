
data TallBar;
  input X $ Y;
  length highcap $12;
  high=y; low=0;
  if y > 20 then do; high=20; highcap='FILLEDARROW'; end;
  datalines;
A  10
B  15
C  12
D  17
E  215
F  220
;
run;
ods path
  (prepend) work.mytemplate (update)
;
title;
/*--Template for Graph with regular Y axis--*/
proc template;
  define statgraph RegularAxis;
    begingraph;
      entrytitle 'Standard Bar Chart';
      layout overlay / xaxisopts=(display=(ticks tickvalues))
                       yaxisopts=(display=(ticks tickvalues) griddisplay=on);
      barchart category=x response=y / dataskin=gloss;
        discretelegend 'a';
    endlayout;
  endgraph;
  end;
run;

/*--Graph with regular Y axis--*/
/*ods graphics / reset width=5in height=3in imagename='BarChart_GTL';*/
proc sgrender data=TallBar template=RegularAxis;
run;

/*--Template for Graph with broken Y axis--*/
proc template;
  define statgraph BrokenAxis;
    begingraph;
      entrytitle 'Bar Chart with Broken Y axis';
      layout overlay / xaxisopts=(display=(ticks tickvalues))
                       yaxisopts=(display=(ticks tickvalues) griddisplay=on
                                  linearopts=(includeranges=(0-30 195-220) 
                                     tickvaluelist=(10 20 200 210 220)));
      barchart category=x response=y / dataskin=gloss;
        discretelegend 'a';
    endlayout;
  endgraph;
  end;
run;

/*--Graph with broken Y axis--*/
/*ods graphics / reset width=5in height=3in imagename='BarChartBrokenAxis_GTL';*/
proc sgrender data=TallBar template=BrokenAxis;
run;