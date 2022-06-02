*
* this example shows that the threaded DS2 program runs faster
* (elapsed time) then the DATA Step
*;
options nocenter;

*
* create some data
*;
data work.have;
  length c $ 8192;
  retain c ' ';
  do i = 1 to 1000;
     j = i * i;
     output;
  end;
run;

*
* do some calculations
*;
data work.base_sas_data_step;
   set work.have;
   do k = 1 to j * 10;
      x = (i * j * k) / (i + j + k);  
   end;
run;
title "&syslast";
proc contents;run;

*
* same code but packaged into a thread
*;
proc ds2;
  thread work.threadDefinition / overwrite=yes;
     declare double k x;
     declare double threadID;
     method run();
        set work.have;
        threadID = _threadid_;
        do k = 1 to j * 10;
           x = (i * j * k) / (i + j + k);
        end;
     end;
  endthread;

  data work.ds2_threads(overwrite=yes);
     declare thread work.threadDefinition worker_thread;
     method run();
        set from worker_thread  threads=4;
        output;
     end;
  enddata;
run;
quit;
title "work.ds2_threads";
proc contents data=ds2_threads;run;

proc sort
  data=work.ds2_threads
;
  by i;
run;

proc compare
  base=work.base_sas_data_step
  comp=work.ds2_threads
;
run;
