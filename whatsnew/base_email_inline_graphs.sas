/*
 * have graphs create in SAS as part of your HTML email
 *
 * see also here
 */
proc options group=email;
run;

options
  emailhost="yourEmailHost"
  emailsys=smtp
;
%let yourEmail = your.name@company.tld;
%let workdir=%trim(%sysfunc(pathname(work)));
ods _ALL_ close;
ods listing gpath="&workdir";
ods graphics / reset=index outputfmt=png imagename='bubble' height=400 width=600;
title1 'Graph output emailed using SAS';

proc sgplot data=sashelp.cars;
  bubble x=horsepower y=mpg_city size=cylinders;
run;

ods graphics / reset=index outputfmt=PNG imagename='vbar' height=400 width=600;
title1 'Graph output emailed using SAS';

proc sgplot data=sashelp.cars;
  vbar type / group=origin;
run;

filename sendmail email
  subject="Emailing graphics output"
  to=("&yourEmail")
  from=("&yourEmail")
  attach=(
  "&workdir./bubble.png" inlined='bubble'
  "&workdir./vbar.png" inlined='vbar'
  )
  type='text/html'
;

data _null_;
  file sendmail;
  put '<html>';
  put '<body>';
  put "here comes a table";
  put "<table>";
  put " <tr>";
  put "   <th>Column1</th>";
  put "   <th>Column2</th>";
  put " </tr>";
  put " <tr>";
  put "   <td><img src=cid:bubble></td>";
  put "   <td><img src=cid:vbar></td>";
  put " </tr>";
  put "</table> ";
  put '</body>';
  put '</html>';
run;

filename sendmail clear;