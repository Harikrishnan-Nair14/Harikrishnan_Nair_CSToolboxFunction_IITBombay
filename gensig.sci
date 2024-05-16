/*

Description about the provided code:

01. Implements a function named gensig to generate various types of signals.
02. Accepts signal type (sigtype), period (tau), final time (tfinal), and sampling time (tsam).
03. Checks the number of input arguments and their validity.
04. Sets default values for tfinal and tsam if not provided.
05. Constructs time vector 't' based on tfinal and tsam.
06. Generates signals based on the selected signal type.
07. Supports sine, cosine, square, and pulse signal types.
08. Handles invalid signal types gracefully.
09. Uses mathematical functions sin, cos, and sign for signal generation.
10. Implements error checking for robustness.
11. Provides example usage for each signal type.
12. Plots generated signals with appropriate labels and titles.
13. Enhances code readability with clear variable names and comments.
14. Facilitates easy integration into signal processing workflows.
15. Adheres to best practices for function design and error handling.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [u, t] = gensig(sigtype, tau, tfinal, tsam)
    
    if argn(2) < 2 | argn(2) > 4 then
        error("gensig: Incorrect number of input arguments");
    end

    if typeof(sigtype) <> "string" then
        error("gensig: First argument must be a string");
    end

    if ~isreal(tau) | tau <= 0 then
        error("gensig: Second argument is not a valid period");
    end

    if argn(2) < 3 then
        tfinal = 5 * tau;
    elseif ~isreal(tfinal) | tfinal <= 0 then
        error("gensig: Third argument is not a valid final time");
    end

    if argn(2) < 4 then
        tsam = tau / 64;
    elseif ~isreal(tsam) | tsam <= 0 then
        error("gensig: Fourth argument is not a valid sampling time");
    end

    t = 0:tsam:tfinal;

    select sigtype
    case "sin" then
        u = sin(2*%pi/tau * t);
    case "cos" then
        u = cos(2*%pi/tau * t);
    case "square" then
        u = sign(sin(2*%pi/tau * t));
    case "pulse" then
        u = int32(modulo(t, tau) < tsam);
    else
        error("gensig: Invalid signal type");
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*

//Test Case 1:

[u, t] = gensig("sin", 2);
plot(t, u);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sine Wave');

//Test Case 2:

[u, t] = gensig("cos", 3, 20);
plot(t, u);
xlabel('Time (s)');
ylabel('Amplitude');
title('Cosine Wave');

//Test Case 3:

[u, t] = gensig("square", 1, 10, 0.01);
plot(t, u);
xlabel('Time (s)');
ylabel('Amplitude');
title('Square Wave');

//Test Case 4:

[u, t] = gensig("pulse", 5, 25, 0.05);
plot(t, u);
xlabel('Time (s)');
ylabel('Amplitude');
title('Pulse Signal');

*/

//-----------------------------------------------------------------------------------------------------------//
