%let localprojectpath=/greenmonthly-export/ssemonthly/homes/paul.van.mol@sas.com/utf8encoding;
%include "&localprojectpath/sascode/20_read_external_file.sas" 
	/encoding=wlatin1 source2;

filename extfile "&localprojectpath/data/ encoding=wlatin1;
data contacts;
infile extfile;
length name $ 20 first $ 20;
input name first;
run;