%let vehicleType = Truck;
%let minCost = 26000; 

filename myJson "%sysfunc( pathname(work))/carSample.json";

proc json out=myJson nosastags pretty;
  write open array;
  write values "Vehicles";
  write open array;
  write values "&vehicleType";
  write open array;
  write values "Greater than $&minCost";

  /*********** Asian ***********************/
  %let originator=Asia;
  write open object;
  write values "&originator";
  write open array;
  export sashelp.cars(
    where=(
      (origin = "&originator")
      and (type   = "&vehicleType")
      and (MSRP   > &minCost) 
    )
    keep=make model type origin MSRP
  );
  write close; /* data values */
  write close; /* Asia */

  /*********** European ***********************/
  %let originator=Europe;
  write open object;
  write values "&originator";
  write open array;
  export sashelp.cars(
    where=(
      (origin = "&originator")
      and (type   = "&vehicleType")
      and (MSRP   > &minCost) 
    )
    keep=make model type origin MSRP
  );
  write close; /* data values */
  write close; /* Europe */

  /*********** American ***********************/
  %let originator=USA;
  write open object;
  write values "&originator";
  write open array;
  export sashelp.cars(
    where=(
      (origin = "&originator")
      and (type   = "&vehicleType")
      and (MSRP   > &minCost) 
    )
    keep=make model type origin MSRP
  );
  write close; /* data values */
  write close; /* USA */
  write close; /* expensive */
  write close; /* vehicleType */
  write close; /* cars */
run;

data _null_;
  infile myJson;
  input;
  putlog _infile_;
run;

filename myJson clear;