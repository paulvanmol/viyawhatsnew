/* a bit of code to detect the local project path                          */
/* NOTE: &_CLIENTPROJECTPATH is set only if you saved the project already! */
%let localProjectPath =
  %sysfunc(substr(%sysfunc(dequote(&_CLIENTPROJECTPATH)), 1,
  %sysfunc(findc(%sysfunc(dequote(&_CLIENTPROJECTPATH)), %str(/\), -255 ))))
; 

/*
 * in case you run code not through EG
 * yourPath: location where you stored all examples 
 * 
*/
 %let localProjectPath = /home/student/viyawhatsnew/migrate_data;
 

%put &=localProjectPath;

