function [f] = edo(X,beta,Pr,Ec,num)
% Fonction pour trouver les valeurs des dérivées du système d'équation

%Entrées:
%X:      Vecteur f(n)
%beta:   constante beta
%Pr:     Nombre de Prandtl
%Ec:     Nombre d'Eckert
%num     #EDO dépendamment de la question

%Sortie:
%f: vecteur f'(n)

if num==1
    % Formulation du système d'équation 
    f(1) = X(2);        %f0' = f1
    f(2) = X(3);        %f1' = f2
    f(3) = -X(1)*X(3) - beta*(1-(X(2))^2);  %f2' = -f0f2 - beta(1-f1^2)
elseif num==2
    % Formulation du système d'équation
    f(1) = X(2);          %f0' = f1
    f(2) = X(3);          %f1' = f2
    f(3) = -X(1)*X(3);    %f2' = -f0f2
    f(4) = X(5);          %theta0' = theta1 =  car 
    f(5) = -Pr*X(1)*X(5); %theta1' = -Pr*f0*theta1
elseif num==3
    % Formulation du système d'équation 
    f(1) = X(2);          %f0' = f1
    f(2) = X(3);          %f1' = f2
    f(3) = -X(1)*X(3);    %f2' = -f0f2
    f(4) = X(5);          %theta0' = theta1
    f(5) = -Ec*Pr*(X(3))^2-Pr*X(1)*X(5); %theta1' = -Pr*f0*theta1
end
end