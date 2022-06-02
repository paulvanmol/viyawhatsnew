proc template;
   define style listingSmallFont; 
      parent = styles.listing; 
      style GraphFonts from GraphFonts                                                      
         "Fonts used in graph styles" /                                                     
         'GraphUnicodeFont' = ("",9pt)                  
         'GraphValueFont' = (", ",8pt)              
         'GraphLabelFont' = (", ",9pt)        
         'GraphFootnoteFont' = (", ",8pt)          
         'GraphTitleFont' = (", ",11pt,bold); 
   end;
run;

data labs_data (keep=drug alat biltot alkph asat
     palat pbiltot palkph pasat visitnum);
   label alat="ALAT (/ULN)";
   label biltot="BILTOT (/ULN)";
   label alkph="ALKPH (/ULN)";
   label asat="ASAT (/ULN)";
   visitnum=1;
   do i=1 to 100;
      palat = min (4, 2.5 * (abs(rannor(123))) / 3.0);
      pbiltot = min (4, 2.5 * (abs(rannor(123))) / 3.0);
      palkph = min (4, 2.5 * (abs(rannor(123))) / 3.0);
      pasat = min (4, 2.5 * (abs(rannor(123))) / 3.0);
      alat = min (4, 2.5 * (abs(rannor(345))) / 3.0);
      biltot = min (4, 2.5 * (abs(rannor(345))) / 3.0);
      alkph = min (4, 2.5 * (abs(rannor(345))) / 3.0);
      asat = min (4, 2.5 * (abs(rannor(345))) / 3.0);
      j =  rannor(345);
      if j > 0 then drug = "A";
      else drug="B";
      output;
   end;
   visitnum=2;
   do i=1 to 100;
      palat = min (4, 2.5 * (abs(rannor(789))) / 3.0);
      pbiltot = min (4, 2.5 * (abs(rannor(789))) / 3.0);
      palkph = min (4, 2.5 * (abs(rannor(789))) / 3.0);
      pasat = min (4, 2.5 * (abs(rannor(789))) / 3.0);
      alat = min (4, 2.5 * (abs(rannor(567))) / 3.5);
      biltot = min (4, 2.5 * (abs(rannor(567))) / 3.5);
      alkph = min (4, 2.5 * (abs(rannor(567))) / 3.5);
      asat = min (4, 2.5 * (abs(rannor(567))) / 3.5);
      j =  rannor(567);
      if j > 0 then drug = "A";
      else drug="B";
      output;
   end;
   visitnum=3;
   do i=1 to 100;
      palat = min (4, 2.5 * (abs(rannor(321))) / 3.0);
      pbiltot = min (4, 2.5 * (abs(rannor(321))) / 3.0);
      palkph = min (4, 2.5 * (abs(rannor(321))) / 3.0);
      pasat = min (4, 2.5 * (abs(rannor(321))) / 3.0);
      alat = min (4, 2.5 * (abs(rannor(975))) / 2.5);
      biltot = min (4, 2.5 * (abs(rannor(975))) / 2.5);
      alkph = min (4, 2.5 * (abs(rannor(975))) / 2.5);
      asat = min (4, 2.5 * (abs(rannor(975))) / 2.5);
      j =  rannor(975);
      if j > 0 then drug = "A";
      else drug="B";
      output;
   end;
run;

proc format;
   value wk
     1='1 Week'
     2='3 Months'
     3='6 Months';
   value lab
     1='ALAT'
     2='Bilirubin Total'
     3='Alk Phosphatase'
     4='ASAT';
   value $trt
     "A"="Drug A (n=240)"
     "B"="Drug B (n=195)";
run;

data labs (keep=visitnum drug labtest result pre);
   format visitnum wk. labtest lab. drug $trt.;
   set labs_data;
   pre=palat;
   labtest=1;
   result=alat;
   output;
   pre=pbiltot;
   labtest=2;
   result=biltot;
   output;
   pre=palkph;
   labtest=3;
   result=alkph;
   output;
   pre=pasat;
   labtest=4;
   result=asat;
   output;
run;

/*ods listing close;*/
/*ods html file='safety.html' path='.' style=listingSmallFont;*/
ods graphics on / reset imagefmt=gif width=600px height=400px
                  imagename='ClinicalHandout_SafetyPanel';

title 'LFT Safety Panel, Baseline vs. Study';
title2 ' ';
footnote1 ' ';
footnote2 j=l italic height=8pt
    "* For ALAT, ASAT and Alkaline Phosphatase,"
    " the Clinical Concern Level is 2 ULN;";
footnote3 j=l italic height=8pt
    " For Bilirubin Total, the CCL is 1.5 ULN: "
    "where ULN is the Upper Level of Normal";

proc sgpanel data=labs;
   panelby labtest visitnum / layout=lattice onepanel novarname;
   scatter x=pre y=result / group=drug markerattrs=(size=9);
   refline 1 1.5 2 / axis=Y lineattrs=(pattern=dash);
   refline 1 1.5 2 / axis=X lineattrs=(pattern=dash);
   rowaxis integer min=0 max=4 label='Study (/ULN)';
   colaxis integer min=0 max=4 label='Baseline (/ULN) *';
   keylegend / title=" " noborder;
run;
/**/
/*ods html close;*/
/*ods listing;*/