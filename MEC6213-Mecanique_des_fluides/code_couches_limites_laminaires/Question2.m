%% Devoir Couche limite
%% Anthony Martin, 1896355
%% Question 2: Couche limite thermique
clc; clear all; close all;
%Paramètres de l'écoulement
rho = 1.2;           %Masse volumique
mu = 1.8*10^(-5);    %Viscosité dynamique
nu = 1.5*10^(-5);    %Viscosité cinématique
k = 0.0262;          %Diffusivité thermique
c = 1005;            %Capacité thermique massique
U = 2;               %vitesse de l'écoulement
Te = 20+273.15; %température écoulement (Kelvin)
Tw = 80+273.15; %température sur la paroi (Kelvin)
beta = 0;
Pr = 0;
Ec = 0;
h = 0.001;  %pas
n = 10;     %eta max à intégrer

%Calcul de f''(0) (comme la question 1.2)
a = 0;      %Valeur initiale pour l'intervalle bissection
b = 2;      %valeur finale pour l'intervalle bissection
alpha=a;    %Valeur arbitraire pour la condition initiale f2''(0)

%Retrouver f''
num=1;
X0 =[0,0,alpha]; 
f20 = methode_tir(a,b,n,h,beta,Pr,Ec,X0,num);

Pair = mu*c/k; %Nombre de Prandtl pour l'air
Pr = [Pair,0.01,1,10,100]; %Vecteur contenant les Pr de l'énoncé
num=2; %2e edo à utiliser

%4. Calculer la condition initiale theta'(0) ne changeant pas f''(0) 
for i = 1:length(Pr) %Parcourir le vecteur Pr
    %Calcul de theta'(0) 
    a = -3;     %Valeur initiale pour l'intervalle bissection
    b = 2;      %valeur finale pour l'intervalle bissection
    gamma=a;    %Valeur arbitraire pour la condition initiale theta''(0)  
    X0 =[0,0,f20,1,gamma]; 
    [dtheta0] = methode_tir(a,b,n,h,beta,Pr(i),Ec,X0,num);
    dtheta_vec(i) = dtheta0; %thetha'(0) pour chaque Pr
    fprintf('Pr = %.4f et theta''(0) = %.8f \n',Pr(i),dtheta0)
end

%5. Représentation graphique de f'(n) et theta(n)
for i = 1:5 %parcourir le vecteur Pr
    figure()
    n=10; %eta max
    if i<3
        n=50; %eta max plus grande pour petit Pr
    end
    X0 =[0,0,f20,1,dtheta_vec(i)]; %Conditions initiales
    Xn = X0;         
    [X,Xvec] = RK2(h,n,Xn,beta,Pr(i),Ec,num);
%     [X,Xvec] = RK2(h,n,Xn,Pr(i));      
    eta = linspace(0,n,n/h); 
    f1 = Xvec(2,:);     %f'(n)
    theta0 = Xvec(4,:); %theta(n)
    plot(eta,f1,'DisplayName',['f''(\eta))'])
    hold on 
    plot(eta,theta0,'DisplayName',['\theta(\eta))'])
    title(['f''(\eta) et \theta(\eta) pour Pr = ',num2str(Pr(i))])
    xlabel(['\eta'])
    legend show
end
%Commenter brièvement: (voir rapport)

%6. 
%theta<=0.01 et f1>=0.99 
%On trouve la position de eta pour lequel f1>=0.99 et ensuite on trouve
%avec la position de eta trouvé ce que vaut theta. 
%On trouve ensuite l'exposant en faisant un rapport de n. 
for i=1:length(Pr)
    X0 =[0,0,f20,1,dtheta_vec(i)]; %Conditions initiales
    Xn = X0;         
    [X,Xvec] = RK2(h,n,Xn,beta,Pr(i),Ec,num);
    f1 = Xvec(2,:);
    theta0 = Xvec(4,:);
    pos_f1 = find(f1>=0.99);         %indices pour lequel f1>=0.99
    pos_theta = find(theta0<=0.01);  %indices pour lequel theta<=0.01
    expo(i) = log(eta(pos_f1(1))/eta(pos_theta(1)))/log(Pr(i)); %exposant  
end

%9. Nouvelle edo Pr ~1 et Ec ~<< 1 
%pour être du même ordre de grandeur, il faut que l'énergie d'Eckert soit autour de 1

Ec2 = 2;    %Ec du nouvel écoulement
Pr2 = 10;   %Pr du nouvel écoulement

%Calcul de theta'(0) pour la nouvelle EDO (question 8) et nouvel écoulement
a = -1;     %Valeur initiale pour l'intervalle bissection
b = 3;      %valeur finale pour l'intervalle bissection
gamma=a;    %Valeur arbitraire pour la condition initiale theta''(0)
n=10;
num = 3;    %3e EDO

X0 =[0,0,f20,1,gamma];
dtheta02 = methode_tir(a,b,n,h,beta,Pr2,Ec2,X0,num);
fprintf('Pr = %.4f et theta''(0) = %.8f \n',Pr2,dtheta02)

%Graphiques qui compare avec pair (négligeable) et pr (non négligeable) 
figure()
n=10;

X0 =[0,0,f20,1,dtheta_vec(1)]; %Conditions initiales
Xn = X0; 
[X,Xvec] = RK2(h,n,Xn,beta,Pair,Ec,2); %Système d'équation de l'écoulement air
X0 =[0,0,f20,1,dtheta02]; %Conditions initiales for the new EDO
Xn = X0;  
[X2,Xvec2] = RK2(h,n,Xn,beta,Pr2,Ec2,3); %Système d'équation nouvel écoulement 
eta = linspace(0,n,n/h); 
f1 = Xvec(2,:);       %Vitesse adimensionnelle pour air
theta0 = Xvec(4,:);   %Température adimensionnelle pour air
theta02 = Xvec2(4,:); %T adimensionnelle le nouveau
plot(eta,f1,'DisplayName',['f''(\eta)_{air}'])
hold on 
plot(eta,theta0,'DisplayName',['\theta(\eta)_{air}'])
plot(eta,theta02,'DisplayName',['\theta(\eta)_{new}'])
title(['f''(\eta) et \theta(\eta) pour Pr = ',num2str(Pair),' (air) vs \theta(\eta) pour Pr = ',num2str(Pr2),' (new)'])
xlabel(['\eta'])
legend show
% Commenter brièvement (voir rapport)
%%
%10. On garde les paramètres 
%On fait varier le nombre de reynold et on le change jusqu'à qw(x)<=0.01
val = 1.93*10^-6; %val = U*Rex^(-1/2)
q = rho*c*(Tw-Te)*0.332*Pr2^(-2/3)*val; %Flux de chaleur

% delta = 319;
% q=k*(Tw-Te)*dtheta02/delta;
% const = 2*nu/delta^2;
