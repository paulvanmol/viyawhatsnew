
libname cntlfmt cvp "/workshop/SVFT/SASFormats";
libname library "/workshop/SVFT/Orion Star/orfmt"; 



/*Migrate SASFormats to library*/
proc format lib=library.formats fmtlib cntlin=cntlfmt.outfmts; 
run; 
options fmtsearch=(library.formats work);

options dlcreatedir; 
libname orstarl1 cvp "/workshop/SVFT/Orion Star/orstar"; 
libname orstaru8 "/workshop/SVFT/Orion Star/orstaru8";

%copy_to_utf8(orstarl1.customer_dim,orstaru8.customer_dim);
%copy_to_utf8(orstarl1.order_fact,orstaru8.order_fact);
%copy_to_utf8(orstarl1.organization_dim,orstaru8.organization_dim);
%copy_to_utf8(orstarl1.time_dim,orstaru8.time_dim);
%copy_to_utf8(orstarl1.geography_dim,orstaru8.geography_dim);
%copy_to_utf8(orstarl1.product_dim,orstaru8.product_dim);

