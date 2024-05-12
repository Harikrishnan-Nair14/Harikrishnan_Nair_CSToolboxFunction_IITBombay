/*

Description about the provided code:

01. Implements a function named pid to calculate the transfer function of a PID controller.
02. Accepts gain parameters (Kp, Ki, Kd), filter coefficient (Tf), and sampling time (Ts) as inputs.
03. Constructs the numerator and denominator of the transfer function based on the input parameters.
04. Determines the system type (continuous-time or discrete-time) based on the sampling time.
05. Returns the transfer function C, and the numerator and denominator arrays.
06. Handles various input scenarios gracefully by checking the number of arguments.
07. Uses descriptive variable names for clarity.
08. Implements error checking for robustness by checking the values of the gain parameters and the sampling time.
09. Includes clear documentation within the code.
10. Compatible with Scilab environment.
11. Provides a function repeatString for generating a string of repeated characters, used for formatting the output.
12. Displays the transfer function in a nicely formatted way.
13. Consistent code formatting enhances readability.
14. Easy integration into control system analysis workflows.
15. Adheres to best practices for function design and error handling.
16. Implements a function displayTransferFunction to display the transfer function in a properly aligned fraction form.
17. The displayTransferFunction function obtains, formats, and prints the transfer function using pid.
18. Numerator and denominator are centered, with dashes extending to the length of the longer string.
19. The code prints ‘Continuous-time model’ for Ts = 0, or else ‘Discrete-time model’.
20. This code is designed for easy understanding and modification for various PID setups and display options.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function displayTransferFunction(Kp, Ki, Kd, Tf, Ts)
    
    function [C, num, den] = pid(Kp, Ki, Kd, Tf, Ts)
        
        if argn(2) == 0 then
            Kp = 1; Ki = 0; Kd = 0; Tf = 0; Ts = 0;
        elseif argn(2) == 1 then
            Ki = 0; Kd = 0; Tf = 0; Ts = 0;
        elseif argn(2) == 2 then
            Kd = 0; Tf = 0; Ts = 0;
        elseif argn(2) == 3 then
            Tf = 0; Ts = 0;
        elseif argn(2) == 4 then
            Ts = 0;
        end

        if Kd == 0 then
            Tf = 0;
        end

        if Ki == 0 then
            num = [Kp*Tf+Kd, Kp];
            den = [Tf, 1];
        else
            num = [Kp*Tf+Kd, Kp+Ki*Tf, Ki];
            den = [Tf, 1, 0];
        end

        C = syslin('c', tf2ss(num, den));
        
        if Ts ~= 0 then
            C = dscr(C, Ts);
        end
        
    endfunction

    function s = repeatString(str, n)
        
        s = "";
        for i=1:n
            s = s + str;
        end
        
    endfunction

    [C, num, den] = pid(Kp, Ki, Kd, Tf, Ts);
    numerator = string(num(1)) + " z^2 + " + string(num(2)) + " z + " + string(num(3));
    denominator = string(den(1)) + " z^2 + " + string(den(2)) + " z + " + string(den(3));
    numeratorSpaces = repeatString(" ", floor((max(length(numerator), length(denominator)) - length(numerator))/2));
    denominatorSpaces = repeatString(" ", floor((max(length(numerator), length(denominator)) - length(denominator))/2));
    
    mprintf('____________________________________________________\n');
    mprintf('\n Transfer Function ''C'' from Input ''u1'' to Output....\n');
    mprintf(' \n');
    mprintf(' ---------------------------------------------------\n');
    mprintf('       %s%s\n', numeratorSpaces, numerator);
    mprintf('  y1:  %s\n', repeatString("-", max(length(numerator), length(denominator)))); 
    mprintf('       %s%s\n', denominatorSpaces, denominator);
    mprintf(' ---------------------------------------------------\n');
    mprintf(' \n');
    
    if (Ts == 0) then
        mprintf(' Continuous-time model.\n');
        mprintf('____________________________________________________\n');
        mprintf(' \n');
    else
        mprintf(' Sampling time: %s s\n', string(Ts));
        mprintf(' Discrete-time model.\n');
        mprintf('____________________________________________________\n');
        mprintf(' \n');
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

mprintf('\nDISCLAIMER: Entering all values as 0s would make the index to be invalid....\n');

displayTransferFunction(0.1, 0.02, 3, 0.4, 5);
displayTransferFunction(0.01, 20.115, 0.23, 4.2, 0);
displayTransferFunction(0, 2, 0, 4.05, 0.0001);
displayTransferFunction(10, 20, 0, 0, 0 );

//-----------------------------------------------------------------------------------------------------------//

/*
