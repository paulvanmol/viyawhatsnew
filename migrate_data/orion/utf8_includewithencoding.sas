%let localprojectpath=/home/student/viyawhatsnew/migrate_data;
%include "&localprojectpath/demo/20_read_external_file.sas" 
	/encoding=wlatin1 source2;

filename extfile "&localprojectpath/data/" encoding=wlatin1;
data contacts;
infile extfile;
length name $ 20 first $ 20;
input name first;
run;