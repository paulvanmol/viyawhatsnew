data newClass;
  set sashelp.class;
run;

proc ds2;
data _null_;
   method init();
      dcl varchar(20) Text;
      Text='**> Starting';
      put Text ;
   end; 
   method run();
      set work.newClass;
      put _all_;
   end;
   method term();
      dcl char(11) Text;
      Text='**> All done!';
      put Text;
   end;
enddata;
run;
quit;
