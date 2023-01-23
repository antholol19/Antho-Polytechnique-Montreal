function[we] = taux_evap(L,V_pot,map,Q,kbT,Xi)
%% Définition des variables:
%--------------- Entrées -----------------------------------------
% L:            Longueur et largeur du plan du cristal. (quantité d'ions)
% V_pot:        Matrice 3D des potentiels selon chaque site occupé.
% map:          Matrice 2D des sites occupés où chaque valeur représente le
%               nombre de particules selon z.
% Q:            Matrice 3D de distribution des charges dans le cristal.
% kbT:          Température*boltmann.
% Xi:           Constante de "scaling".

%---------------- Sorties ----------------------------------------
% we:        Matrice 2D des taux d'évaporation selon chaque site occupé
%            SUR LA SURFACE.

%-----------------Notes-------------------------------------------
%Note 1: qB=+1 ou -1 pour le NaCl.
%Note 2: Lorsque toute la surface est uniforme (pas de 'tour'), on devrait
%        obtenir le même taux d'évaporation pour chaque site.
%Note 3: Condition frontière périodique en x,y et libre en z.
%Note 4: Lorsque la distance dans la direction de la largeur L entre la 
%        particule d'origine (x,y,z) et la particule d'un site 
%        occupé (i,j,k) est >L/2 (Chevauche les PBC), une nouvelle 
%        position (x2,y2,z2) est calculé pour respecter ces PBC.
%% Paramètres de vérification
% clc; clear all;
% L=20;
% H=10;
% kbT = 1000;
% % map = randi(H,[L,L]);
% map=10*ones(L);
% kb  = 1.38E-23;
% T = 1000; %[°K]; 
% kbT = kb*T;
% e0 = 8.854E-12;
% a = 282E-12;%390E-12; % parametre maille du perovskite [m]
% er = 10; % constante dielectrique du perovskite (SrTiO3)
% Xi = 1/(a*e0*er); % constante de "scaling"
% V_pot=ewald2D(L,H); %Potentiel de tous les sites possibles du cristal
% Q = charge_qB(L,H);
%% Initialisation du paramètre de sortie (Taux d'évaporation)
%Initialisation des matrices 3x3
% E = zeros(L,L,H); %matrice énergie de dissociation
we = zeros(L,L);     %matrice taux évaporation

%% Calcul de l'énergie de dissociation entre site surfacique et sites occupés
for p = 1:L*L
    %Position du site d'origine (en surface)
    [x,y] = ind2sub(size(map),p);
    z = map(x,y);
    
    %Charge du site o (origine)
    qBo = Q(x,y,z);
 
    E_evap = 0;
    %Position d'un site surfacique occupé
    for i=1:L           %Position x de la particule 
        for j=1:L       %Position y de la particule 
            for k=1:map(i,j) %Position z de la particule

                %Charge du site l
                qBl = Q(i,j,k); 

                %Application des PBC si la distance entre le site d'origine et le
                %site occupé dépasse L/2
                if abs(x-i)>L/2 %Application PBC
                  if x>L/2
                      x2 = abs(L-x+i);                  
                  else
                      x2 = abs(L-i+x);
                  end
                else 
                    x2 = abs(x-i);
                end

                if abs(y-j)>L/2 %Application PBC
                    if y>L/2 
                       y2 = abs(L-y+j); 
                    else
                       y2 = abs(L-j+y);
                    end
                else
                    y2 = abs(y-j);
                end
                z2 = abs(z-k); %pas de PBC selon z

                if x2~=0 || y2~=0 || z2~=0 %pour obtenir des paires de potentiel
                    %Énergie de dissociation (évaporation)
                    E_evap = E_evap - qBo*qBl*V_pot(x2+1,y2+1,z2+1);
    %               E(x,y,z) = E_evap; %pour verifier l'énergie du site
    %                                   d'origine
                end
            end
        end           
    end 
    %Calcul du taux d'évaporation
    we(x,y) = exp(-E_evap/(kbT*Xi));        
end
% disp(we);
