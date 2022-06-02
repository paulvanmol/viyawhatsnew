/*
 * data based on http://open-notify.org/Open-Notify-API/People-In-Space/
 * with some additional data types for illustration
 */
filename jsonstr temp;

data _null_;
  infile cards;
  input;
  file jsonstr;
  put _infile_;
  cards4;
{
  "number": 6,
  "message": "success",
  "people": [
    {
      "name": "Sergey Ryazanskiy",
      "craft": "ISS",
      "age": 42
    },
    {
      "name": "Randy Bresnik",
      "craft": "ISS"
    },
    {
      "name": "Paolo Nespoli",
      "craft": "ISS",
      "gender": "M"
    },
    {
      "name": "Alexander Misurkin",
      "craft": "ISS",
      "isRussian": true
    },
    {
      "name": "Mark Vande Hei",
      "craft": "ISS"
    },
    {
      "name": "Joe Acaba",
      "craft": "ISS"
    }
  ]
}
;;;;
run;

/* Let the JSON engine do its thing */
libname somejson JSON fileref=jsonstr;

/* examine resulting tables/structure */
title "Automap of JSON data";

proc datasets lib=somejson;
quit;
title "Root";
proc print data=somejson.root;
run;
title "People";
proc print data=somejson.people;
run;
title "Alldata";
proc print data=somejson.alldata;
run;
title;
