ods escapechar="~";
options papersize=letter;
options topmargin=0in bottommargin=0in leftmargin=0in rightmargin=0in;

proc format ;
    value prodstate 1="Back Order" 2="Special Order" other="Regular Inventory";
    value categoryfmt 1="Hunting" 2="Dog" 3="Sports" 4="Children" 
        5="Fresh Water Fishing" 6="Salt Water Fishing" 7="Camping" other=" ";
run;

data customers;
    infile cards dlm=",";
    format preferredcategory categoryfmt.;
    input name : $20. email : $24. street : $22. city : $12. state : $3. zip 
        preferredcategory accountid clubpoints;
    cards;
Dan O’Connor, Dan.OConnor@sas.com, SAS Campus Drive, Cary, NC, 27513, 0, 1234567, 256, 999
Scott Huntley, Scott.Huntley@.sas.com, 105 Windward Way, Raleigh, NC, 27615, 3, 9857954, 0
David Kelley, David.Kelley@sas.com, 507 Down Patrick Lane, Garner, NC, 27644, 5, 4382743, 1256
Wayne Hester, Wayne.Hester@sas.com, 201 Gucci Boulevard, Cary, NC, 27513, 7, 3485944, 653
Tim Hunter, Tim.Hunter@sas.com, 95 Wild Ranch Road, Taos, NM, 89875, 6, 3294746, 77
Eric Gebhart, Eric.Gebhart@sas.com, 99 Sea Scape Island, Charleston, SC, 83478, 2, 9087450, 943
Darylene Hecht, Darylene.Hecht@sas.com, 300 Vintage Drive, Sonoma, CA, 67676, 4, 4987654, 10503
Kevin Smith, Kevin.Smith@sas.com, 28901 Pop Circle, Miami, FL, 30497, 1, 8734902, 444
;
run;

data inventory;
    infile cards dlm=",";
    format productstatus prodstate.;
    input item : $64. photo : $24. itemno instock productstatus regprice 
        saleprice additionalshipping;
    datalines;
Gorilla King Kong Hang-On Tree stand, treestand.jpg, 89783483, 34, 0, 89.99, 79.99, 12.00
Orion Star XT Mega-Sized Binoculars, binoculars.jpg, 87634893, 134, 0, 279.99, 0.00, 0.00
Night Owl Night Scope, nightowl.jpg, 37274307, 0, 1, 199.99, 0.00, 0.00
Super Doggy Yapper Stopper, trainingcollar.jpg, 87393444, 222, 2, 79.99, 0.00, 0.00
Neoprene Flotation Vest, vest.jpg, 77439843, 66, 0, 34.99, 0.00, 0.00
Dead Duck Retriever Trainers, mallard.jpg, 33348484, 256, 0, 44.55, 0.00, 0.00
Spilding Wood Baseball Bat, baseball_bat.jpg, 98457897, 934, 0, 34.99, 29.99, 0.00
Foam Football, football.jpg, 59498478, 342, 0, 12.99, 0.00, 0.00
Super Start First Base Glove, baseballglove.jpg, 98754598, 232, 0, 42.50, 0.00, 0.00
Little Princess Water proof Radio, radios.jpg, 54987430, 5, 0, 25.99, 0.00, 0.00
Big Bubba Sonar, sonar.jpg, 98745878, 55, 2 ,549.99 ,0.00, 9.00
;

data transactions;
    format date mmddyy10.;
    input invoice accountid itemno quantity date:mmddyy10. clubvisa;
    datalines;
1 1234567 89783483 1 01/02/2009 1
1 1234567 87634893 1 01/02/2009 1
2 1234567 37274307 1 01/05/2009 0
3 3294746 98745878 1 01/25/2009 0
4 9857954 59498478 3 01/23/2009 0
5 9857954 98457897 1 01/30/2009 0
5 9857954 98754598 6 01/30/2009 0
6 4987654 54987430 4 01/04/2009 1
7 9087450 87393444 1 01/14/2009 1
8 3485944 33348484 2 01/14/2009 0
9 3485944 77439843 1 01/26/2009 0
;
run;

proc sort data=transactions;
    by accountid invoice;
run;

options nodate nonumber;
title "Preferred Club Member";
footnote  "Provided to you compliments of SAS&sysver using ODS Report Writing Interface methods.";
ods pdf file="c:\temp\rwi_example.pdf" notoc;

data _null_;
    retain invsum bonus sum clubpoints;

    if _n_=1 then
        do;
            declare odsout obj();
            length name $20 street $22 city $12 state $3;
            zip=.;
            declare hash customer(dataset: "customers");
            customer.defineKey("accountid");
            customer.defineData("name", "street", "city", "state", "zip", "clubpoints");
            customer.defineDone();
            length item $64;
            itemno=.;
            instock=.;
            productstatus=.;
            regprice=.;
            saleprice=.;
            additionalshipping=.;
            declare hash product(dataset: "inventory");
            product.defineKey("itemno");
            product.defineData("item", "instock", "productstatus", "regprice", 
                "saleprice", "additionalshipping");
            product.defineDone();
        end;
    set transactions end=eod;
    by accountid invoice;

    if first.accountid then
        do;
            sum=0;
            * obj.open_dir(name:    "Invoice",    label: "Invoice for Customer " || accountid,    by: 1);

            if customer.find() eq 0 then
                do;
                    obj.format_text(data:   strip(street), overrides: "font_size=14pt width=100pct  just=left");
                    obj.format_text(data:strip(city) || ", " || state || " " || zip, overrides: "font_size= 14pt width=100pct just=left");
                    obj.format_text(data:   " ");
                    obj.format_text(data: put(today(), worddate18.), overrides: "font_size=14pt width=100pct just=left");
                    obj.format_text(data: " ");
                    obj.format_text(data: "Dear " || strip(name) || ",",  overrides:   "font_size=14pt width=100pct just=left");
                    obj.layout_gridded(columns:    2);
                    obj.region(width:   "5.25in");
                    obj.format_text(data: compbl(
      "~{style [font_size=14pt width=100pct]As a preferred
      Club Member you receive special membership benefits such as special promotions, member
      discounts, free 1 year warranty on all purchases, as bonus points that can be redeemed
      for free items.}"), just: "L");
                    obj.format_text(data:   " ");
                    obj.layout_gridded(overrides:  "background=cxbbb2e0");
                    obj.region(overrides:  "background=_undef_");
                    obj.format_text(data: "See what being a preferred Club Member is all  about.", 
                        overrides: "font_size=20pt font_weight=bold width=100pct");
                    obj.format_text(data:  "You are pre-approved for our new ~{style [font_weight=bold]Orion Star Club Visa} card.", 
                        overrides: "just=left font_size=14pt width=100pct");
                    obj.format_text(data:   " ");
                    obj.format_text(data: '1. A low 8.9%APR', 
                        overrides: "just=left font_size=12pt width=100pct");
                    obj.format_text(data: "2. Get double membership points when using your  Orion Star Club Visa card.", 
                        overrides: "just=left font_size=12pt width=100pct");
                    obj.format_text(data: "3. Get Exclusive access to offers not available to general public", 
                        overrides: "just=left font_size=12pt width=100pct");
                    obj.format_text(data: " ");
                    obj.href(data: "~{style [font_size=20pt]Apply Today}", 
                        href: "http:\\www.orionstar.com\visaapplication");
                    obj.layout_end();
                    obj.region(width:  "2.5in");
                    obj.format_text(data:     "Enjoy your Preferred membership", 
                        overrides: "color=cx494068 font_size=16pt font_weight=bold   width=100pct", 
                        just: "L");
                    obj.format_text(data:  " ");
                    obj.format_text(data:  "Special Promotions", 
                        overrides: "color=cx494068 font_size=14pt width=100pct", 
                        just: "L");
                    obj.format_text(data:  " ");
                    obj.format_text(data:"Membership Discounts", 
                        overrides: "color=cx494068 font_size=14pt width=100pct", 
                        just: "L");
                    obj.format_text(data: " ");
                    obj.format_text(data: "FREE 1 year warranty", 
                        overrides: "color=cx494068 font_size=14pt width=100pct", 
                        just: "L");
                    obj.format_text(data: " ");
                    obj.format_text(data: "FREE Items", 
                        overrides: "color=cx494068 font_size=14pt width=100pct", 
                        just: "L");
                    obj.format_text(data: " ");
                    obj.layout_end();
                    obj.format_text(data:  " ");
                    obj.table_start(overrides: "width=100pct");
                    obj.row_start();
                    obj.format_cell(data: "Current Club Point Balance", 
                        column_span: 2, 
                        overrides: "font_weight=bold font_size=16pt");
                    obj.format_cell(data: clubpoints, format: "comma8", 
                        overrides: "font_weight=bold font_size=16pt");
                    obj.row_end();
                    obj.row_start();
                    obj.format_cell(data:  "Recent Purchases", column_span: 3);
                    obj.row_end();
                    obj.row_start();
                    obj.format_cell(data: "Date");
                    obj.format_cell(data: "Invoice Number");
                    obj.format_cell(data: "Additional Club Points");
                    obj.row_end();
                end;
        end;

    if first.invoice then
        do;
            invsum=0;
            bonus=0;
        end;

    if product.find() eq 0 then
        do;

            if saleprice ne 0 then
                cost=quantity*saleprice;
            else
                cost=quantity*regprice;
            invsum=invsum + cost;
            sum=sum + cost;
        end;

    if clubvisa eq 1 then
        do;
            bonus=bonus + clubvisa*cost;
            sum=sum + clubvisa*cost;
        end;

    if last.invoice then
        do;
            obj.row_start();
            obj.format_cell(data: date, format: "mmddyy10.");
            obj.format_cell(data: invoice);
            obj.format_cell(data: invsum, format: "comma8.");
            obj.row_end();

            if clubvisa eq 1 then
                do;
                    obj.row_start();
                    obj.format_cell(data: "Bonus Visa Club Points", 
                        column_span: 2);
                    obj.format_cell(data: bonus, format: "comma8.");
                    obj.row_end();
                end;
        end;

    if last.accountid then
        do;
        putlog "LAST:" _all_;
            obj.row_start();
            obj.format_cell(data: "New Club Point Balance", column_span: 2, overrides: "font_weight=bold font_size=16pt");
            obj.format_cell(data: clubpoints+sum, overrides: "font_weight=bold font_size=16pt", format: "comma8.");
            obj.row_end();
            obj.table_end();

            obj.format_text(data:" ", overrides: "font_size=16pt");
            obj.format_text(data: "How to Redeem Points?",  overrides: "background=cxbbb2e0 font_size=20pt");
            obj.format_text(data: "Step-by-step instruction on how to use your Club REWARD Point to purchase free items.",  overrides: "font_size=16pt");
            obj.format_text(data: " ");
            obj.format_text(data: "~{style [font_size=20pt url='http:\\www.orionstar\redeempoints']Learn How!}");
            if eod = 0 then do;
              obj.page();
            end;
            * obj.close_dir();
        end;

    if eod = 1 then
        do;
            obj.delete();
            customer.delete();
            product.delete();
        end;
    ;
run;

ods pdf close;
title;
footnote;