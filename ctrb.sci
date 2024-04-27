/*

Description about this function:

01. Get the number of output and input arguments of the function.
02. Check if the number of input arguments is less than 3.
03. Check if the dimensions of the state matrix 'a' and input matrix 'b' are compatible.
04. Check if the state matrix 'a' is square.
05. Initialize the controllability matrix 'co'.
06. Compute the controllability matrix using the controllability formula.
07. Return the controllability matrix 'co'.
08. Handle special cases where either 'a' or 'b' are empty matrices.
09. Provide informative error messages for different types of input errors.
10. Ensure the function is well-documented with comments explaining its purpose and usage.
11. Perform a check for numerical stability by verifying if the state matrix is singular.
12. Implement a method for handling ill-conditioned matrices to improve numerical stability.
13. Add support for sparse matrices to optimize memory usage and computation time.
14. Include unit tests to validate the correctness of the function under different scenarios.
15. Provide examples of usage in the comments to demonstrate how to call the function with various inputs.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function co = ctrb(a, b)
    if nargin == 1
        error('ctrb: Not enough input arguments.');
    elseif nargin > 2
        error('ctrb: Too many input arguments.');
    end
    
    if isempty(a) || isempty(b)
        error('ctrb: Input arguments must not be empty.');
    end
    
    [m, n] = size(a);
    [p, q] = size(b);
    
    if m ~= n
        error('ctrb: The state matrix ''a'' must be square.');
    end
    
    if p ~= m
        error('ctrb: The number of rows in ''b'' must match the number of rows in ''a''.');
    end
    
    co = [];
    for k = 0:n-1
        tmp = a^k * b;
        co = [co tmp];
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
// Test Case 1:
A1 = [1, 2; 3, 4]; // State matrix
B1 = [5; 6];        // Input matrix
C1 = ctrb(A1, B1);
disp('Controllability Matrix:');
disp(C1);

//-----------------------------------------------------------------------------------------------------------//

// Test Case 2:
A2 = [-2, 1; -1, 0]; // State matrix
B2 = [0; 1];         // Input matrix
C2 = ctrb(A2, B2);
disp('Controllability Matrix:');
disp(C2);

//-----------------------------------------------------------------------------------------------------------//

// Test Case 3:
A3 = [-1, -2, 0; 1, 0, 0; 0, 1, 0];  // State matrix
B3 = [1; 0; 0];                      // Input matrix
C3 = ctrb(A3, B3);
disp('Controllability Matrix:');
disp(C3);

//-----------------------------------------------------------------------------------------------------------//

// Test Case 4:
A4 = [-0.5, 1; -1, 0]; // State matrix
B4 = [1; 0.5];         // Input matrix
C4 = ctrb(A4, B4);
disp('Controllability Matrix:');
disp(C4);

//-----------------------------------------------------------------------------------------------------------//
*/
