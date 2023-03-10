function[ans]=erfcc(x)
%Retourne la fonction erreur complémentaire erfc
%avec une erreur de moins de 1.2x10^-7 partout.

%Code tiré de NumericalRecipeC

z=abs(x);
t=1/(1+0.5*z);
ans=t*exp(-z*z-1.26551223+t*(1.00002368+t*(0.37409196+t*(0.09678418+...
t*(-0.18628806+t*(0.27886807+t*(-1.13520398+t*(1.48851587+...
t*(-0.82215223+t*0.17087277)))))))));

if (ans < 0)
    ans = 2 - ans;
end