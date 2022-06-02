proc print data=sashelp.cars 
  grandtotal_label='Total for all cars'
  sumlabel='Subtotal'
  noobs
;
  where make in ('Audi','BMW') and  invoice > 40000;
  by make;
  var model invoice;
  sum   Invoice;
 run;