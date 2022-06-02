ods graphics / ATTRPRIORITY=none border=on;
Title 'Weight by Height by Gender for Class';

proc sgplot data= sashelp.class;
  symbolchar name=male char='2642'x / textattrs=(family='Arial Unicode MS' weight=bold);
  symbolchar name=female char='2640'x / textattrs=(family='Arial Unicode MS' weight=bold);
  styleattrs datasymbols=(male female);
  scatter y=weight x=height / group=sex name='a' markerattrs=(color=black size=30);
    
  keylegend / location=inside position=topleft opaque;
  xaxis grid offsetmin=0.05 offsetmax=0.05;
  yaxis grid offsetmin=0.05 offsetmax=0.05;;
run;