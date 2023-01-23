function [N,d2N]=shape(xi)
%calculates the values of shape functions N and their derivatives
%dN/d(xi) at specified values of xi

 %hermite (only one form)
N(1)=(1/4)*(2-3*xi+xi^3);
N(2)=(1/4)*(2+3*xi-xi^3);
N(3)=(1/4)*(1-xi-xi^2+xi^3);
N(4)=(1/4)*(-1-xi+xi^2+xi^3);
    
dN(1)=(1/4)*(-3+3*xi^2);
dN(2)=(1/4)*(3-3*xi^2);
dN(3)=(1/4)*(-1-2*xi+3*xi^2);
dN(4)=(1/4)*(-1+2*xi+3*xi^2);
    
d2N(1)=(1/4)*(6*xi);
d2N(2)=(1/4)*(-6*xi);
d2N(3)=(1/4)*(-2+6*xi);
d2N(4)=(1/4)*(2+6*xi);


    