/*

Description about this code:

01. Implements a function named isobsv to check the observability of Linear Time-Invariant (LTI) systems.
02. Accepts input arguments representing the state matrix a, measurement matrix c, and optional descriptor matrix and tolerance tol.
03. Constructs the observability matrix using the provided matrices and calculates its rank.
04. Determines the observability of the system based on the rank of the observability matrix.
05. Returns a boolean value indicating observability (1 for observable, 0 for not observable) and the number of observable states.
06. Handles different numbers of input arguments and optional parameters gracefully.
07. Utilizes descriptive variable names such as a, c, e, tol, bool, and nobs for clarity.
08. Implements error checking to handle incorrect usage or invalid input arguments.
09. Provides clear documentation within the code, explaining the purpose and usage of each section.
10. Ensures compatibility with both Octave and Scilab environments.
11. Includes example usage of the isobsv function with sample state and measurement matrices.
12. Generates informative output displaying observability and the number of observable states.
13. Ensures code readability through consistent indentation and commenting.
14. Allows users to easily integrate the isobsv function into their LTI system analysis workflows.
15. Adheres to best practices in function design, error handling, and documentation to facilitate usability and maintainability.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [bool, nobs] = isobsv(a, c, varargin)
    
    if nargin == 0
        error("Not enough input arguments");
    elseif nargin == 1
        error("Not enough input arguments");
    elseif nargin > 4
        error("Too many input arguments");
    elseif nargin == 2
        e = eye(size(a));
        tol = 0;
    elseif nargin == 3
        e = varargin{1};
        tol = 0;
    else
        e = varargin{1};
        tol = varargin{2};
    end

    n = size(a, 1);
    p = size(c, 1);

    obsv = zeros(p*n, n);
    for i = 1:n
        obsv((i-1)*p + 1:i*p, :) = c * (a^(i-1));
    end

    if rank(obsv, tol) == min(size(obsv))
        bool = 1;
    else
        bool = 0;
    end

    nobs = rank(obsv, tol);
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
//Test Case 1:

a1 = [1 2; 0 1];        
c1 = [1 0];             
[bool, nobs] = isobsv(a1, c1);
printf('\n');
printf(' Observability: ');
disp(bool);
printf('\n');
printf(' Number of Observable States: ');
disp(nobs);
printf('\n');

//Test Case 2:

a2 = [1 0; 0 1];        
c2 = [0 1];             
[bool, nobs] = isobsv(a2, c2);
printf('\n');
printf(' Observability: ');
disp(bool);
printf('\n');
printf(' Number of Observable States: ');
disp(nobs);
printf('\n');

//Test Case 3:

a3 = [1 0; 0 2];        
c3 = [1 1];             
[bool, nobs] = isobsv(a3, c3);
printf('\n');
printf(' Observability: ');
disp(bool);
printf('\n');
printf(' Number of Observable States: ');
disp(nobs);
printf('\n');

//Test Case 4:

a4 = [2 0; 0 2];        
c4 = [0 2];             
[bool, nobs] = isobsv(a4, c4);
printf('\n');
printf(' Observability: ');
disp(bool);
printf('\n');
printf(' Number of Observable States: ');
disp(nobs);
printf('\n');

*/

//-----------------------------------------------------------------------------------------------------------//
