options nodate;
title;
ods escapechar="~";
footnote "~{style [font_size=10pt just=right color=cxbbb2e0]Provided to you by SAS&sysver and ODS Absolute Layout features.}";
ods path
  (prepend) work.template (update)
;

proc template; 
  define style Styles.Orionbackground; 
    parent=Styles.Printer;
    style body / 
      background=cx494068
    ;
  end;
run;

ods pdf file="c:\temp\Color3.pdf" style=Styles.Orionbackground notoc;

data _null_;
  dcl odsout trt();
  trt.layout_absolute();
  trt.region(y: "5in", style_attr:"backgroundcolor=orange");
  trt.format_text(data:  "Executive Prospectus",   just: "c",   style_attr:"font_size=36pt color=cxbbb2e0");
  trt.region(y:  "3in", x: "3in", style_attr:"backgroundcolor=yellow");
  trt.format_text(data:  "Sports & Outdoors", style_attr:"color=cxbbb2e0 font_size=28pt");
  trt.region(y:  "2in", style_attr:"backgroundcolor=red");
  trt.format_text(data:  "Orion Star", just: "c", style_attr: "color=cxbbb2e0 just=center font_size=72pt");
  trt.region(y: "7in", style_attr:"backgroundcolor=blue");
  trt.format_text(data:  "For years 1999 through 2002", just: "c", style_attr:"font_size=20pt color=cxbbb2e0");
  trt.layout_end();
run;

ods pdf close;

options date;