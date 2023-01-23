%% Devoir Couche limite
%% Anthony Martin, 1896355
%% Question 1: Couche limite de vitesse
clc; clear all; close all;
%Paramètres de l'énoncé:
rho = 1*10^3;   %Masse volumique (kg/m^3)
mu = 1*10^(-3); %Viscosité dynamique
nu = 1*10^(-6); %Viscosité cinématique

a = 0;      %Valeur initiale pour l'intervalle bissection
b = 2;      %valeur finale pour l'intervalle bissection
alpha=a;    %Valeur arbitraire pour la condition initiale f2''(0)
h = 0.001;  %pas
n = 6;      %eta max à intégrer
beta = 0;   %beta
Pr = 0;     %Nombre de prandtl
Ec = 0;     %Nombre d'Eckert
num=1;      %EDO #1

%2. Application de la méthode de tir pour trouver f''(0)
X0 = [0,0,alpha];
f20 = methode_tir(a,b,n,h,beta,Pr,Ec,X0,num);
fprintf('La condition initiale est f2''''(0) = %.8f\n',f20);

%3. Les graphiques
X0 =[0,0,f20]; %conditions initiales
Xn = X0;
[X,Xvec] = RK2(h,n,Xn,beta,Pr,Ec,num);
eta = linspace(0,n,n/h);

%Graphique 1: f(n) = f0(n)
figure(1)
f0 = Xvec(1,:);
plot(eta,f0)
title(['f(\eta) intégré jusqu''à \eta=6'])
xlabel(['\eta'])
ylabel(['f(\eta)'])

%Graphique 2: u(n)/U = f'(n) = f1(n)
figure(2)
f1 = Xvec(2,:);
plot(eta,f1)
title(['u(\eta)/U intégré jusqu''à \eta=6'])
xlabel(['\eta'])
ylabel(['u(\eta)/U'])

%Graphique 3: v(n)/(Ud'(x)) = (nf' - f) = (nf1(n)-f0(n))
figure(3)
plot(eta,eta.*f1-f0)
title(['v(\eta)/U\delta''(x) intégré jusqu''à \eta=6'])
xlabel(['\eta'])
ylabel(['v(\eta)/U\delta''(x)'])

%Graphique 4: td(x)/muU = f''(n) = f2(n)
figure(4)
f2 = Xvec(3,:);
plot(eta,f2)
title(['\tau\delta(x)/\muU intégré jusqu''à \eta=6'])
xlabel(['\eta'])
ylabel(['T\delta(x)/\muU'])

%4. Commenter: (voir rapport)

%5. question qualitative: (voir rapport)

%6. Calculer force de trainée D
%avec y=0 donc f''(0)
U = 0.1;
D = mu*U*f20*(2*nu/U)^(-1/2)*2*(2^1/2); %Calcul de l'intégrale (résolue)
fprintf('La force de trainée est de %.8f N\n',D);

%7. instabilité
Rex = 54000; %Nombre de reynold
x = nu*Rex/U;%Calcul de la distance d'instabilité
fprintf('On a de l''instabilité lorsque x = %.8f m\n',x);

%8. Force de trainée avec coefficient de frottement
CD = 0.0316*Rex^(-1/7); %coeff. moyen de frottement
D2 = 1/2*rho*U^2*CD;    %force de trainée
fprintf(['La force de trainée calculée avec le coefficient de frottement'...
    ' est %.8f N \n'],D2);

%9. Graphique de vitesse horizontale et intégrandes
figure(5)
plot(eta,f1,'DisplayName',['u(\eta)/U'])
hold on
plot(eta,-f1+1,'DisplayName',['1-u(\eta)/U'])
plot(eta,f1.*(-f1+1),'DisplayName',['u(\eta)/U(1-u(\eta)/U)'])
title('Vitesse horizontale adimensionnelle et les intégrandes')
xlabel(['\eta'])
legend show;

%10. Calculer les intégrandes
 r1=0;
 r2=0;
 hold on
[xq,w]=lgwt(50,0,n); %points xi et poids wi intervalle [0,n]
vq1 = interp1(eta,f1,xq);
for i=1:50                      %Ajouter les points f(xi) dans f(ni) 
    r1 = r1 + w(i)*(1-vq1(i));          %delta/delta*
    r2 = r2 + w(i)*vq1(i)*(1-vq1(i));   %theta/delta
end
fprintf('delta*/delta = %.8f \n',r1);
fprintf('theta/delta = %.8f \n',r2);

%11. Trouver beta0 pour que f''(0)<=0.01
a = 0;              %Valeur initiale de l'intervalle
b=0.2;              %Valeur finale de l'intervalle
alpha = a;          %Valeur de la condition initiale f''(0)
beta0 =-0.1989;     %beta0 (imposée pour avoir f''(0)<=0.01)

X0 = [0,0,alpha];
f2b0 = methode_tir(a,b,n,h,beta0,Pr,Ec,X0,num); 
fprintf('beta0 = %.8f\n',beta0);
fprintf('f''''(0) = %.8f\n',f2b0);


%12. Graphiques
beta_vec = linspace(beta0,0.6,10); %Vecteur de 10 beta pareillement espacé
figure(6)
for nb_plot = 1:2 %Deux fonctions sur le même graphique
    f2b = f2b0; %reprend le f''(0) calculé avec beta0
    for j = 1:length(beta_vec) %génère une courbe pour chaque beta
        %Paramètres pour la bissection
        a=0;
        b=2;
        X0 = [0,0,f2b]; %réutilise le f''(0) comme paramètre initial
        f2b = methode_tir(a,b,n,h,beta_vec(j),Pr,Ec,X0,num);
        
        %Avec le f''(0) associé au beta, on calcule f(n)
        X0 =[0,0,f2b];
        Xn = X0;
        [X,Xvec] = RK2(h,n,Xn,beta_vec(j),Pr,Ec,num); %On ressort les valeurs de f(n) pour tout n
        
        %affichage de la fonction u(n)/ue(x) sur le graphique
        if nb_plot==1
            f1 = Xvec(2,:);
            plot(eta,f1,'DisplayName',strcat(['\beta = '],num2str(beta_vec(j))))       
            hold on
            lgd = legend;
            lgd.Location = 'Bestoutside';
            legend show
        else
        %affichage de la fonction t(n)d(x)/muue(x) sur le graphique
            f2 = Xvec(3,:);
            plot(eta,f2,'DisplayName',strcat(['\beta = '],num2str(beta_vec(j))))
            lgd = legend;
            lgd.Location = 'Bestoutside';
            legend show
            f2b_vec(j) = f2b;
        end
    end
end
title(['u(\eta)/u_e(x) et \tau\delta(x)/\muu_e(x) intégré jusqu''à \eta=6'])
xlabel(['\eta'])
hold off
%Commentaires: (voir rapport)

%13. graphique de f''(0) en fonction de beta
figure(7)
plot(beta_vec,f2b_vec)
title(['f''''(0) par rapport à \beta'])
xlabel(['\beta'])
ylabel('f''''(0)')

%Commentaires: (voir rapport)
