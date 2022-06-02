proc ds2;

  /*
   * package for an individual person
   * we store lastName, firstName and age
   */
  package work.person / overwrite=yes;

    /*
     * package variables
     */
    dcl varchar(32) lastname;
    dcl varchar(32) firstname;
    dcl int age;

    /*
     * contructor methods
     * need a empty contructor, for the cases where we do not provide values
     * we use the THIS.xxxx to access package variables
     */
    method person();
    end;

    method person(varchar(32) firstName, varchar(32) lastName, int age);
      this.lastName = lastName;
      this.firstName = firstName;
      this.age = age;
    end;

    /*
     * example set... method
     */
    method setNames(varchar(32) lastname, varchar(32) firstname);
      this.lastname = lastname;
      this.firstname = firstname;
    end;

    /*
     * example get... and toString method
     */
    method getFullname() returns varchar(66);
      return (catx(', ', lastname, firstname));
    end;

    method toString() returns varchar(80);
      dcl varchar(80) tempValue;
      tempValue = catx(':', lastName, firstName, age);
      return ( tempValue );
    end;

  endpackage;
run;

/*
 * package for a list of persons
 */
package work.person_list / overwrite=yes;

  /*
   * hash package to store person object
   */
  dcl package hash hplist();

  /*
   * payload varibales for the hash package
   */
  dcl int pIndex;
  dcl package work.person pGeneral;

  /*
   * contructor method will define key and data variables for the hash
   */
  method person_list();
    put 'NOTE: person_list()';
    hplist.definekey('pIndex');
    hplist.definedata('pGeneral');
    hplist.defineDone();
  end;

  /*
   * returns current number of persons in hash
   */
  method getNPersons() returns int;
    return (hpList.NUM_ITEMS);
  end;

  /*
   * add person object to hash
   * key is a sequence number based on the number of entries in the hash
   */
  method addPerson( package work.person pers_p);
    pGeneral = pers_p;
    pIndex = getNPersons() + 1;
    put 'NOTE: addPerson() ' pIndex=;
    hpList.add();
  end;

  /*
   * example to return somethig from the individual
   * person object, person object is accessed by a number
   */
  method getPersonName(int PI) returns varchar(66);
    pIndex = PI;
    hplist.find();
    return ( pGeneral.getFullName() );
  end;

  /*
   * example of get... method to return the actual person object
   */
  method getPersonObj(int PI) returns package work.person;
    pIndex = PI;
    hplist.find();
    return (pGeneral);
  end;

endpackage;
run;

quit;

proc ds2;

  data new (overwrite=yes);
    dcl char(8) fromMethod;
    dcl char(66) fullName;
    dcl char(80) toString;
    dcl package work.person pers;
    dcl package work.person_list pl ();

    /*
     * create some person objects and add them to the list
     */
    method init();
      dcl int i;

      do i = 1 to 5;

        /*
         * using constructor method to create new person objects
         */
        pers = _NEW_ [pl] work.person(
          catx('_', put(i, z6.), 'last', put(i, roman20.))
          , catx('_', 'first', put(i, roman20.))
          , i * 3
          );
        pl.addPerson(pers);
      end;
    end;

    /*
     * access the person list and get information on the individual person object
     */

    method run();
      dcl int i nPersons;
      fromMethod = 'RUN';
      nPersons = pl.getNpersons();
      put nPersons=;

      do i = 1 to  pl.getNpersons();
        fullName = pl.getPersonName(i);
        put i= fullName=;
      end;

      pers = _NEW_ [pl] work.person();
      pers.setNames( 'some last', 'some first');

      /* 
       * seems that we get automatic set_... and get_... methods
       */
      pers.set_age(99);
      pl.addPerson(pers);
      nPersons = pl.getNpersons();
      put nPersons=;

      do i = 1 to  pl.getNpersons();
        fullName = pl.getPersonName(i);
        put i= fullName=;
        output;
      end;
    end;

    method term();
      dcl package work.person lPerson;
      dcl int i;
/*      dcl varchar(80) toString; */

      fromMethod = 'TERM';

      do i = 1 to  pl.getNpersons();
        lPerson = pl.getPersonObj(i);
        toString = lPerson.toString();
        put i= toString=;
        output;
      end;
    end;

  enddata;
run;

quit;

data new;
  set new;
run;