/*
 * data based on http://open-notify.org/Open-Notify-API/People-In-Space/
 * with some additional data types for illustration
 */

%let json= '
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
';


proc ds2;

  data tokens (overwrite=yes);
    dcl package json j();
    dcl int rc;
    dcl varchar(1024) token;
    dcl int tokenType;
    dcl char(1)
      string number isLabel 
      bool_true bool_false
      delimiter
      isLeftBrace isLeftBracket
      isRightBrace isRightBracket
      ;

    method init();
      dcl varchar(1000000) json;
      dcl varchar(1024) thisVar;
      dcl int parseFlags;

      /* JSON for prototyping */
      json = %superq(json);
      rc = j.createParser();

      if (rc) then do;
        put 'ERROR: ' rc= ': Could not create JSON parser.';
        stop;
      end;

      rc = j.setParserInput(json);

      if (rc) then do;
        put 'ERROR: ' rc= ': setParserInput failed.';
        stop;
      end;

      /*
       * Use the parser to parse the JSON 
       * RC of 0 means all went well.
       */
      j.getNextToken( rc, token, tokenType, parseFlags );
      do while (rc = 0);
        string = if j.isstring(tokenType) then 'Y' else 'N';
        number = if j.isnumeric(tokenType) then 'Y' else 'N';
        isLabel = if j.isLabel(tokenType, parseFlags) then 'Y' else 'N';
        bool_true = if j.isbooleantrue(tokenType) then 'Y' else 'N';
        bool_false = if j.isbooleanfalse(tokenType) then 'Y' else 'N';
        delimiter = if tokenType in (16,32,64,128) then 'Y' else 'N';
        isLeftBrace = if j.isLeftBrace(tokenType) then 'Y' else 'N';
        isLeftBracket = if j.isLeftBracket(tokenType) then 'Y' else 'N'; 
        isRightBrace = if j.isRightBrace(tokenType) then 'Y' else 'N';
        isRightBracket = if j.isRightBracket(tokenType) then 'Y' else 'N';
        output;
        j.getNextToken( rc, token, tokenType, parseFlags );
      end;
    end;

  enddata;
run;

quit;

/*
 * trigger data changed event for EG
 */
proc datasets lib=work;
  change tokens = __tokens;
  change __tokens = tokens;
run;
quit;

proc print data=tokens;
run;