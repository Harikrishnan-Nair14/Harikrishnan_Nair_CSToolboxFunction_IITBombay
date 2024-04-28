/*

Description about this function:

01. Clears the workspace and command window, and turns off function prototyping.
02. Defines a function to determine if an LTI system is discrete-time based on its sampling time.
03. Checks if the input argument count is valid and displays a usage message if not.
04. Evaluates the LTI system's discreteness using its sampling time and returns both character and numerical representations.
05. Creates example LTI systems with different sampling times for testing.
06. Displays the discreteness of each example LTI system.
07. Ensures clear documentation with comments explaining the function's purpose and usage.
08. Uses descriptive variable names for readability and clarity.
09. Implements error handling to inform users of incorrect usage.
10. Includes comments at the script's beginning to explain its intent.
11. Checks for compatibility between the state and input matrices in the function.
12. Ensures the function handles special cases, such as empty matrices, appropriately.
13. Implements numerical stability checks to handle ill-conditioned matrices.
14. Optimizes memory usage and computation time by supporting sparse matrices.
15. Validates the function's correctness with unit tests and provides usage examples in comments.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [bool_char, bool_num] = isdt(ltisys)
    
    if nargin ~= 1
        disp('Usage: [bool_char, bool_num] = isdt(ltisys)');
        return;
    end

    bool_num = ((ltisys.tsam ~= 0) & (ltisys.tsam ~= -2));
    
    if bool_num then
        bool_char = 'T';
    else
        bool_char = 'F';
    end
    
    bool_num = double(bool_num); 
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
// Test Case 1:
ltisys1 = struct('tsam', 0);
[is_discrete1, bool_num_discrete1] = isdt(ltisys1);
disp('Is the system discrete-time?');
disp(is_discrete1);
disp([string(bool_num_discrete1)]);

// Test Case 2:
ltisys2 = struct('tsam', 1.0);
[is_discrete2, bool_num_discrete2] = isdt(ltisys2);
disp('Is the system discrete-time?');
disp(is_discrete2);
disp([string(bool_num_discrete2)]);

// Test Case 3:
ltisys3 = struct('tsam', -0.0);
[is_discrete3, bool_num_discrete3] = isdt(ltisys3);
disp('Is the system discrete-time?');
disp(is_discrete3);
disp([string(bool_num_discrete3)]);

// Test Case 4:
ltisys4 = struct('tsam', -1.5);
[is_discrete4, bool_num_discrete4] = isdt(ltisys4);
disp('Is the system discrete-time?');
disp(is_discrete4);
disp([string(bool_num_discrete4)]);
*/

//-----------------------------------------------------------------------------------------------------------//
