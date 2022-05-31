/*
 * Run in UTF8 Session (9.4 or Viya)
 * data already created
 * MUST be run with SAS running in UTF-8
 * otherwise, special chars can not be processed
 */
options dlcreatedir;
libname utf8out "&localProjectPath/data";

data utf8out.countries;
  length 
    i 8
    lang $ 16
    someText $ 128
  ;
  array xlang{7} $ 16 _temporary_
    ("Deutsch", "Spanisch", "Französisch", "Hindi", "Griechisch", "Polnisch", "Russisch" );
  array xtext{7} $ 128 _temporary_
    ("Füßling", "Rodríguez", "Anaïs", "आचुथान", "Αχιλλέας", "dodać", "Виталий");
  do i = 1 to dim(xlang);
    lang = xlang{i};
    someText = xtext{i};
    length = length(someText);
    klength = klength(someText);
    output;
  end;
run;