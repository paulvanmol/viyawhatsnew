data printText;
  infile cards truncover;
  input @1 text $32767.;
  length sectionTitle $ 32;
  sectionTitle = catx(" ", "Section", put(_n_, z2.));
cards;
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut est vel lorem auctor venenatis ut ut nulla. Cras sollicitudin tempus lacinia. Nunc malesuada id leo nec auctor. Phasellus congue sem eget tortor feugiat consequat. Morbi tincidunt lectus nulla, vel tempus libero mollis vel. Pellentesque sodales elit sed dui pharetra mattis. Suspendisse id porta ligula, et auctor dolor. Suspendisse non erat ornare, tristique odio a, vestibulum ligula. Quisque tempor metus vel tellus dictum, eu iaculis orci molestie. Integer iaculis dui in ultrices vehicula. Praesent pellentesque lacinia sapien, ac tincidunt risus faucibus vitae.
Sed enim erat, ornare eget velit eu, euismod pretium lorem. Suspendisse potenti. Nulla facilisi. Donec molestie id augue vel vehicula. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris aliquam mattis nisl eu gravida. Vivamus sapien erat, auctor quis justo nec, viverra suscipit nibh. Aenean quam lectus, cursus eu est sed, malesuada pretium lectus. Vivamus cursus sapien at varius sagittis. Aliquam ultricies tincidunt enim, sed egestas nisi. Nunc bibendum diam quis odio consequat vehicula.
Mauris quis quam id quam venenatis cursus at a massa. In rhoncus ante vel vulputate mattis. Donec fringilla cursus risus, in faucibus magna elementum id. Praesent ullamcorper felis et vulputate mattis. Vestibulum eget dolor ut massa vehicula bibendum quis nec eros. Duis dapibus eleifend vestibulum. Nunc id mattis tellus. Duis sed turpis sapien. Cras vestibulum et massa non rhoncus. Ut elementum sem sit amet vestibulum mollis.
Sed ut ante nec leo porttitor porta nec id dui. Suspendisse vulputate id nunc ultricies cursus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Phasellus et leo dapibus, interdum metus sed, tristique enim. Cras nec arcu sit amet sapien bibendum euismod quis in mi. Phasellus elit ante, laoreet at facilisis vitae, euismod vitae ligula. Ut gravida a risus vitae sodales. Curabitur rhoncus urna iaculis lorem fermentum scelerisque. Duis eget augue id augue convallis aliquam. Curabitur mattis id erat vitae vestibulum. Praesent tincidunt sem vitae turpis mollis feugiat. Nam elementum, justo ac malesuada posuere, elit purus placerat enim, ut sodales tellus nibh ut sem. Curabitur nec mattis ipsum. Vestibulum bibendum, sem eu eleifend dictum, sapien leo laoreet libero, vel viverra massa dui et arcu.
Donec volutpat augue ac odio consequat consectetur a ac eros. Aliquam vel tristique neque. Pellentesque rutrum fermentum quam non condimentum. Aliquam vehicula convallis mi vel egestas. Quisque eget magna et mauris laoreet varius ac non metus. Nulla egestas dapibus euismod. Nunc rhoncus tortor lectus, ut interdum nulla varius id. Nam faucibus mauris nunc, non venenatis lacus elementum nec. Ut cursus elit aliquam adipiscing rhoncus. Vestibulum porttitor nunc sit amet eleifend malesuada. Phasellus non ornare augue. 
;

options nocenter;
ods epub file='c:\temp\sample.epub' 
  title="SAS ODS EPUB from %sysfunc( datetime(), datetime.)"
  options(creator="SAS user=&sysuserid")
  newchapter=proc
  nogtitle
;


title "Foreword";
proc odstext data=printText;
  p sectionTitle;
  p text / style={ background=cxd3d3d3 };
run;

options center;

title "Cars Analysis on Price";
proc univariate data=sashelp.cars;
  var invoice;
run;

title "Histogram for Car Prices";
proc sgplot data=sashelp.cars;
  histogram invoice;
run;
title;

ods epub close;
