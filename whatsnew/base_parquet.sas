/*Parquet Support in SAS Compute Server
 Posted 05-05-2022 04:12 PM | by NicolasRobert (543 views)
The Parquet file format has become a standard in the data cloud ecosystem. It’s the new CSV file. Many modern data platforms support it natively. The Parquet file format has many advantages that we presented a while back when CAS first supported it in SAS Viya 3.5. Now is the time to support it in SAS Viya Compute Server.

 

Viya 2021.2.6 is the first version that introduces support for the Parquet LIBNAME engine. Following the same principles as the ORC LIBNAME engine, it allows a user to easily read and write Parquet data sets using a simple SAS library.

 

The first iteration provides Parquet support only for “OS Directories” (directories accessible from the SAS Compute Server) files, but this engine is expected to grow quickly as upcoming stable releases will bring new capabilities and extend its support to other platforms. Let’s have a first look at the Parquet LIBNAME engine.

 

Introduction
 

How to assign a Parquet library? You just need to add the parquet engine keyword to your libname instruction that points to a directory. Then you will be able to start reading and writing Parquet files from/to that directory.
*/
 

libname pqt parquet "&path/viyawhatsnew/data/parquet" ;
 
/*
This libname statement also supports options to control how to handle different extensions as well as Parquet files available as directories (exactly like the ORC engine) for reading. On the other hand, SAS creates a Parquet data set only as a single file.
*/
 

libname pqt parquet "&path/viyawhatsnew/data/parquet" directories_as_data=yes file_name_extension=_none_ ;
 
/*
By default, the engine supports "parq", "pq" and "parquet" as extensions, and SAS uses "parquet" when writing new files. The file_name_extension option allows to customize it. You can then easily create a Parquet table:
*/
 

data pqt.prdsale ;
   set sashelp.prdsale ;
run ;
 
/*
One of the great benefits of Parquet is the compression rate. Here is what we can obtain from using Parquet files instead of SAS data sets (done on a sample data set):
*/
 
/*
Type	Size	Compression from SAS Data Set
SAS Data Set	142 MB	 
Compressed SAS Data Set	93 MB	34.5%
Parquet	11 MB	92.3%
 

You can also manipulate Parquet files like you would do for SAS data sets:
*/
 

data pqt.prdsale_computed ;
   set pqt.prdsale ;
   diff=actual-predict ;
run ;
 
/*
Reading third-party files
 

Another advantage of Parquet is its universality. Many tools can now read and write Parquet files. Starting now, SAS will be able to read Parquet files generated by other tools:
*/
 

libname pqt parquet "&path/viyawhatsnew/data/parquet" directories_as_data=yes ;

/* userdata3.parquet is a single parquet file */
proc freq data=pqt.userdata3 ;
   tables gender ;
run ;

/* userdata.parquet is a directory of parquet partitions */
proc freq data=pqt."userdata.parquet"n ;
   tables gender ;
run ;
/* 
Data Types Support
 

In this first version, only the primary data types are currently supported. Logical data types which extend Parquet native data types are not yet supported. If you happen to read a Parquet file that has unsupported data types, the column(s) will be dropped and you might see this message in the log:

 

78   proc freq data=pqt.userdata3 ;
NOTE: 1 columns are dropped as their data types are not supported.
79   run ;
NOTE: There were 1000 observations read from the data set PQT.userdata3.
NOTE: The PROCEDURE FREQ printed pages 3-130.
NOTE: PROCEDURE FREQ used (Total process time):
      real time           6.58 seconds
      cpu time            6.66 seconds
	  
*/