/*

Description about this code:

01. Clears the workspace and command window, and turns off function prototyping.
02. Defines a custom any function to determine if the sum of a vector is greater than zero.
03. Defines a function named series to compute the series connection of two Linear Time-Invariant (LTI) systems.
04. Checks the number of input arguments to ensure correct usage of the series function.
05. Computes the series connection of two LTI systems based on the provided input arguments.
06. Implements error checking to handle invalid input arguments and guide users towards correct usage.
07. Uses the Laplace variable %s to represent the Laplace domain variable in defining transfer functions.
08. Creates two example LTI systems (sys1 and sys2) with transfer functions and specific variable s.
09. Defines output and input indices (outputs1 and inputs2) to specify the connections between the LTI systems.
10. Computes the series connection of sys1 and sys2 using the series function.
11. Prints the resulting transfer function obtained from the series connection of the two LTI systems.
12. Ensures clear documentation with comments explaining the purpose and functionality of each section of the code.
13. Implements error handling to inform users of incorrect usage or invalid input arguments.
14. Uses descriptive variable names for readability and clarity throughout the code.
15. Provides a clear example of how to use the series function with explanations of its input arguments and expected output.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function result = any(x)
    result = sum(x) > 0;
endfunction

function sys = series (sys1, sys2, out1, in2)

    if nargin == 2 then
        sys = sys2 * sys1;
    elseif nargin == 4 then
        [p1, m1] = size (sys1);
        [p2, m2] = size (sys2);

        if ~isreal(out1) | ~isreal(in2) then
            error('series: arguments 3 (outputs1) and 4 (inputs2) must be real vectors');
        end

        l_out1 = length(out1);
        l_in2 = length(in2);

        if l_out1 > p1 then
            error('series: ''outputs1'' has too many indices for ''sys1''');
        end

        if l_in2 > m2 then
            error('series: ''inputs2'' has too many indices for ''sys2''');
        end

        if l_out1 ~= l_in2 then
            error('series: number of ''outputs1'' and ''inputs2'' indices must be equal');
        end

        if any(out1 > p1 | out1 < 1) then
            error('series: range of ''outputs1'' indices exceeds dimensions of ''sys1''');
        end

        if any(in2 > m2 | in2 < 1) then
            error('series: range of ''inputs2'' indices exceeds dimensions of ''sys2''');
        end

        out_scl = zeros(p1, l_out1);
        for i = 1:l_out1
            out_scl(out1(i), i) = 1;
        end

        in_scl = zeros(l_in2, m2);
        for i = 1:l_in2
            in_scl(i, in2(i)) = 1;
        end

        scl = in_scl * out_scl;
        sys = sys2 * scl * sys1;
        
    else
        error('series: Incorrect number of input arguments');
    end

endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
// Test Case 1:

s = %s;
sys1 = syslin('c', 2/(s^12 + 3*s^2 + 12));  
sys2 = syslin('c', 1/(s + 1));          
outputs1 = [1];   
inputs2 = [1];    
sys = series(sys1, sys2, outputs1, inputs2);
printf('  The Transfer Function is given by:  ');
disp(sys);
printf('\n');

// Test Case 2:

s = %s;
sys1 = syslin('c', 3/(s^3 + 4*s^2 + 2*s + 1));  
sys2 = syslin('c', 1/(s^2 + 3*s + 1));          
outputs1 = [1];   
inputs2 = [1];    
sys = series(sys1, sys2, outputs1, inputs2);
printf('  The Transfer Function is given by:  ');
disp(sys);
printf('\n');

// Test Case 3:

s = %s;
sys1 = syslin('c', 1/(s^2 + 2*s + 1));  
sys2 = syslin('c', 1/(s^2 + 3*s + 1));          
outputs1 = [1];   
inputs2 = [1];    
sys = series(sys1, sys2, outputs1, inputs2);
printf('  The Transfer Function is given by:  ');
disp(sys);
printf('\n');

// Test Case 4:  

s = %s;
sys1 = syslin('c', 2/(s^2 + 3*s + 2));  
sys2 = syslin('c', 1/(s + 1));          
outputs1 = [1];   
inputs2 = [1];    
sys = series(sys1, sys2, outputs1, inputs2);
printf('  The Transfer Function is given by:  ');
disp(sys);
printf('\n');
*/

//-----------------------------------------------------------------------------------------------------------//
