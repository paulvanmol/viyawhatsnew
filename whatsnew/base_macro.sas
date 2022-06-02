*
* create global READONLY macro var
*;
%GLOBAL / READONLY SUGUS = hello world; 

%put _readonly_;

*
* detailed info on host info
*;
%put NOTE: &=SYSHOSTINFOLONG;

*
* information on phase DATA Step is
*;
data _null_;
  length phase1 phase2 $ 32;
  phase1 = "&sysDataStepPhase";
  phase2 = symget("sysDataStepPhase");

  putlog _all_;
run;

*
* get info on server type
*;
%put NOTE: &=sysProcessMode;

*
*
*;
%put NOTE: &=SYSTIMEZONE, &=SYSTIMEZONEIDENT, &=SYSTIMEZONEOFFSET;

