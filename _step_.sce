clc; // Clear the command window
clear all; // Clear all variables from the workspace
funcprot(0); // Set the function prototype to 0

//-----------------------------------------------------------------------------------------------------------//

// Define the _step_ function
function [y,x]=_step_(u,dt,sl,x0,tol)
    [lhs,rhs]=argn(0); // Get the number of output and input arguments of the function

    if rhs<3 then // If the number of input arguments is less than 3
        msg = _("%s: Wrong number of input arguments: At least %d expected.\n");
        error(msprintf(msg, "_step_", 3)); // Display an error message
    end

    sltyp=typeof(sl); // Get the type of the linear dynamical system sl
    if and(sltyp<>["state-space" "rational" "zpk"]) then // If the type of sl is not one of "state-space", "rational", or "zpk"
        args=["u","dt","sl","x0","tol"];
        ierr=execstr("[y,x]=%"+typeof(sl,"overload")+"_step_("+strcat(args(1:rhs),",")+")","errcatch"); // Try to execute a function named after the type of sl with "_step_" appended to it
        if ierr<>0 then // If the execution fails
            error(msprintf(_("%s: Wrong type for input argument #%d: Linear dynamical system expected.\n"),"_step_",3)); // Display an error message
        end

        return; // Return from the function
    end

    if sltyp=="rational" then // If the type of sl is "rational"
        sl=tf2ss(sl); // Convert sl to state-space representation
    elseif sltyp=="zpk" then // If the type of sl is "zpk"
        sl=zpk2ss(sl); // Convert sl to state-space representation
    end

    if sl.dt<>"c" then // If the system sl is not continuous-time
        warning(msprintf(gettext("%s: Input argument #%d is assumed continuous time.\n"),"_step_",1)); // Display a warning message
    end

    [a,b,c,d]=abcd(sl); // Get the state-space matrices A, B, C, and D from the system sl
    if degree(d)>0 then // If the degree of the D matrix is greater than 0
        error(msprintf(gettext("%s: Wrong type for input argument #%d: A proper system expected\n"),"_step_",1)); // Display an error message
    end

    ma=size(a,1); // Get the number of rows of the A matrix
    mb=size(d,2); // Get the number of columns of the D matrix
    imp=0; step=0; // Initialize the variables imp and step to 0
    text="if t==0 then y=0, else y=1,end"; // Define a string that represents a piece of code
    select type(u) // Check the type of the control u and perform different operations based on its type
    case 10 then // If the type of u is 10 (string)

        if mb<>1 then // If the number of columns of the D matrix is not 1
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A SIMO expected.\n"),"_step_",1)); // Display an error message
        end

        if part(u,1)=="i" then // If the first character of u is "i"
            imp=1; // Set imp to 1
            dt(dt==0)=%eps^2; // Replace zeros in dt with a very small positive number
        elseif part(u,1)=="s" then // If the first character of u is "s"
            step=1; // Set step to 1
            if norm(d,1)<>0 then // If the 1-norm of the D matrix is not 0
                dt(dt==0)=%eps^2; // Replace zeros in dt with a very small positive number
            end

        else // If the first character of u is neither "i" nor "s"
            error(msprintf(gettext("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"),"_step_",1,"""step"",""impuls""")); // Display an error message
        end

        deff("[y]=u(t)",text); // Define a function u(t) that returns 0 if t is 0 and 1 otherwise
    case 13 then // If the type of u is 13 (function)
    case 1 then // If the type of u is 1 (matrix)
        [mbu,ntu]=size(u); // Get the size of u

        if mbu<>mb | ntu<>size(dt,"*") then // If the number of rows of u is not equal to the number of columns of the D matrix or the number of columns of u is not equal to the total number of elements in dt
            error(msprintf(gettext("%s: Incompatible input arguments #%d and #%d: Same column dimensions expected.\n"),"_step_",1,2)); // Display an error message
        end

    case 15 then // If the type of u is 15 (list)
        uu=u(1); // Get the first element of u
    else // If the type of u is neither 10, 13, 1, nor 15
        error(msprintf(gettext("%s: Wrong type for input argument #%d: Function expected"), "_step_", 2)); // Display an error message
    end

    if isempty(dt) then // If dt is empty
        y = []; // Set y to an empty matrix
        x = []; // Set x to an empty matrix
        return; // Return from the function
    end

    if rhs==3 then x0=sl(6),end // If the number of input arguments is 3, set x0 to the 6th element of sl
    if imp==1|step==1 then x0=0*x0,end // If imp or step is 1, set x0 to a zero vector of the same size as x0

    nt=size(dt,"*");x= zeros(ma,nt); // Get the total number of elements in dt and initialize x as a zero matrix with ma rows and nt columns
    [a,v]=balanc(a); // Balance the A matrix to improve the accuracy of computations
    v1=v; // Store the balancing transformation matrix v in v1
    [k,l]=find(v<>0) // Find the indices of the non-zero elements of v
    v=v(k,l); // Reorder the rows and columns of v according to the indices found in the previous line
    c=c(:,k)*v; // Apply the balancing transformation to the C matrix
    v=diag(1 ./diag(v));b=v*b(k,:);x0=v*x0(k) // Apply the inverse of the balancing transformation to the B matrix and x0
    [a,v2,bs]=bdiag(a,1);b=v2\b;c=c*v2;x0=v2\x0; // Block-diagonalize the A matrix and apply the same transformation to the B, C, and x0

    if type(u)==1 then // If the type of u is 1 (matrix)
        ut=u; // Set ut to u
        if min(size(ut))==1 then ut=matrix(ut,1,-1),end // If ut is a vector, reshape it into a row vector
        deff("[y]=u(t)",["ind=find(dt<=t);nn=ind($)"
        "if isempty(nn) then"
        "y=[]"
        "elseif (t==dt(nn)|nn==nt) then "
        "   y=ut(:,nn)"
        "else "
        "   y=ut(:,nn)+(t-dt(nn))/(dt(nn+1)-dt(nn))*(ut(:,nn+1)-ut(:,nn))"
        "end"]); // Define a function u(t) that returns a linear interpolation of ut at t

        deff("[ydot]=%sim2(%tt,%y)","ydot = [];if ~isempty(u(%tt)) then ydot = ak*%y+bk*u(%tt);end"); // Define a function %sim2(t,y) that returns the derivative of y at t

    elseif type(u)<>15 then // If the type of u is not 15 (list)
        deff("[ydot]=%sim2(%tt,%y)","ydot=ak*%y+bk*u(%tt)"); // Define a function %sim2(t,y) that returns the derivative of y at t
        ut=ones(mb,nt);for k=1:nt, ut(:,k)=u(dt(k)),end // Set ut to a matrix whose columns are u(dt(k))

    else // If the type of u is 15 (list)
        %sim2=u; // Set %sim2 to u
        tx=" ";for l=2:size(u), tx=tx+",%"+string(l-1);end; // Generate a string that contains ",2", ",3", ..., up to the size of u
        deff("[ydot]=sk(%tt,%y,u"+tx+")","ydot=ak*%y+bk*u(%tt"+tx+")"); // Define a function sk(t,y,u...) that returns the derivative of y at t
        %sim2(0)=sk;u=u(1) // Set %sim2 to sk and u to the first element of u
        deff("[ut]=uu(t)",...
        ["["+part(tx,3:length(tx))+"]=%sim2(3:"+string(size(%sim2))+")";
        "ut=ones(mb,nt);for k=1:nt, ut(:,k)=u(t(k)"+tx+"),end"]) // Define a function uu(t) that returns a matrix whose columns are u(t(k),...)
        ut=uu(dt); // Set ut to uu(dt)
    end;

    k=1; // Initialize k to 1
    for n=bs', // For each element n in bs
        kk=k:k+n-1; // Set kk to a vector from k to k+n-1
        ak=a(kk,kk); // Get the submatrix of A specified by kk
        bk=b(kk,:); // Get the submatrix of B specified by kk
        nrmu=max([norm(bk*ut,1),norm(x0(kk))]); // Compute the maximum of the 1-norm of bk*ut and the 2-norm of x0(kk)

        if nrmu > 0 then // If nrmu is greater than 0
            if rhs<5 then // If the number of input arguments is less than 5
                atol=1.d-12*nrmu;rtol=atol/100; // Set atol to 1.d-12*nrmu and rtol to atol/100
            else // If the number of input arguments is not less than 5
                atol=tol(1);rtol=tol(2); // Set atol to the first element of tol and rtol to the second element of tol
            end

            xkk=ode("adams",x0(kk),0,dt,rtol,atol,%sim2); // Solve the ODE using the Adams method and set xkk to the solution
            if size(xkk,2)<>size(x,2) then // If the number of columns of xkk is not equal to the number of columns of x
                error(msprintf(_("%s: Simulation failed before final time is reached.\n"),"_step_")) // Display an error message
            end

            x(kk,:)=xkk; // Set the rows of x specified by kk to xkk
            if imp==1 then x(kk,:)=ak*x(kk,:)+bk*ut,end // If imp is 1, set the rows of x specified by kk to ak*x(kk,:)+bk*ut
        end;

        k=k+n // Increment k by n
    end;

    if isempty(c) // If c is empty
        y = d*ut; // Set y to d*ut
    else // If c is not empty
        y = c*x + d*ut // Set y to c*x + d*ut
    end
    if lhs==2 then x=v1*v2*x,end // If there are two output arguments, transform x back to the original coordinates
endfunction // End of the function

//-----------------------------------------------------------------------------------------------------------//

// Define the Laplace variable
s = %s;

// Define the transfer functions for the test cases
g1 = syslin('c', 1 / (2 * s^2 + 3 * s^1 + 4));
g2 = syslin('c', 1 / (s^2 + s + 1));
g3 = syslin('c', 1 / (s^2 + 0.5 * s + 1));
g4 = syslin('c', 1 / (s^2 + 0.1 * s + 1));

// Convert the systems to state-space representation
ss_g1 = tf2ss(g1);
ss_g2 = tf2ss(g2);
ss_g3 = tf2ss(g3);
ss_g4 = tf2ss(g4);

// Define time vector for simulation
t = 0:0.01:08;

// Define a step input
u = ones(1, length(t));

// Compute the step responses using the defined transfer functions and time vector
y1 = _step_(u, t, ss_g1);
y2 = _step_(u, t, ss_g2);
y3 = _step_(u, t, ss_g3);
y4 = _step_(u, t, ss_g4);

// Create a new figure
scf();

// Plot step responses in subplots
subplot(2,2,1); // Select the first subplot
plot(t, y1, 'b'); // Plot the first response in blue
title('Test Case 1');
xlabel('Time [s]');
ylabel('y1');

subplot(2,2,2); // Select the second subplot
plot(t, y2, 'g'); // Plot the second response in green
title('Test Case 2');
xlabel('Time [s]');
ylabel('y2');

subplot(2,2,3); // Select the third subplot
plot(t, y3, 'r'); // Plot the third response in red
title('Test Case 3');
xlabel('Time [s]');
ylabel('y3');

subplot(2,2,4); // Select the fourth subplot
plot(t, y4, 'm'); // Plot the fourth response in magenta
title('Test Case 4');
xlabel('Time [s]');
ylabel('y4');

//-----------------------------------------------------------------------------------------------------------//

// Display the results in the console using mprintf
mprintf("Transfer Function: \n");
disp(g1);    // Display the transfer function g1 or g2 or g3 or g4 in the console
mprintf("\nState-Space Representation: \n");
disp(ss_g1);    // Display the state-space representation ss_g1 or ss_g2 or ss_g3 or ss_g4 in the console
mprintf("\nPoles of the System: \n");
disp(roots(g1(3)));    // Compute and display the roots of the denominator polynomial of g1 or g2 or g3 or g4 in the console
mprintf("\nFinal Value of the Step Response: \n");
disp(y1($));    // Display the final value of the step response y1 or y2 or y3 or y4 in the console
mprintf("\nFull Step Response Output: \n");
disp(y1);    // Display the full step response output y1 or y2 or y3 or y4 in the console
