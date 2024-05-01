/*

Description about this function:

01. Get the number of output and input arguments of the function.
02. Check if the number of input arguments is less than 3.
03. Get the type of the linear dynamical system sl.
04. Check if the type of sl is not one of "state-space", "rational", or "zpk".
05. Convert sl to state-space representation if needed.
06. Issue a warning if the system is not continuous-time.
07. Get the state-space matrices A, B, C, and D from the system sl.
08. Check if the degree of the D matrix is greater than 0.
09. Initialize some variables (imp and step).
10. Define a string that represents a piece of code.
11. Check the type of the control u and perform different operations based on its type.
12. If u is a string, handle it accordingly.
13. If u is a matrix, check its compatibility with the dimensions of dt.
14. If u is a list, handle it accordingly.
15. If dt is empty, set y and x to empty matrices and return.
16. Handle special cases for x0 if necessary.
17. Get the total number of elements in dt and initialize x as a zero matrix.
18. Balance the A matrix to improve the accuracy of computations.
19. Apply transformations to A, B, C, and x0 for balancing.
20. Handle different cases for the type of u.
21. Compute the derivative of y at t using the given input u.
22. Solve the ODE using the Adams method and set xkk to the solution.
23. Set the rows of x specified by kk to xkk.
24. Compute y based on the state-space representation and input u.
25. Transform x back to the original coordinates if needed.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [y,x]=step(u,dt,sl,x0,tol)
    [lhs,rhs]=argn(0); 
    if rhs<3 then 
        msg = _("%s: Wrong number of input arguments: At least %d expected.\n");
        error(msprintf(msg, "step", 3)); 
    end
    
    sltyp=typeof(sl); 
    if and(sltyp<>["state-space" "rational" "zpk"]) then 
        args=["u","dt","sl","x0","tol"];
        ierr=execstr("[y,x]=%"+typeof(sl,"overload")+"step("+strcat(args(1:rhs),",")+")","errcatch"); 
        if ierr<>0 then 
            error(msprintf(_("%s: Wrong type for input argument #%d: Linear dynamical system expected.\n"),"step",3)); 
        end
        return; 
    end
    
    if sltyp=="rational" then 
        sl=tf2ss(sl); 
    elseif sltyp=="zpk" then 
        sl=zpk2ss(sl); 
    end
    
    if sl.dt<>"c" then 
        warning(msprintf(gettext("%s: Input argument #%d is assumed continuous time.\n"),"step",1)); 
    end
    
    [a,b,c,d]=abcd(sl); 
    if degree(d)>0 then 
        error(msprintf(gettext("%s: Wrong type for input argument #%d: A proper system expected\n"),"step",1)); 
    end
    
    ma=size(a,1); 
    mb=size(d,2); 
    imp=0; step=0; 
    text="if t==0 then y=0, else y=1,end"; 
    select type(u) 
    case 10 then 
        if mb<>1 then 
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A SIMO expected.\n"),"step",1)); 
        end
        if part(u,1)=="i" then 
            imp=1; 
            dt(dt==0)=%eps^2; 
        elseif part(u,1)=="s" then 
            step=1; 
            if norm(d,1)<>0 then 
                dt(dt==0)=%eps^2; 
            end
        else 
            error(msprintf(gettext("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"),"step",1,"""step"",""impuls""")); 
        end
        
        deff("[y]=u(t)",text); 
    case 13 then 
    case 1 then 
        [mbu,ntu]=size(u); 
        if mbu<>mb | ntu<>size(dt,"*") then 
            error(msprintf(gettext("%s: Incompatible input arguments #%d and #%d: Same column dimensions expected.\n"),"step",1,2)); 
        end
    case 15 then 
        uu=u(1); 
    else 
        error(msprintf(gettext("%s: Wrong type for input argument #%d: Function expected"), "step", 2)); 
    end
    
    if isempty(dt) then 
        y = []; 
        x = []; 
        return; 
    end
    
    if rhs==3 then x0=sl(6),end 
    if imp==1|step==1 then x0=0*x0,end 
    
    nt=size(dt,"*");x= zeros(ma,nt); 
    [a,v]=balanc(a); 
    v1=v;
    [k,l]=find(v<>0) 
    v=v(k,l); 
    c=c(:,k)*v; 
    v=diag(1 ./diag(v));b=v*b(k,:);x0=v*x0(k) 
    [a,v2,bs]=bdiag(a,1);b=v2\b;c=c*v2;x0=v2\x0; 
    
    if type(u)==1 then
        ut=u; 
        if min(size(ut))==1 then ut=matrix(ut,1,-1),end 
        deff("[y]=u(t)",["ind=find(dt<=t);nn=ind($)"
        "if isempty(nn) then"
        "y=[]"
        "elseif (t==dt(nn)|nn==nt) then "
        "   y=ut(:,nn)"
        "else "
        "   y=ut(:,nn)+(t-dt(nn))/(dt(nn+1)-dt(nn))*(ut(:,nn+1)-ut(:,nn))"
        "end"]); 
        deff("[ydot]=%sim2(%tt,%y)","ydot = [];if ~isempty(u(%tt)) then ydot = ak*%y+bk*u(%tt);end"); 
    elseif type(u)<>15 then 
        deff("[ydot]=%sim2(%tt,%y)","ydot=ak*%y+bk*u(%tt)"); 
        ut=ones(mb,nt);for k=1:nt, ut(:,k)=u(dt(k)),end 
    else 
        %sim2=u; 
        tx=" ";for l=2:size(u), tx=tx+",%"+string(l-1);end; 
        deff("[ydot]=sk(%tt,%y,u"+tx+")","ydot=ak*%y+bk*u(%tt"+tx+")");        
        deff("[ut]=uu(t)",...
        ["["+part(tx,3:length(tx))+"]=%sim2(3:"+string(size(%sim2))+")";
        "ut=ones(mb,nt);for k=1:nt, ut(:,k)=u(t(k)"+tx+"),end"]) 
        ut=uu(dt);
    end;
    
    k=1; 
    for n=bs',
        kk=k:k+n-1; 
        ak=a(kk,kk);
        bk=b(kk,:); 
        nrmu=max([norm(bk*ut,1),norm(x0(kk))]);
        
        if nrmu > 0 then 
            if rhs<5 then 
                atol=1.d-12*nrmu;rtol=atol/100; 
            else 
                atol=tol(1);rtol=tol(2); 
            end
            xkk=ode("adams",x0(kk),0,dt,rtol,atol,%sim2); 
            if size(xkk,2)<>size(x,2) then 
                error(msprintf(_("%s: Simulation failed before final time is reached.\n"),"step")) 
            end
            x(kk,:)=xkk; 
            if imp==1 then x(kk,:)=ak*x(kk,:)+bk*ut,end 
        end;
        k=k+n 
    end;
    
    if isempty(c)
        y = d*ut; 
    else 
        y = c*x + d*ut 
    end
    
    if lhs==2 then x=v1*v2*x,end 
    
endfunction 

//-----------------------------------------------------------------------------------------------------------//

/*
//Test Case 1:

s = %s;
g1 = syslin('c', 1 / (2 * s^2 + 3 * s^1 + 4));
ss_g1 = tf2ss(g1);
t = 0:0.01:09;
u = ones(1, length(t));
y1 = step(u, t, ss_g1);
scf();
plot(t, y1, 'b'); 
title('Test Case 1');
xlabel('Time [s]');
ylabel('y1');

mprintf("Transfer Function: \n");
disp(g1);    
mprintf("\nState-Space Representation: \n");
disp(ss_g1);    
mprintf("\nPoles of the System: \n");
disp(roots(g1(3)));    
mprintf("\nFinal Value of the Step Response: \n");
disp(y1($));    
mprintf("\nFull Step Response Output: \n");
disp(y1);    

//-----------------------------------------------------------------------------------------------------------//

//Test Case 2:

s = %s;
g2 = syslin('c', 1 / (s^2 + s + 1));
ss_g2 = tf2ss(g2);
t = 0:0.01:20;
u = ones(1, length(t));
y2 = step(u, t, ss_g2);
scf();
plot(t, y2, 'g'); 
title('Step Response');
xlabel('Time [s]');
ylabel('y2');

mprintf("Transfer Function: \n");
disp(g2);   
mprintf("\nState-Space Representation: \n");
disp(ss_g2);   
mprintf("\nPoles of the System: \n");
disp(roots(g2(3)));   
mprintf("\nFinal Value of the Step Response: \n");
disp(y2($));   
mprintf("\nFull Step Response Output: \n");
disp(y2);   

//-----------------------------------------------------------------------------------------------------------//

//Test Case 3:

s = %s;
g3 = syslin('c', 1 / (s^2 + 0.5 * s + 1));
ss_g3 = tf2ss(g3);
t = 0:0.01:30;
u = ones(1, length(t));
y3 = step(u, t, ss_g3);
scf();
plot(t, y3, 'r');
title('Step Response');
xlabel('Time [s]');
ylabel('y3');

mprintf("Transfer Function: \n");
disp(g3);   
mprintf("\nState-Space Representation: \n");
disp(ss_g3);  
mprintf("\nPoles of the System: \n");
disp(roots(g3(3))); 
mprintf("\nFinal Value of the Step Response: \n");
disp(y3($));    
mprintf("\nFull Step Response Output: \n");
disp(y3); 

//-----------------------------------------------------------------------------------------------------------//

//Test Case 4:

s = %s;
g4 = syslin('c', 1 / (s^2 + 0.1 * s + 1));
ss_g4 = tf2ss(g4);
t = 0:0.01:0200;
u = ones(1, length(t));
y4 = step(u, t, ss_g4);
scf();
plot(t, y4, 'm'); 
title('Step Response');
xlabel('Time [s]');
ylabel('y4');


mprintf("Transfer Function: \n");
disp(g4);  
mprintf("\nState-Space Representation: \n");
disp(ss_g4);  
mprintf("\nPoles of the System: \n");
disp(roots(g4(3)));   
mprintf("\nFinal Value of the Step Response: \n");
disp(y4($));    
mprintf("\nFull Step Response Output: \n");
disp(y4);    
*/

//-----------------------------------------------------------------------------------------------------------//
