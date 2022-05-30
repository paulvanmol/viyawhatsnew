/****************************************************/
/*													*/
/*	EXPLORING THE FEATURES OF SAS STUDIO EDITOR	2	*/
/*													*/
/****************************************************/
data SUV_CAT; set sashelp.cars;	where Type="SUV"; length HP_Category $ 15.;
if Horsepower <240 then	HP_Category="Small";
else if Horsepower <280 then HP_Category="Midsize";
else if Horsepower <400 then HP_Category="Large";run;
