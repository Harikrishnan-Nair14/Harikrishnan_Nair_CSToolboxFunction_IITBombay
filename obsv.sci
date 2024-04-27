/*

Description about this function:

01. This Scilab program is designed to compute the observability matrix for a linear time-invariant (LTI) system.
02. The program includes a function named 'obsv' that takes either one or two arguments.
03. If one argument is provided, it should be an LTI model in state-space representation.
04. If two arguments are provided, they should be the state matrix 'a' and the measurement matrix 'c'.
05. The 'obsv' function computes the observability matrix based on these inputs.
06. The observability matrix is a crucial concept in control theory.
07. It determines whether the state of a system can be estimated by measuring the outputs.
08. The program also includes four test cases to demonstrate the usage of the 'obsv' function.
09. Each test case defines an LTI system with specific state and measurement matrices.
10. The observability matrix for each system is computed using the 'obsv' function and then displayed in the console.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function ob = obsv(varargin)
    
    if nargin == 1
        sys = varargin(1);
        ob = ctrb(sys').';
    elseif nargin == 2
        a = varargin(1);
        c = varargin(2);
        n = size(a, 1);
        ob = c;
        for i = 1:(n-1)
            c = c * a;
            ob = [ob; c];
        end
    else
        error("Invalid number of input arguments.");
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
//Test Case 1:

A = [0, 1; -2, 3];
C = [1, 0];
ob = obsv(A, C);
disp("Observability Matrix:");  
disp(ob);

//-----------------------------------------------------------------------------------------------------------//

//Test Case 2:

A2 = [0, 1; 0, 0];
C2 = [1, 1];
ob2 = obsv(A2, C2);
disp("Observability Matrix:");
disp(ob2);

//-----------------------------------------------------------------------------------------------------------//

//Test Case 3:

A3 = [0, 1; -2, -3];
C3 = [1, 0];
ob3 = obsv(A3, C3);
disp("Observability Matrix:");
disp(ob3);

//-----------------------------------------------------------------------------------------------------------//

//Test Case 4:

A4 = [0, 1, 0; 0, 0, 1; -1, -5, -6];
C4 = [1, 0, 0];
ob4 = obsv(A4, C4);
disp("Observability Matrix:");
disp(ob4);

//-----------------------------------------------------------------------------------------------------------//
*/
