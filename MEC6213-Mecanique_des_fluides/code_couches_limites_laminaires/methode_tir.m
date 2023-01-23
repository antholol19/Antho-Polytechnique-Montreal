function [f] = methode_tir(a,b,n,h,beta,Pr,Ec,X0,num)
%Fonction: Application de la méthode de tir

%Entrées:
%a:      Intervalle initial
%b:      Intervalle final
%n:      eta maximal à intégrer
%h:      Pas 
%Xn:     Vecteur contenant les conditions initiales
%beta:   constante beta
%Pr:     Nombre de Prandtl
%Ec:     Nombre d'Eckert
%num     #EDO dépendamment de la question

%Sortie:
%f:      Condition initiale trouvée

f=0;
tol = 10^(-9); %Précision voulu pour sortir de la boucle while
nmax =50;     %Condition de sortie de la boucle while
i=0; 
e = abs(a-b);  %Calcul de la précision
while (e>tol) || (i>nmax)
   
    %Calcul de g pour alpha
    Xn = X0;             
    Xa = RK2(h,n,Xn,beta,Pr,Ec,num);  %vecteur d'équation f(n) (à eta max)
    fa = edo(Xa,beta,Pr,Ec,num);      %vecteur d'équation f'(n) (à eta max)
    if num==1
       ga = fa(1)-1;           %g(a) où on va chercher f'0 = f1 (à eta max\infini)
    else
       ga=Xa(4);
    end
    
    %calcul de g pour x (même chose, mais pour x)
    x = a+(b-a)/2;          %Point milieu
    X02 = X0;               %Condition initiale
    X02(end) = x;           %applique x à la condition initiale        
    Xn2 = X02;
    Xx = RK2(h,n,Xn2,beta,Pr,Ec,num);
    fx = edo(Xx,beta,Pr,Ec,num);      %vecteur d'équation f'(n) (à eta max)
    if num==1
       gx = fx(1)-1;        %g(x)
    else
       gx=Xx(4);
    end
    
    %On vérifie si g(a) et g(x) on le même signe (pour faire la bissection)
    if (ga>=0 && gx>=0) || (ga<0 && gx<0)
        a = x; %a devient le nouveau x
        f = a; %fonction 
    else
        b = x; % b devient le nouveau x
    end
    e = abs(a-b);
    i=i+1; %Nombre d'itération
end