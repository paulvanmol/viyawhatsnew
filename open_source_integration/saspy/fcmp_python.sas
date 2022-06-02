/*
 * env vars needed, see
 * https://go.documentation.sas.com/?docsetId=biasag&docsetTarget=n1mquxnfmfu83en1if8icqmx8cdf.htm&docsetVersion=9.4&locale=en
 */
options
  set=MAS_M2PATH "C:\Program Files\SASHome\SASFoundation\9.4\tkmas\sasmisc\mas2py.py"
  set=MAS_PYPATH="C:\ProgramData\Anaconda3\python.exe"
;

/* A basic example of using PROC FCMP to execute a Python function */
proc fcmp outlib=work.pyfunc.simple;

function py_multiply(arg1, arg2);
  /* Declare Python object */
  declare object py(python);

  /* Create an embedded Python block to write your Python function */
  submit into py;
  def MyPythonFunction(arg1, arg2):
    "Output: ResultKey"
    Python_Out = arg1 * arg2
    return Python_Out
  endsubmit;

  /* Publish the code to the Python interpreter */
  rc = py.publish();

  /* Call the Python function from SAS */
  rc = py.call("MyPythonFunction", arg1, arg2);

  /* Store the result in a SAS variable and examine the value */
  SAS_Out = py.results["ResultKey"];
  /*put SAS_Out=;*/
  return (SAS_out);
endsub;
run;

options cmplib=work.pyfunc;

data test;
  do i = 1 to 10;
    random = rand("uniform");
    ranint = rand("integer", 10, 100);
    res = py_multiply(random, ranint);
    output;
  end;
  format res random comma16.3;
run;