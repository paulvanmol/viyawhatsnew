 filename fixed temp;

data _null_;
  file fixed;
  input;
  l = length(_infile_);
  put _infile_ $varying256. l;
  datalines4;
<hr>
This is the first line of fixed text.<br>
This is another line to be fixed.<br>
This is the last line of fixed text.<br>
<hr>
;;;;

%macro doit(nrows,ncols);
  %local i j NL;
  %let NL = _NL NEWLINE;

  <table border="1">&NL;
    %do i = 1 %to &nrows;
      <tr>&NL;
        %do j=1 %to &ncols;
          <td>R=&i C=&j</td>&NL;
        %end;
      </tr>
      &NL;
    %end;
  </table>
%mend;

filename new "c:\temp\stream.html";

%let NL = _NL NEWLINE;
proc stream outfile=new resetdelim='_NL'; begin
<html>
&streamdelim readfile fixed;
%doit(3,3)
&NL;
</html>
;;;;

data _null_;
  infile new;
  input;
  putlog _infile_;
run;

filename new clear;
filename fixed clear;