/*
 * code must be run in a unicode session
 */
%put NOTE: %sysfunc(getoption(encoding, keyword));
%let text = 1€23;

%put NOTE: *%substr(&text, 2, 1)*;

%put NOTE: *%ksubstr(&text, 2, 1)*;

%put NOTE: *%length(&text)*;
%put NOTE: *%klength(&text)*;
