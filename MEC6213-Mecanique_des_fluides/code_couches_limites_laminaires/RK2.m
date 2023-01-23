function[X,Xvec] = RK2(h,n,Xn,beta,Pr,Ec,num)
% Fonction de Runge-Kutta d'ordre 2 (utilisant la fonction edo)
%Entrées:
%h:      Pas 
%n:      eta maximal à intégrer
%Xn:     Vecteur contenant les conditions initiales
%beta:   constante beta
%Pr:     Nombre de Prandtl
%Ec:     Nombre d'Eckert
%num     #EDO dépendamment de la question

%Sorties
%X:      Vecteur solution
%Xvec:   Tous les échantillons du vecteur solution

npas = n/h; %nombre de pas
for i=1:npas
    k1 = h*edo(Xn,beta,Pr,Ec,num);       %k1 = hF(n,fn) où Xn est X0 initialement
    y = Xn + k1;                         %y = f(n) + hk1
    k2 = h*edo(y,beta,Pr,Ec,num);        %k2 = F(n+h,f(n)+hk1)
    Xn = Xn + 1/2*(k1+k2);               %f(n+1) = f(n) + 1/2(k1+k2)
    Xvec(:,i)=Xn;                        %vecteur avec toutes les données
end
X = Xn;