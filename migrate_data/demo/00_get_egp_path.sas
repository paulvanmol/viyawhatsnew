/* a bit of code to detect the local project path                          */
/* NOTE: &_CLIENTPROJECTPATH is set only if you saved the project already! */
%global _clientappabbrev; 
%if &_clientappabbrev=EG %then  %do;
%let localProjectPath =
  %sysfunc(substr(%sysfunc(dequote(&_CLIENTPROJECTPATH)), 1,
  %sysfunc(findc(%sysfunc(dequote(&_CLIENTPROJECTPATH)), %str(/\), -255 ))))
; 
%END; 
/*
 * in case you run code not through EG
 * yourPath: location where you stored all examples 
 * 
*/
%IF &_clientappabbrev=Studio %then %do; 
%let homedir=%sysget(HOME);
%put &homedir;
%let localProjectPath = &homedir/viyawhatsnew/migrate_data;
%end; 
%put &=localProjectPath;

