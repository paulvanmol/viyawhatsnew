data labs (keep=patient relday sday alat biltot alkph asat miny);
   length patient $50;
   label alat="ALAT";
   label biltot="Bilirubin Total";
   label alkph="Alk Phos";
   label asat="ASAT";
   label relday="Day";
   label miny="Trial Duration";

   patient="Patient 5152: White Male Age 48; Drug: A";
   do relday = -25 to 175 by 25;
      alat = 0.5 + 4 * sin(3.14 * (relday+25) / 360.0);
      asat = 0.5 + 3 * sin(3.14 * (relday+25) / 400.0);
      alkph = 0.4 + 2 * sin(3.14 * (relday+25) / 540.0);
      biltot = 0.4 + 1 * sin(3.14 * (relday+25) / 320.0);
      miny=-0.5;
      sday=relday;
      if relday < 0 or relday > 150 then do;
         miny = .;
         sday=.;
      end;
      output;
   end;

   patient="Patient 6416: White Male Age 64; Drug: A";
   do relday = -25 to 70 by 15;
      alat = 1.5 + 2 * sin(3.14 * (relday+25) / 540.0);
      asat = 1.0 + 1 * sin(3.14 * (relday+25) / 540.0);
      alkph = 0.5 + 2 * sin(3.14 * (relday+25) / 360.0);
      biltot = 1.5 + 1 * sin(3.14 * (relday+25) / 360.0);
      miny=-0.5;
      sday=relday;
      if relday < 0 or relday > 60 then do;
         miny = .;
         sday=.;
      end;
      output;
   end;

   patient="Patient 6850: White Male Age 51; Drug: A";
   do relday = -25 to 175 by 25;
      alat = 2 + 1 * sin(3.14 * (relday+25) / 90);
      asat = 1.2 + 1 * sin(3.14 * (relday+25) / 100);
      alkph = 0.7 + 0.5 * sin(3.14 * (relday+25) / 120);
      biltot = 0.3 + 0.2 * sin(3.14 * (relday+25) / 110);
      miny=-0.5;
      sday=relday;
      if relday < 0 or relday > 150 then do;
         miny = .;
         sday=.;
      end;
      output;
   end;

   patient="Patient 6969: White Female Age 48; Drug: B";
   do relday = -25 to 175 by 25;
      alat = 0.5 + 1.5 * sin(3.14 * (relday+25) / 540);
      asat = 0.6 + 1.2 * sin(3.14 * (relday+25) / 480);
      alkph = 0.7 + 1 * sin(3.14 * (relday+25) / 600);
      biltot = 0.3 + 1 * sin(3.14 * (relday+25) / 500);
      miny=-0.5;
      sday=relday;
      if relday < 0 or relday > 150 then do;
         miny = .;
         sday=.;
      end;
      output;
   end;
run;

ods listing close;
ods html file='riskpanel.html' path='.' style=statistical ;
ods graphics / reset width=600px height=400px imagename='RiskPanel' imagefmt=gif ;

title "Liver Function Tests by Trial Day: At Risk Patients";
footnote1 ' ';
footnote2 j=l italic height=8pt
    " For ALAT, ASAT and Alkaline Phosphatase, the Clinical Concern Level is 2 ULN;";
footnote3 j=l italic height=8pt
     " For Bilirubin Total, the CCL is 1.5 ULN: "
     "where ULN is the Upper Level of Normal";

proc sgpanel data=labs cycleattrs;
   panelby patient / novarname;
   series x=relday y=alat / markers lineattrs=(thickness=2px pattern=solid);
   series x=relday y=asat / markers lineattrs=(thickness=2px pattern=solid);
   series x=relday y=alkph / markers lineattrs=(thickness=2px pattern=solid);
   series x=relday y=biltot / markers lineattrs=(thickness=2px pattern=solid);
   band x=sday lower=miny upper=4.5 / transparency=0.8 legendlabel='Trial Duration';
   refline 1 1.5 2 / axis=Y lineattrs=(pattern=dash);
   colaxis min=-50 max= 200 offsetmin=.1 display=(nolabel);
   rowaxis label="Upper Limit Normal";
run;

ods html close;
ods listing;

