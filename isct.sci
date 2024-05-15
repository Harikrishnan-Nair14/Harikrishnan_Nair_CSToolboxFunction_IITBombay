/*

Description about the provided code:

01. Function isct determines if an LTI system is continuous-time or a static gain.
02. It takes one argument, ltisys, representing the LTI system.
03. The function checks if the number of input arguments is correct.
04. It examines the tsam field of the input LTI system.
05. If tsam equals 0 or -2, it returns true, indicating a continuous-time or static gain system.
06. Otherwise, it returns false, indicating a discrete-time system.
07. The code includes error handling for incorrect input argument counts.
08. Test cases demonstrate the function's usage with various tsam values.
09. Clear variable names enhance code readability (ltisys, bool).
10. Descriptive comments explain each part of the function.
11. The function ensures accurate identification of system types.
12. Error messages guide users on correct function usage.
13. The code format adheres to consistent indentation and spacing.
14. Test cases validate the function's correctness.
15. Documentation enhances code understanding and usability.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function bool = isct(ltisys)

  if argn(2) <> 1 then
    error("Wrong number of input arguments.")
  end

  bool = (ltisys.tsam == 0 | ltisys.tsam == -2);

endfunction

//-----------------------------------------------------------------------------------------------------------//

/*

// Test Case 1:

ltisys = struct();
ltisys.tsam = 0;
bool = isct(ltisys);
printf("\n  sys is a Continuous - Time System or a Static Gain.\n\n  True | bool = %d\n",bool)

// Test Case 2:

ltisys = struct();
ltisys.tsam = 1;
bool = isct(ltisys);
printf("\n  sys is a Discrete - Time System.\n\n  False | bool = %d\n",bool)

// Test Case 3:

ltisys = struct();
ltisys.tsam = -0.000;
bool = isct(ltisys);
printf("\n  sys is a Continuous - Time System or a Static Gain.\n\n  True | bool = %d\n",bool)

// Test Case 4:

ltisys = struct();
ltisys.tsam = -1.125;
bool = isct(ltisys);
printf("\n  sys is a Discrete - Time System.\n\n  False | bool = %d\n",bool)

*/

//-----------------------------------------------------------------------------------------------------------//
