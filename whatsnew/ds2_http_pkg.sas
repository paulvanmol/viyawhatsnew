/*
 * Example from
 * http://blogs.sas.com/content/sastraining/2015/01/17/jedi-sas-tricks-ds2-apis-get-the-data-you-are-looking-for/
 * must have direct internet access
 */
proc ds2;

  data swapi_people (overwrite=yes);
    dcl varchar(131068) character set utf8 url response;

    /* A user defined method to leverage the HTTP package for GETs */
    method GetResponse( varchar(131068) url) returns int;
      dcl integer i rc status;
      dcl package http webQuery();

      /* create a GET call to the API*/
      webQuery.createGetMethod(url);

      /* execute the GET */
      webQuery.executeMethod();
      status = webQuery.getStatusCode();

      /* retrieve the response body as a string */
      webQuery.getResponseBodyAsString(response, rc);
      return ( status );
    end;

    method run();
      dcl int status;

      /* Construct a GET URL to obtain a list of all people */
      url='http://swapi.co/api/people';
      status = GetResponse(url);
      put;
      put status= url=;
      put Response= $1024.;
      put;

      /* Construct a GET URL to obtain information for Luke Skywalker (Person 1) */
      url='http://swapi.co/api/people/1';
      status = GetResponse(url);
      put;
      put status= url=;
      put Response= $1024.;
      put;
    end;

  enddata;
run;

quit;