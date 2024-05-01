/*

Description of the provided Scilab code:

01. Implements a function named esort to sort continuous-time poles by real part in decreasing order.
02. Accepts a vector of continuous-time poles as input.
03. Sorts the poles by their real parts using the 'd' option in the gsort function.
04. Optionally returns the sorted poles and their corresponding indices.
05. Handles various input scenarios, ensuring the input is a vector.
06. Ensures compatibility with both real and complex poles.
07. Uses clear variable names like p, s, and ndx for clarity and readability.
08. Implements error checking to ensure robustness, such as checking for the correct number of input arguments.
09. Includes documentation within the code using comments to explain the purpose of the function and its inputs/outputs.
10. Compatible with the Scilab environment, allowing seamless integration into signal processing or control system analysis workflows.
11. Provides example usage with test cases to demonstrate functionality.
12. Displays the sorted poles and their indices for each example, aiding in verification of the function's correctness.
13. Consistent code formatting enhances readability and maintainability.
14. Adheres to best practices for function design, error handling, and documentation, promoting code reliability and usability.
15. Enhances code versatility, efficiency, and seamless integration for effortless, widespread reuse.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [s, ndx] = esort(p)
    
    if nargin <> 1 then
        error('esort: One input argument required');
    end

    if ~isvector(p) then
        error('esort: Input must be a vector');
    end

    [p_sorted, ndx] = gsort(real(p), 'g', 'd');
    s = p(ndx);
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*

// Test Case 1:

poles1 = [-0.2410+%i*0.5573,
         -0.2410-%i*0.5573,
         0.1503,
         -0.0972,
         -0.2590];

[s_sorted1, indices1] = esort(poles1);
disp('Sorted poles:');
disp(s_sorted1);
disp('Indices of sorted poles:');
disp(indices1);

// Test Case 2:

poles2 = [0.5+%i*0.2;
          -0.3-%i*0.1;
          -0.7;
          0.4+%i*0.3;
          -0.2];
[s_sorted2, indices2] = esort(poles2);
disp('Sorted poles:');
disp(s_sorted2);
disp('Indices of sorted poles:');
disp(indices2);

// Test Case 3:

poles3 = [1;
          -2;
          3;
          -4;
          5];
[s_sorted3, indices3] = esort(poles3);
disp('Sorted poles:');
disp(s_sorted3);
disp('Indices of sorted poles:');
disp(indices3);

// Test Case 4:

poles4 = [0.1;
          -0.2;
          0.3;
          -0.4;
          0.5];
[s_sorted4, indices4] = esort(poles4);
disp('Sorted poles:');
disp(s_sorted4);
disp('Indices of sorted poles:');
disp(indices4);

*/

//-----------------------------------------------------------------------------------------------------------//
