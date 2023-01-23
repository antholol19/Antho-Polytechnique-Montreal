function[V_pot]=ewald2D(L,H)
%Cette fonction trouve les �nergies potentiels possibles entre l'origine
%(0,0,0) et un site occup� (i,j,k). 
%% D�finition des variables:
%--------------- Entr�es -----------------------------------------
% L:            Longueur et largeur du plan (quantit� d'ions).
% H:            Hauteur maximale du cristal (quantit� d'ions).

%---------------- Sorties ----------------------------------------
% V_pot:        Matrice 3D des potentiels selon chaque site occup�.

%-----------------Notes-------------------------------------------
%Note 1: Le cristal est infiniment large, mais avec les conditions fronti�res
%        p�riodique, seul une bo�te contenant LxLxH sites est simul� et 
%        r�pliqu� de fa�on infinie.
%Note 2: Lorsque alpha ->0, la partie r�ciproque de la somme disparait.
%        Lorsque alpha -> Inf, la partie directe de la somme disparait.
%% Param�tres pour v�rifier le fonctionnement
% clc; clear all;
% L=8;
% H=4; 
%% Param�tres initiaux
ck = 2*pi/L;      %Constante k du vecteur d'onde
alpha=pi/(L*L);   %Param�tre arbitraire
cutoff=10^-15;    %Tronquage lorsque l'erreur < cutoff
V_pot=ones(L/2+1,L/2+1,H+1); %Initialisation de la matrice de potentiel
E=0;
%% Sommation d'Ewald dimension 2
%On cherche le potentiel entre l'origine (0,0,0) et le site (i,j,k)
for i=0:L/2             
    for j=i:L/2         
        for k=0:H  
            
%           L'erreur est tronqu� pour les contributions dans l'espace
%           direct
            max=1;
            d=0; %position de la r�plique (espace direct)     
            while abs(max)>cutoff
                d=d+1;   %Une r�plique plus loin
                x=i+d*L; %position en x du site sur l'image
                y=j+d*L; %position en y du site sur l'image
                r=sqrt(x^2+y^2+k^2);
                r2 = sqrt(2*(L*d)^2+k^2);
                max = 1/r*erfcc(sqrt(alpha)*r)-1/r2*erfcc(sqrt(alpha)*r2);
            end
            d=d-1;
            
            %L'erreur est tronqu� pour les contributions dans l'espace
            %r�ciproque
            max=1;
            f=0; %Position de la r�plique (espace fourier)
            while abs(max)>cutoff 
                f=f+1;
                kr = ck*(i*f+j*f);
                G = sqrt(2)*ck*f;
                fG1 = erfcc((2*alpha*abs(k)+G)/(2*sqrt(alpha)))*exp(G*k);
                fG2 = erfcc((2*alpha*abs(k)-G)/(2*sqrt(alpha)))*exp(-G*k);   
                max = (fG1-fG2);%*(cos(kr)-1)*pi/(L^2*G)*;
            end
            f=f-1;
            
            %Calcul de potentiel (selon les PBC)
            V=0;
            
            %V1(l'-l):
            for nx=-d:d %position de la r�plique en x
                for ny=-d:d %Position de la r�plique en y
                    x=L*nx-i;
                    y=L*ny-j;
                    r=sqrt(x^2+y^2+k^2);
                    V = V + 1/r*erfcc(sqrt(alpha)*r);
                    
                    %sum_R~=0
                    if nx~=0 && ny~=0
                        r = sqrt((L*nx)^2+(L*ny)^2+k^2);
                        V = V - 1/r*erfcc(sqrt(alpha)*r);
                    end                  
                end
            end
                      
       
            %V2(l'-l):        
            for kx = -f:f
                for ky = -f:f
                    if kx~=0 && ky~=0
                        G = sqrt(kx^2+ky^2)*ck; %norme du vecteur reciproque
                        kr = ck*(i*kx+j*ky);
                        fG1 = exp(G*k)*erfcc((2*alpha*abs(k)+G)/(2*sqrt(alpha)));
                        fG2 = exp(-G*k)*erfcc((2*alpha*abs(k)-G)/(2*sqrt(alpha))); 
                        V = V + pi/(L^2*G)*(fG1-fG2)*(cos(kr)-1);
                    end
                end
            end
            
            %Vs(l'):
            if k==0
               V = V + 2*sqrt(alpha)/sqrt(pi);
            else
               V = V +(1/k-1/k*erfcc(sqrt(alpha)*k));
            end
            
            V_pot(i+1,j+1,k+1) = V;
            V_pot(j+1,i+1,k+1) = V;
            fprintf('(%ld,%ld,%ld)\t%9.12f\n',i,j,k,V); 
        end
    end
end
%% �crire dans un fichier.txt pour enregistrer les donn�es d'�nergie.
% %Nom du fichier texte et directory
% textName = 'Energy.txt';
% 
% fileName = strcat('L=',num2str(L),'H=',num2str(H),'alpha=',num2str(alpha),textName);
% 
% %Ouverture du fichier texte
% fileID = fopen(fileName,'w');
% 
% %�crire dans le fichier texte 
% fprintf(fileID,'%s\t %s\t %s\t %s\t temps=%.5f s\n','x','y','z','Energie',t);
% fprintf(fileID,'\n');
% 
% for x=0:size(V_pot,1)-1
%     for y=0:size(V_pot,2)-1
%         for z=0:size(V_pot,3)-1
%             fprintf(fileID,'%d\t %d\t %d\t %9.12f\n',x,y,z,V_pot(x+1,y+1,z+1));          
%         end
%     end
% end
% fclose(fileID);