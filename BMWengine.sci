/*

Description of the provided BMW engine model code:

01. Displays a comprehensive overview of the BMW 4-cylinder engine model at ETH Zurich's control laboratory.
02. Details operating point: throttle, pressure, speed, lambda, and wall film.
03. Lists the input variables, including throttle position signal, relative injection quantity, ignition timing, and load torque.
04. Describes system states: throttle, pressure, speed, lambda, and wall film.
05. Specifies the output variables, which consist of engine speed and lambda sensor measurement.
06. Presents scaling information for input, state, and output variables to facilitate model interpretation.
07. Defines a function named BMWengine to encapsulate the BMW engine model with options for scaled or unscaled versions.
08. Displays appropriate usage instructions in case of invalid function arguments.
09. Implements handling for both scaled and unscaled versions of the model using switch-case statements.
10. Constructs system matrices based on the selected model version, considering the dynamics and control parameters.
11. Prints the system matrices A, B, C, and D with clear headings for each matrix and appropriate alignment.
12. Ensures consistency in formatting and spacing for enhanced readability of the displayed matrices.
13. Concludes with a clear indication of the continuous-time nature of the model.
14. Enhances code readability through meaningful variable names, clear comments, and structured output presentation.
15. Provides a detailed insight into the BMW engine model's structure, parameters, and scaling factors.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

printf("\n ...Model of the BMW 4 - Cylinder Engine at ETH Zurich’s Control Laboratory...\n");
printf('\n -----------------------------------------------------------------------------\n');

function displayInputsStatesOutputs()
    
    opname = {"  Drosselklappenstellung                        alpha_DK = 10.3 Grad", "  Saugrohrdruck                                 p_s = 0.48 bar", "  Motordrehzahl                                 n = 860 U/min", "  Lambda-Messwert                               lambda = 1.000", "  Relativer Wandfilminhalt                      nu = 1"};
    inname = {"  U_1 Sollsignal Drosselklappenstellung         [Grad]", "  U_2 Relative Einspritzmenge                   [-]", "  U_3 Zuendzeitpunkt                            [Grad KW]", "  M_L Lastdrehmoment                            [Nm]"};
    stname = {"  X_1 Drosselklappenstellung                    [Grad]", "  X_2 Saugrohrdruck                             [bar]", "  X_3 Motordrehzahl                             [U/min]", "  X_4 Messwert Lamba-Sonde                      [-]", "  X_5 Relativer Wandfilminhalt                  [-]"};
    outname = {"  Y_1 Motordrehzahl                             [U/min]", "  Y_2 Messwert Lambda-Sonde                     [-]"};
    scname = {"  U_1N, X_1N                                    1 Grad", "  U_2N, X_4N, X_5N, Y_2N                        0.05", "  U_3N                                          1.6 Grad KW", "  X_2N                                          0.05 bar", "  X_3N, Y_1N                                    200 U/min"};
    
    printf("\n OPERATING POINT:\n");
    for i = 1:length(opname)
        printf("%s\n", opname{i});
    end
    
    printf("\n INPUTS:\n");
    for i = 1:length(inname)
        printf("%s\n", inname{i});
    end

    printf("\n STATES:\n");
    for i = 1:length(stname)
        printf("%s\n", stname{i});
    end

    printf("\n OUTPUTS:\n");
    for i = 1:length(outname)
        printf("%s\n", outname{i});
    end
    
    printf("\n SCALING:\n");
    for i = 1:length(scname)
        printf("%s\n", scname{i});
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

displayInputsStatesOutputs()

printf('\n -----------------------------------------------------------------------------\n');

//-----------------------------------------------------------------------------------------------------------//

function sys = BMWengine (flg)
    
    format(25);

    if nargin == 0 then
        flg = "scaled";
    end

    switch flg
        case "unscaled"
            printf("\n  [Linearisiertes Modell, Nicht Skaliert]\n");
            printf('  ---------------------------------------\n');

            Apu = [ -40.0001     0          0          0          0;
                    0.1683    -2.94711    -0.0016     0          0;
                    26.6088   920.39321    -0.1756     0        259.1700;
                   -0.5852    14.1941     0.0061    -5.7000    -5.7000;
                    0.6600    -1.1732    -0.0052     0        -15.0000000001 ];

            Bpu = [  40.00001     0          0;
                     0          0          0;
                     0        181.4190     1.5646;
                     0         -3.9900     0;
                     0          4.5000     0      ];

            Bdpu = [  0;
                      0;
                    -15.9000;
                      0;
                      0      ];

            Cpu = [   0          0          1          0          0;
                      0          0          0          1          0 ];

            sys = syslin('c', Apu, [Bpu, Bdpu], Cpu);
            
            printf('\n ans.a :\n ');
            printf('\n  -------------------------------------------------------------------------------------------------------------------------------------\n');
            printf('                         xi                         x2                         x3                         x4                         x5');
            printf('\n  -------------------------------------------------------------------------------------------------------------------------------------');
            disp(sys.a);
            printf('  -------------------------------------------------------------------------------------------------------------------------------------\n');

            printf('\n ans.b :\n ');
            printf('\n  ----------------------------------------------------------------------------------------------------------\n');
            printf('                         u1                         u2                         u3                         u4');
            printf('\n  ----------------------------------------------------------------------------------------------------------');
            disp(sys.b);
            printf('  ----------------------------------------------------------------------------------------------------------\n');

            printf('\n ans.c :\n ');
            printf('\n  -----------------------\n');
            printf('   x1   x2   x3   x4   x5');
            printf('\n  -----------------------');
            disp(sys.c);
            printf('  -----------------------\n');

            printf('\n ans.d :\n ');
            printf('\n  ------------------\n');
            printf('   u1   u2   u3   u4');
            printf('\n  ------------------');
            disp(sys.d);
            printf('  ------------------\n');
            
            printf('\n Continous - Time Model !!\n');
            
        case "scaled"
            printf("\n  [Skaliertes Zustandsraummodell]\n");
            printf('  -------------------------------\n');
            
            Ap = [  -40.0001    0          0          0          0;
                     3.36591      -2.94711    -6.51571     0          0;
                     0.13333      0.23011    -0.17563     0          0.0648;
                   -11.7043    14.1941    24.3932    -5.7000    -5.7001;
                    13.20031    -1.17321   -20.9844     0        -15.0002 ];

            Bp = [   40.00001     0          0;
                     0          0          0;
                     0          0.0454     0.012501;
                     0         -3.9999     0;
                     0          4.50011     0      ];

            Bdp = [   0;
                      0;
                     -1.5900;
                      0;
                      0      ];

            Cp = [    0          0          1          0          0;
                      0          0          0          1          0 ];

            sys = syslin('c', Ap, [Bp, Bdp], Cp);
    
            printf('\n ans.a :\n ');
            printf('\n  -------------------------------------------------------------------------------------------------------------------------------------\n');
            printf('                         xi                         x2                         x3                         x4                         x5');
            printf('\n  -------------------------------------------------------------------------------------------------------------------------------------');
            disp(sys.a);
            printf('  -------------------------------------------------------------------------------------------------------------------------------------\n');

            printf('\n ans.b :\n ');
            printf('\n  ----------------------------------------------------------------------------------------------------------\n');
            printf('                         u1                         u2                         u3                         u4');
            printf('\n  ----------------------------------------------------------------------------------------------------------');
            disp(sys.b);
            printf('  ----------------------------------------------------------------------------------------------------------\n');

            printf('\n ans.c :\n ');
            printf('\n  -----------------------\n');
            printf('   x1   x2   x3   x4   x5');
            printf('\n  -----------------------');
            disp(sys.c);
            printf('  -----------------------\n');

            printf('\n ans.d :\n ');
            printf('\n  ------------------\n');
            printf('   u1   u2   u3   u4');
            printf('\n  ------------------');
            disp(sys.d);
            printf('  ------------------\n');   
            
            printf('\n Continous - Time Model !!\n'); 
    
        otherwise
            error('Invalid argument. Usage: sys = BMWengine(''scaled'') or sys = BMWengine(''unscaled'')');
    end

endfunction

//-----------------------------------------------------------------------------------------------------------//

BMWengine('scaled');

BMWengine('unscaled');

//-----------------------------------------------------------------------------------------------------------// 
