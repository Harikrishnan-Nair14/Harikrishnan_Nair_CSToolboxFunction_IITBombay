/*

Description of the provided code:

01. Clears the command window and workspace, ensuring a clean environment for execution.
02. Suppresses function prototype warnings using funcprot(0) to enhance code readability.
03. Displays a heading indicating the model of the Westland Lynx Helicopter about hover.
04. Defines descriptive names for input, state, and output variables to enhance code clarity.
05. Displays the names of input, state, and output variables in separate sections for clarity.
06. Implements clear section separators using ASCII art to enhance visual organization.
07. Defines a function named WestlandLynx to encapsulate the dynamics and control parameters.
08. Sets the output format to display floating-point numbers with 10 decimal places for precision.
09. Initializes matrices a0, b0, c0, and d0 representing system dynamics and control parameters.
10. Prints the dynamics and control parameters of the Westland Lynx Helicopter with appropriate headings.
11. Displays matrices a0, b0, c0, and d0 with aligned column headings for readability.
12. Ensures consistent formatting and spacing throughout the displayed matrices.
13. Includes a clear indication of the continuous-time model at the end of the output.
14. Enhances code readability by using clear variable names and meaningful comments.
15. Provides a comprehensive overview of the Westland Lynx Helicopter's model and control parameters.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

printf("\n ...Model of the Westland Lynx Helicopter about Hover....\n");
printf(' --------------------------------------------------------\n');

function displayInputsStatesOutputs()
    
    inname = {"  Main Rotor Collective     (mrc)", "  Longitudinal Cyclic       (lc)", "  Lateral Cyclic            (lac)", "  Tail Rotor Collective     (trc)"};
    stname = {"  Pitch Attitude            (theta)          [rad]", "  Roll Attitude             (phi)            [rad]", "  Roll Rate                 (p)              [rad/s]", "  Pitch Rate                (q)              [rad/s]", "  Yaw Rate                  (xi)             [rad/s]", "  Forward Velocity          (v_x)            [ft/s]", "  Lateral Velocity          (v_y)            [ft/s]", "  Vertical Velocity         (v_z)            [ft/s]"};
    outname = {"  Heave Velocity            (H_dot)          [ft/s]", "  Pitch Attitude            (theta)          [rad]", "  Roll Attitude             (phi)            [rad]", "  Heading Rate              (psi_dot)        [rad/s]", "  Roll Rate                 (p)              [rad/s]", "  Pitch Rate                (q)              [rad/s]"};

    printf(" Inputs:\n");
    for i = 1:length(inname)
        printf("%s\n", inname{i});
    end

    printf("\n States:\n");
    for i = 1:length(stname)
        printf("%s\n", stname{i});
    end

    printf("\n Outputs:\n");
    for i = 1:length(outname)
        printf("%s\n", outname{i});
    end
    
endfunction

//-----------------------------------------------------------------------------------------------------------//

displayInputsStatesOutputs()

printf(' --------------------------------------------------------\n');

//-----------------------------------------------------------------------------------------------------------//

function WestlandLynx ()
    
    format(10);
    
    a01 = [               0                  0                  0   0.99857378005981;
                          0                  0   1.00000000000000  -0.00318221934140;
                          0                  0 -11.57049560546880  -2.54463768005371;
                          0                  0   0.43935656547546  -1.99818229675293;
                          0                  0  -2.04089546203613  -0.45899915695190;
         -32.10360717773440                  0  -0.50335502624512   2.29785919189453;
           0.10216116905212  32.05783081054690  -2.34721755981445  -0.50361156463623;
          -1.91097259521484   1.71382904052734  -0.00400543212891  -0.05741119384766];

    a02 = [  0.05338427424431                  0                  0                  0;
             0.05952465534210                  0                  0                  0;
            -0.06360262632370   0.10678052902222  -0.09491866827011   0.00710757449269;
                            0   0.01665188372135   0.01846204698086  -0.00118747074157;
            -0.73502779006958   0.01925575733185  -0.00459562242031   0.00212036073208;
                            0  -0.02121581137180  -0.02116791903973   0.01581159234047;
             0.83494758605957   0.02122657001019  -0.03787973523140   0.00035400385968;
                            0   0.01398963481188  -0.00090675335377  -0.29051351547241];

    a0 = [a01 a02];

    b0 = [                  0                  0                  0                  0;
                            0                  0                  0                  0;
             0.12433505058289   0.08278584480286  -2.75247764587402  -0.01788876950741;
            -0.03635892271996   0.47509527206421   0.01429074257612                  0;
             0.30449151992798   0.01495801657438  -0.49651837348938  -0.20674192905426;
             0.28773546218872  -0.54450607299805  -0.01637935638428                  0;
            -0.01907348632812   0.01636743545532  -0.54453611373901   0.23484230041504;
            -4.82063293457031  -0.00038146972656                  0                  0];

    c0 = [  0.00000        0.0         0         0         0    0.059502   0.0532901  -0.996803;
          1.0        0         0         0         0         0         0        0;
            0      1.000001         0         0         0.000001         0         0        0;
            0.0000        0         0  -0.0534803       1.0         0         0        0;
            0        0       1.0         0         0         0         0        0;
            0.0000001        0         0.000001       1.0         0         0         0       0];

    d0 = zeros (6, 4);

printf("\n ...Dynamics and Control Parameters of the Westland Lynx Helicopter...\n");  
 
printf('\n ans.a :\n ');
printf('\n  -----------------------------------------------------------------------------------------------\n');
printf('       theta        phi            p           q          xi         v_x         v_y         v_z');
printf('\n  -----------------------------------------------------------------------------------------------');
disp(a0);
printf('  -----------------------------------------------------------------------------------------------\n');

printf('\n ans.b :\n ');
printf('\n  -----------------------------------------------\n');
printf('         mrc          lc         lac         trc');
printf('\n  -----------------------------------------------');
disp(b0);
printf('  -----------------------------------------------\n');

printf('\n ans.c :\n ');
printf('\n  ------------------------------------------------------------------------------------------\n');
printf('       theta        phi          p           q         xi        v_x         v_y        v_z');
printf('\n  ------------------------------------------------------------------------------------------');
disp(c0);
printf('  ------------------------------------------------------------------------------------------\n');

printf('\n ans.d :\n ');
printf('\n  ------------------\n');
printf('  mrc   lc  lac  trc');
printf('\n  ------------------');
disp(d0);
printf('  ------------------\n');

printf('\n Continous - Time Model !!');

endfunction

//-----------------------------------------------------------------------------------------------------------//

WestlandLynx();  // Call the Function to get all the Details

//-----------------------------------------------------------------------------------------------------------//

/*

NOTE: IN ORDER TO GET ALL THE DETAILS AND SPECIFICATIONS OF WESTLAND LYNX HELICOPTER SUCH AS ITS MODEL, DYNAMICS AND CONTROL PARAMETERS ABOUT THE HOVER, JUST SIMPLY CALL THE FUNCTION AS MENTIONED ABOVE TO SEE ITS PARAMETERS. THE SPECIFICATIONS AND PARAMETERS DEFINED OVER HERE ARE CONSIDERED TO BE A FIXED VALUE FOR A WESTLAND LYNX HELICOPTER AND ARE NOT MEANT TO CHANGE FREQUENTLY EXCEPT FOR EXTREMELY SMALL VALUES...

*/

//-----------------------------------------------------------------------------------------------------------//
