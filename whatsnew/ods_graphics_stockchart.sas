proc sort data=sashelp.stocks out=stocks; 
   by date; 
run;

data splitIBM;
   length split $3;
   set stocks(where=(stock="IBM"));
   label volume='(millions)';
   volume=volume/1000000;
   if date < '01MAY97'd then do;
      open = open / 4;
      close = close/4;
      high=high / 4;
      low=low/4;
   end;
   else if date ='01MAY97'd then do;
      open = open / 4;
      close = close/2;   /*Anomaly in data  */
      high=high / 4;
      low=low/2;         /*Anomaly in data  */
      split="2/1";
      freq=1;
   end;
   else if date <'03MAY99'd then do;
      open = open / 2;
      close = close/2;
      high=high / 2;
      low=low/2;
   end;
   else if date ='03MAY99'd then do;
      open = open / 2;
*     close = close/2; /*Anomaly in data  */
      high=high / 2;
*     low=low/2;       /*Anomaly in data  */
      split="2/1";
      freq=1;
   end;
run;

/* proc print data=splitIBM; run; */

data moveavg(drop=move25index move50index);
   set splitIBM;
   retain closehigh prevvolume;
   array move25[25] _temporary_; 
   array move50[50] _temporary_;     
   array vmove25[25] _temporary_; 
   format close high low avg25 avg50 vavg dollar8.0;
   move25index=mod(_n_,25);  
   move50index=mod(_n_,50);
   vmove25index=mod(_n_,25);  
   move25index =ifn(move25index,move25index,25);
   move50index =ifn(move50index,move50index,50); 
   vmove25index =ifn(vmove25index,vmove25index,25);
   move25[move25index]=close; 
   move50[move50index]=close;
   vmove25[vmove25index]=volume; 
   if _n_ ge 25 then do;
      avg25=mean(of move25[*]);
      vavg=mean(of vmove25[*]);
      bolupper= avg25 + (2*std(of move25[*]));
      bollower= avg25 + (-2*std(of move25[*]));
   end;
   if _n_ ge 50 then avg50=mean(of move50[*]);  
   if _n_ gt 1 then do;
      if close gt closehigh then do;
         cindex = 1;
         closehigh = close;
      end;
      else do;
         cindex = 2;
         closehigh=closehigh;
      end;

      if volume gt prevvolume then vindex = 1;
      else vindex = 2;
      prevvolume=volume;
   end;
   else do;
      closehigh=close;
      prevvolume=volume;
      cindex=1;
      vindex=1;
   end;
run;
/* */
/*ods listing close;*/
/*ods html file='Stock.html' path='.' style=listing;                                                                                                                      */
ods graphics / reset width=600px height=400px imagename="Stock" imagefmt=gif;

Title1 "Daily Stock Chart";
proc sgplot data=moveavg(where=(date>='01jan2000'd));
   yaxis grid label="Stock Value";
   band x=date upper=bolupper lower=bollower / 
        transparency=0.5 legendlabel="Bollinger Bands(25,2)" name="boll";
   vector x=date y=high / yorigin=low xorigin=date noarrowheads;
   scatter x=date y=close / markerattrs=(symbol=plus size=3);
   series x=date y=avg25 / lineattrs=GraphFit legendlabel="SMA(25)" name="d25";             
   series x=date y=avg50 / lineattrs=GraphFit2(pattern=solid) legendlabel="SMA(50)" name="d50";
   keylegend "boll" "d25" "d50" / across=3 noborder position=bottomRight location=inside;
run;

/*ods html close;*/
/*ods listing;*/