data carMakes;
  infile cards;
  input
    make : $13.
  ;
  cards;
Saab
MINI
Audi
;

data carMakes_subset;
  if _N_ = 1 then do;
    if 0 then
      set sashelp.cars;

    declare hash cars(dataset: "sashelp.cars", multidata: "y");
    cars.definekey("make");
    cars.definedata("model", "invoice", "horsePower");
    cars.definedone();
  end;

  set work.carMakes;

  if cars.find() = 0 then do;
    cars.reset_dup();

    do while( cars.do_over() eq 0 );
      output;
    end;
  end;

 keep make model invoice horsepower;
run;