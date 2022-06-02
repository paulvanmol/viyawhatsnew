filename myJson "%sysfunc( pathname(work))/sample01.json";

proc json out=myJson pretty;
  write open object;
    write values "Nested object sample";
    write open object;
      write values "Comment" "In a nested object";
    write close;
    write values "Nested array sample";            
    write open array;                                     
      write open array;                                  
         write values "In a nested array";               
         write values 1 true null;                       
      write close;                                       
    write close;
    write values "Finished" "End of samples";
  write close;
run;

data _null_;
  infile myJson;
  input;
  putlog _infile_;
run;

filename myJson clear;