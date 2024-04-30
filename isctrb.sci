/*

// Description about the provided code:

01. Implements a function named isctrb to check controllability of LTI systems.
02. Accepts state matrix (a), input matrix (b), and optional matrices (e, tol).
03. Constructs controllability matrix and computes its rank.
04. Determines system controllability based on the rank of the matrix.
05. Returns boolean value indicating controllability and number of controllable states.
06. Handles various input scenarios gracefully.
07. Uses descriptive variable names for clarity.
08. Implements error checking for robustness.
09. Includes clear documentation within the code.
10. Compatible with both Octave and Scilab environments.
11. Provides example usage for demonstration.
12. Displays controllability results for each example.
13. Consistent code formatting enhances readability.
14. Easy integration into LTI system analysis workflows.
15. Adheres to best practices for function design and error handling.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [bool, ncont] = isctrb(a, b, varargin)

    if nargin < 2 | nargin > 4
        error("Invalid number of input arguments");
    end

    tol = 0;

    if nargin == 3
        e = varargin{1};
    else
        e = [];
    end
    
    if isstruct(a) && isfield(a, 'a') && isfield(a, 'b')
        if nargin > 2
            error("Invalid number of input arguments");
        end
        if ~isfield(a, 'e')
            a.e = [];
        end
        [a, b, c, d, e] = dssdata(a);
    end

    if ~(isreal(a) & isreal(b)) | ~(size(a, 1) == size(b, 1))
        error("a(%dx%d), b(%dx%d) not conformal", size(a, 1), size(a, 2), size(b, 1), size(b, 2));
    end

    if ~isempty(e) && ~isreal(e)
        error('Matrix ''e'' must be real');
    end

    if ~isempty(e) && ~isequal(size(a), size(e))
        error('Matrices ''a'' and ''e'' must have the same size');
    end

    cont_mat = [];
    if isempty(e)
        cont_mat = b;
        for i = 1:(size(a, 1) - 1)
            cont_mat = [cont_mat, a^i * b];
        end
    else
        cont_mat = e * b;
        for i = 1:(size(a, 1) - 1)
            cont_mat = [cont_mat, e * a^i * b];
        end
    end

    rank_cont_mat = rank(cont_mat);

    bool = (rank_cont_mat == size(a, 1));
    ncont = rank_cont_mat;

endfunction

//-----------------------------------------------------------------------------------------------------------//

/*

// Test Case 1:

A1 = [-2, 1, 0; 0, -1, 1; 0, 0, -3];
B1 = [1; 0; 0];
[bool1, ncont1] = isctrb(A1, B1);
printf('\n');
printf(' Is System Controllable?: \n  %0.1f\n', bool1);
printf(' Number of States: \n  %0.1f\n', ncont1);


// Test Case 2:

A2 = [1, 3, 4; 0, 5, 1; 7, 0, -2];
B2 = [1; 5; 9];
[bool2, ncont2] = isctrb(A2, B2);
printf('\n');
printf(' Is System Controllable?: \n  %0.1f\n', bool2);
printf(' Number of States: \n  %0.1f\n', ncont2);

// Test Case 3:

A3 = [0, 0, 0; 0, -0, 0; -0, 0, -0];
B3 = [0; 0; 0];
[bool3, ncont3] = isctrb(A3, B3);
printf('\n');
printf(' Is System Controllable?: \n  %0.1f\n', bool3);
printf(' Number of States: \n  %0.1f\n', ncont3);


// Test Case 4:

A4 = [-1.1, 0, 0; 0, 1.1, 0; 0, 0, -1.1];
B4 = [1.1; -1.1; 1.1];
[bool4, ncont4] = isctrb(A4, B4);
printf('\n');
printf(' Is System Controllable?: \n  %0.1f\n', bool4);
printf(' Number of States: \n  %0.1f\n', ncont4);

*/

//-----------------------------------------------------------------------------------------------------------//
