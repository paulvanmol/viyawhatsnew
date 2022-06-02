%let localProjectPath =
   %sysfunc(substr(%sysfunc(dequote(&_CLIENTPROJECTPATH)), 1,
   %sysfunc(findc(%sysfunc(dequote(&_CLIENTPROJECTPATH)), %str(/\), -255 ))));



%let name=ods_layout;

/*
ODS Layout: modified/enhanced version of example from the SAS online doc:
SAS System Documentation > 
 SAS Products > 
 Base SAS > 
 SAS 9.4 Output Delivery System: User's Guide >
 ODS Statements > 
 Dictionary of ODS Language Statements
*/

options nodate nonumber;

ods path
  (prepend) work.mytemplate (update)
;

proc template;
   define style Styles.OrionCalloutBlock;
     parent =Styles.Printer;
     style LayoutRegion/
     background=cxbbb2e0;
   end;
run;

ods escapechar="~";

title "~{style [preimage='&localProjectPath.Orion-Banner.gif' width=100pct background=cx494068 color=cxbbb2e0 font_size=32pt] Our Company }";

footnote "~{style [font_size=10pt just=right color=cxbbb2e0]SAS&sysver ODS Absolute Layout Features.}";

ods pdf file="c:\temp\&name..pdf" notoc nogtitle nogfootnote dpi=300;

ods layout absolute;

ods text="~{style [preimage='&localProjectPath.star.png' font_style=italic font_size=20pt color=cxbbb2e0]  Who we are...}";

ods region y=0.6in x=1in width=6in;
    ods text="The Orion Star Sports & Outdoors Company is a fictional 
international retail company that sells sports and outdoor products. 
The headquarters is based in the United States. Retail stores are 
situated in a number of other countries including Belgium, Holland, 
Germany, the United Kingdom, Denmark, France, Italy, Spain, and Australia.";

ods region y=1.25in x=1in width=4in;
    ods text="Products are sold in physical retail stores, by mail order 
catalogs, and through the Internet. Customers who sign up as members
of the Orion Star Club organization can receive favorable special 
offers; therefore, most customers enroll in the Orion Star Club. The 
sales data in this scenario includes only the purchases of Orion 
Star Club members from 1998 through 2002.";

ods region y=2.5in height=1in width=3in;
    ods text="~{style [preimage='&localProjectPath.star.png' font_style=italic 
     font_size=20pt color=cxbbb2e0]  What we sell...}";

ods region y=3.1in x=1in width=4in height=1.75in;
    ods text="Approximately 5,500 different sports and outdoor products 
are offered at Orion Star. Products are sold in volumes that reflect 
the different types of sports and outdoor activities that are performed 
in each country. Therefore, some products are not sold in certain 
countries. All of the product names are fictitious.";

ods text="~{newline}Products are organized in a hierarchy consisting of three levels:";
ods text=" ";
ods text="o Product Line";
ods text="o Product Category";
ods text="o Product Group";

ods region y=4.75in height=1in width=5in;
    ods text="~{style [preimage='&localProjectPath.star.png' 
    font_style=italic font_size=20pt color=cxbbb2e0]  Where we generate our profit...}";

/* Pie Chart (bottom/left) */
ods region x=0.7in y=5.5in width=4.5in height=3.7in;
ods graphics / outputfmt=pdf;
proc sgplot data=sashelp.orsales;
  vbar product_line / response=profit;
  format profit comma12.;
run;

/* Table (bottom/right) */
ods region y=5.5in x=5.625in width=2.5in height=3.7in;

proc sql noprint;
create table summary_table as
select unique product_category, sum(profit) as profit
from sashelp.orsales
group by product_category;
create table summary_table as
select *, sum(profit) as grand_total
from summary_table;
quit; run;

proc sort data=summary_table out=summary_table;
by descending profit;
run;

data summary_table; set summary_table;
table_order=_n_;
if (profit/grand_total)<.03 then do;
 product_category='Other';
 table_order=99;
 end;
run;

proc sql;
create table summary_table as
select unique table_order, product_category, sum(profit) as profit, grand_total
from summary_table
group by product_category;
quit; run;

proc sort data=summary_table out=summary_table;
by table_order;
run;

data summary_table; set summary_table;
format percent_of_total percent7.1;
percent_of_total=profit/grand_total;
run;

proc print data=summary_table noobs label; 
format profit dollar20.0;
label profit='Profit ($US)';
label percent_of_total='Percent';
/* if you want purple background */
/*
var product_category / style={background=cxbbb2e0};
*/
var product_category;
var profit;
var percent_of_total;
sum profit percent_of_total;
run;

ods pdf style=Styles.OrionCalloutBlock;

/* purple text boxes (along right edge) */
ods region x=6in y=0.9625in width=2in height=1in;
    ods text="~{style [background=cx494068 color=cxbbb2e0 
       font_size=22pt just=center font_style=italic width=100pct] Our Mission }";
    ods text="~{style [font_style=italic vjust=center font_size=10pt just=left]
To deliver the best quality sporting equipment, accessories, and outdoor equipment for all seasons at the most affordable prices.}";
ods region x=6in y=2.0875in width=2in height=1in;
    ods text="~{style [background=cx494068 color=cxbbb2e0 
       font_size=22pt just=center font_style=italic width=100pct] Our Vision }";
    ods text="~{style [font_style=italic vjust=center font_size=10pt just=left]
To transform the way the world purchases sporting and outdoor equipment.}";
ods region x=6in y=3.2125in width=2in height=1in;
    ods text="~{style [background=cx494068 color=cxbbb2e0 
       font_size=22pt just=center font_style=italic width=100pct] Our Values }";
    ods text="~{style [font_style=italic vjust=center font_size=10pt just=left]
To stay Customer focused, Swift and Agile, Innovative, and Trustworthy.}";
ods region x=6in y=4.3375in width=2in height=1in;
    ods text="~{style [background=cx494068 color=cxbbb2e0 
       font_size=22pt just=center font_style=italic width=100pct] Our Goal }";
    ods text="~{style [font_style=italic vjust=center font_size=10pt just=left]
To grow sales by 15% annually while improving profit margins through innovative thinking and operational efficiencies.}";
ods layout end;
ods pdf close; 

