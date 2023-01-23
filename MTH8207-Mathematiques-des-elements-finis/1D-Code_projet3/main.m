%Auteurs: Anthony Martin (1896355) et Emmanuelle Vigneux-Foley (1908887)

clc; clear all
close all
%*******************main code for the 1D finite element solver*************

%paramètres
xMin=0;
xMax=1;
EI=1;

i=1;
seminormH2_k=[];
b_semiH2=[];
normL2_k=[];
b_L2=[];

%**************************build mesh**************************************
for k=1:7
    
nEls=2^k;

[nN,nodes,connect,nB,bEls,bPts]=mesh(xMin,xMax,nEls);

%*****************build element matrices k and vectors f*******************

%get quadrature points and weights
[xiQ,wQ]=gQuad;

%build k and f for each element; sum to find K and F
%set k,f:
syms x
k=@(x)EI;
% f=@(x)0;  %question 4
f=@(x)x; %question 5

[K,F]=element(nEls,nodes,xiQ,wQ,connect,k,f);

%*****************add boundary conditions and solve************************

%set boundary condition type (set values within boundaryC.m)
bType=zeros(2,1);   %boundary condition types; use 1 for Dirichlet,
bType(1)=1;         %2 for Neumann, 3 for Robin
bType(2)=1;

[K,F]=boundaryC(nB,bEls,bPts,bType,connect,K,F);
u=K\F;

%**************Convergence*************************************************
[norm_L2,seminorm_H2]=norms(nEls,nodes,connect,xiQ,wQ,u);

seminormH2_k(i)=seminorm_H2; %matrice de seminorme H2
normL2_k(i)=norm_L2;

if i>1
    b_L2(i-1)=log(normL2_k(i-1)/normL2_k(i))/log(2); %norme L2
    b_semiH2(i-1)=log(seminormH2_k(i-1)/seminormH2_k(i))/log(2); %seminorme H2
end

N(i)=nEls;
i=i+1;
end
%Graphique de la seminorme H2
figure()
loglog(N,seminormH2_k)
xlabel('log(1/h)')
ylabel('log(Semi-norme H2)')
title('Seminorme H2 par rapport au nombre d''éléments')
grid on

%**************post-processing*********************************************
%plot the solution u and its derivative
figure()
postProc(nEls,nodes,connect,u);
xlabel('x')
ylabel('déflexion approcximée')
title(['Déflexion de la poutre par unité de longueur discrétisée par les éléments finis avec ',...
    num2str(nEls),' éléments'])
grid on
fprintf('Le taux de convergence de la seminorme H2 avec %d éléments est: %.4f \n',...
    nEls,b_semiH2(end));
c=log(seminormH2_k);

%set up les graphiques
set(groot,...
    'defaultLineMarkersize',3,...
    'defaultAxesFontSize',14,...
    'defaultAxesLabelFontSizeMultiplier',1.14,...
    'defaultAxesTickLabelInterpreter','latex',...
    'defaultLegendInterpreter','latex',...
    'defaultLegendFontSize',11,...
    'defaultLegendFontWeight','bold',...
    'defaultTextInterpreter','latex',...
    'defaultFigureUnits','inches',...
    'defaultFigurePosition',[1 0 10 7],...
    'defaultLineLineWidth',1,...
    'DefaultAxesBox','on');
