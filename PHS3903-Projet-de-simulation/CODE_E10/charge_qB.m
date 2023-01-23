function[Q] = charge_qB(L,H)
%% D�finition des variables:
%--------------- Entr�es -----------------------------------------
% L:            Longueur et largeur du plan du cristal (quantit� d'ions)
% H:        	Hauteur du cristal (quantit� d'ions)
%---------------- Sorties ----------------------------------------
% Q:            Matrice 3D de distribution des charges dans le cristal.
%% Param�tres pour v�rifier le fonctionnement
% clc;clear all;
% L=8;
% H=8;
%% Ordonnement des charges en alternance +1 ou -1 pour le NaCl
Q = ones(L,L,H);
for k = 1:H
    for j = 1:L
        for i = 1:L
            if mod(k,2)==1
                 if (mod(i,2) == 1 && mod(j,2) == 1) ||...
                        (mod(i,2) == 0 && mod(j,2) == 0)
                      Q(i,j,k) = 1;
                 else
                      Q(i,j,k) = -1;
                 end  
            else
                 if (mod(i,2) == 1 && mod(j,2) == 1) ||...
                        (mod(i,2) == 0 && mod(j,2) == 0)
                    Q(i,j,k) = -1;
                 else
                    Q(i,j,k) = 1;
                 end          
            end
        end
    end
end
% disp(sum(sum(sum(Q)))) % V�rification de la neutralit� de charge