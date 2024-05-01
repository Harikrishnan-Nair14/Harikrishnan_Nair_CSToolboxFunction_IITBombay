/*

Description of the provided code:

01. Implements a function named dsort to sort discrete-time poles by magnitude in decreasing order.
02. Accepts a vector of discrete-time poles as input.
03. Sorts the poles by magnitude using the 'g' option in the gsort function.
04. Optionally returns the sorted poles and their corresponding indices.
05. Handles various input scenarios, including vectors and scalars.
06. Specifically checks for real or complex scalars to ensure correct behavior.
07. Maintains clarity with descriptive variable names such as p, s, and ndx.
08. Implements error checking to ensure robustness, such as checking for the correct number of input arguments.
09. Includes clear documentation within the code using comments and docstring-style comments.
10. Compatible with Scilab environment.
11. Provides example usage with test cases to demonstrate functionality.
12. Displays the sorted poles and their indices for each example.
13. Consistent code formatting enhances readability and maintainability.
14. Easy integration into signal processing or control system analysis workflows.
15. Adheres to best practices for function design, error handling, and documentation.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [s, ndx] = dsort(p)
    
    if nargin() <> 1 then
        error("dsort: Exactly one input argument required");
    end

    if isvector(p) then
        [s, ndx] = gsort(abs(p), 'g');
        s = p(ndx);
    elseif isscalar(p) && isreal(p) then
        s = p;
        ndx = 1;
    elseif isscalar(p) && imag(p) ~= 0 then
        s = p;
        ndx = 1;
    elseif isscalar(p) && real(p) == 0 && imag(p) == 0 then
        s = p;
        ndx = 1;
    elseif isscalar(p) && real(p) ~= 0 && imag(p) == 0 then
        s = p;
        ndx = 1;
    else
        error("dsort: Input argument must be a vector or a real or complex scalar");
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*

// Test Case 1:

p1 = [-0.5+%i*0.3; -0.2-%i*0.4; 0.1; -0.3+%i*0.2];
[s1, ndx1] = dsort(p1); 
disp("Sorted poles:");
disp(s1);
disp("Indices:");
disp(ndx1);

// Test Case 2:

p2 = [-0.5+%i*0.3; 0.1; -0.5-%i*0.3; 0.1; -0.3+%i*0.2];
[s2, ndx2] = dsort(p2);
disp("Sorted poles:");
disp(s2);
disp("Indices:");
disp(ndx2);

// Test Case 3:

p3 = [0.5-%i*0.3];
[s3, ndx3] = dsort(p3);
disp("Sorted poles:");
disp(s3);
disp("Indices:");
disp(ndx3);

// Test Case 4:

p4 = [10.0-%i*0.0];
[s4, ndx4] = dsort(p4);
disp("Sorted poles:");
disp(s4);
disp("Indices:");
disp(ndx4);

*/

//-----------------------------------------------------------------------------------------------------------//
