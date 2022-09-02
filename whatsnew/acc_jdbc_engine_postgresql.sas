/*Viya 2020 example CDATA JDBC Drivers built in */
/*libname facebk jdbc classpath="/opt/cdata/JDBC" class="cdata.jdbc.facebook.FacebookDriver"
               URL="jdbc:facebook:InitiateOAuth=GETANDREFRESH;";*/
/*Viya 3.5 Example: */
libname x JDBC driverclass="org.postgresql.Driver"
   URL="jdbc:postgresql://server.demo.sas.com:5432/SharedServices" user=pgadmin 
   password="Student1" classpath="c:\lib";

proc print data=x.customers;
   where state='CA';
run;