filename myJson "%sysfunc( pathname(work))/basic_sasDataset.json";

proc json out=myJson pretty;
  export sashelp.class;
run;

data _null_;
  infile myJson;
  input;
  putlog _infile_;
run;

filename myJson clear;