% Simulation d'une croissance épitaxiale de Perovskite
% PHS3903
% Auteurs : 
%   Anthony Martin (1896355), 
%   Dominik Proulx (1923164), 
%   Laurianne Borsonni (9999999)
% filename : Monte_carlo_simulation
% Last modified : 9-4-2021 (D-M-Y) 
clc;clear all;close all;
kb  = 1.38E-23; % boltzmann
e0 = 8.854E-12; % permittivité du vide

% Paramètres du substrat 
%disp('Veuillez saisir des valeurs entières comme paramètres :')
% S = input('nombre de couches uniforme du substrat [min > 5] : '); 
% L = input('largeur du substrat : ');
% T = input('Température du substrat [°K] : ');
a0 = 564E-12;%390E-12; % parametre maille du perovskite [m]
er = 5.9; % constante dielectrique du perovskite (SrTiO3)
Xi = 1/(a0*e0*er); % constante de "scaling"

%Débug values :
S = 4; L = 16; %taille simulation
%T = 1000; kbT = kb*T; %Temperature
deltaT = 800:100:1200; deltakbT = kb*deltaT;

%delta = 1.2; % potentiel chimique
deltamu = 0.2:0.2:2;

type_arret = 2; %arret a hauteur moyenne
cdn_stop = 30; %hauteur moyenne désirée
H = 100; %calcul sommation ewald



m = S*ones(L); %Matrice du cristal

% Sélection et limitres du critère d'arrêt :
%type_arret = input('0 = nb itérations, 1 = hauteur absolue, 2 = hauteur moyenne :');

% if type_arret == 0
%     cdn_stop = input('nombre de d''itérations MC désirées: ');
%     %Attention ! il est difficile d'estimer la hauteur maximale requise
%     %pour le calcul de l'énergie. 500 steps ~ 500 couches moyennes
%     H = cdn_stop*2;
%     
% elseif type_arret == 1
%     disp('La hauteur absolue est additionnée à la hauteur du substrat')
%     cdn_stop = input('Hauteur absolue :');
%     %cette méthode est celle qui calcule la matrice d'énergie le plus
%     %efficacement
%     H = cdn_stop;
%     
% elseif type_arret == 2 
%     disp('La hauteur moyenne est additionnée à la hauteur du substrat')
%     cdn_stop = input('hauteur moyenne désirée :');
%     %cette méthode est la plus pratique pour simuler un phénomène physique
%     %réel. Elle nécessite par contre une marge de "safety" pour le calcul
%     %de la matrice des energies
%     H = cdn_stop*2;
%     
% else
%     disp('erreur lors de la saisie des critères d"arrêts')
%     return
% end

% Paramètres pour l'estimation du temps réel de croissance (EXPÉRIMENTAL)
% t = 0; 
% dt = 1; %[S], à chaque itération monte-carlo le compteur T augmentera de dt


% Calcul de l'énergie
% L = largeur substrat, H = hauteur + safety selon critère d'arrêt.
E = ewald2D(L,H); 

% Ordonnement des charges
Q = charge_qB(L,H); %selon le NaCl

% Calcul du taux d'adsorption (fixe)
% T° et différence potentiel chimique fixé pour la durée de la simulation
%w_a = adsorption(kbT, delta, Xi);

% Monte-Carlo

tic
step = 0; %initialisation
stop = 0; % flag
real_time = 0; %temps réel
%Nadatome = 0; %quantité d'adatomes qui se sont collés sur la surface

for k = 1:length(deltakbT)
    kbT = deltakbT(k);
    for j = 1:length(deltamu)
        
        m = S*ones(L); %Matrice du cristal
        stop = 0; % flag
        step = 0;
        real_time = 0; %temps réel
        %Nadatome = 0; %quantité d'adatomes qui se sont collés sur la surface
        %delta = deltamu(j);
        w_a = 0;
        w_a = adsorption(kbT, deltamu(j), Xi);
        while stop == 0

            %Calcul des taux variable :
            w_e = taux_evap(L,E,m,Q,kbT,Xi); %évaporation (matrice 2x2)
            w_e_max = max(max(w_e)); %évaporation max (scalaire, varie chaque itération)
            W = w_a + w_e_max; %Taux de normalisation

            %Calcul des probabilités de chaque événement Monte-Carlo :
            P_a = w_a/W; %probabilité d'adsorption

            %P_n = 1-P_a-P_e; %probabilité qu'il ne se passe rien (nothing)

            % La magie de monte-carlo se déroule ici :

            for i = 1:numel(m)
                P_e = w_e(i)/W; %probabilité d'évaporation
                x = rand;     
                if x>=0 && x<=P_a
                    m(i) = m(i)+1;
                    %Nadatome = Nadatome+1;
                elseif x>P_a && x<=(P_a + P_e)
                    m(i) = m(i)-1;
                    %Nadatome = Nadatome-1;
                end 
            end

            %real_time(step+1) = -log(rand)/W;

            % Critère d'arrêt
            if type_arret == 0 %nombre étapes MCC
                if step >= cdn_stop
                    stop = 1;
                end

            elseif type_arret == 1 %hauteur absolue
                max_abs = max(max(m))+S;
                if max_abs >= cdn_stop
                    stop = 1;
                end

            elseif type_arret == 2 %hauteur moyenne
                max_avg = mean(m,'all')+S;
                if max_avg >= cdn_stop
                    stop = 1;
                end

            end

            step = step+1;

            rug = std(m,0,'all');




            %animation
        
            figure(3)
            h = bar3(m);
            colormap(bone);     
            for i1 = 1:size(m,2)
                cdata = get(h(i1),'cdata');
                k1 = 1;
                for j1 = 0:6:(6*size(m,1)-6)
                    cdata(j1+1:j1+6,:) = m(k1,i1);
                    k1 = k1+1;
                end
                set(h(i1),'cdata',cdata);
            end
            axis equal
            title(['Delta mu = ',num2str(deltamu(j)),' Temp = ', num2str(deltaT(k))])
            text(0,L+2,0,sprintf(' Hauteur moyenne = %.2f \n Rugositée = %.2f'...
                ,max_avg, rug))
            set(gca,'XTick',[])

        end
        gamma(k,j) = sum(m,'all')/step;
        %gamma = Ng./(w_a(j)*sum(real_time));
        
    end
    
    %Figure taux de croissance GAMMA
    figure(1)
    plot(deltamu,gamma(k,:))
    hold on
    
    undofit
    fit = ezfit(deltamu,gamma(k,:),'exp');
    makevarfit(fit);
    f = a*exp(b*deltamu);
    
    %Figure taux de croissance avec fit exponentiel
    figure(2)
    plot(deltamu, f);
    hold on
end

figure(1)
xlabel('\Delta\mu')
ylabel('\Gamma')
legend('800 °K','900 °K','1000 °K','1100 °K','1200 °K','Location','northwest')
grid on

figure(2)
xlabel('\Delta\mu')
ylabel('fit exponentiel du \Gamma')
legend('800 °K','900 °K','1000 °K','1100 °K','1200 °K','Location','northwest')
grid on

toc    