proc ds2;
  /* package to keep values */
  package pkgA / overwrite=yes;
    declare bigint key;
    declare double i;
    declare char(16) roman;

    /* constructor method */
    method pkgA(bigint key, double i);
      this.key = key;
      this.i = i;
      this.roman = put(i, roman.);
    end;

    /* sample get method */
    method getI() returns double;
      return( i );
    end;

    /* custom toString method */
    method toString() returns char(32);
      return ( 'key=' !! key !! ' i=' !! i !! ' roman=' !! roman);
    end;

  endpackage;

  data _null_;
    /* A hash package instance referenced by package variable h */
    /* is created in program global scope, it will be ordered by the key value */
    declare package hash h(8, '', 'ASCENDING' );
    declare int          i;
    declare package pkgA a;

    method init();
      dcl double result;
      dcl varchar(32) resultChar;
      h.definekey('i');
      h.definedata('a');
      h.definedone();

      do i = 1 to 10;

        /* A pkgA package instance is created in the same scope as package instance h */
        /* The pkgA package instance is assigned to package variable a */
        a = _new_ [h] pkgA(i, i * 2);

        /* access the package instance vars using method and dot syntax */
        result = a.getI();
        put 'NOTE: a.getI() ' result=;
        result = a.i;
        resultchar = a.roman;
        put 'NOTE: a.i, a.roman ' result= resultchar=;

        /* The pkgA package instance referenced by a is added to hash h*/
        /* the variable i used as key */
        h.add();
      end;
    end;

    method run();
      declare package hiter myIter('h');
      declare char(32) result_toString;

      /* NEXT method returns the data part of hash object */
      /* in our case a package */
      do while ( myIter.next( ) = 0 );
        result_toString = a.toString();
        put result_toString=;
      end;
    end;

  enddata;
run;

quit;