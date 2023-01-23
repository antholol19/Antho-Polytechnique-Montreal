clear all
clc
close all

%Conditions initiales (ce qu'on peut modifier)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = 5;               %vitesse angulaire
vo = 1;              %vitesse initiale
m = 1;               %masse des 2 masse
L = 1;               %Longueur de la tige/ressort à l'équilibre
k = 10;              %cste de rappel du ressort
c = 1;               %amplitude de l'oscillation (étirement initial)
t=linspace(0,15*pi,500);
l = linspace(0,0,500);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1. Calculs et données:
%Équations différentielles
q1=vo*t - L/2*cos(t);
q2 = c*cos(sqrt(k/m)*t) + m/k + L;
q3 = q1 + q2 - L;

%position des masses 1 et 2 pour le cas tige
A = L*cos(w*t) + q1; %x
B = L*sin(w*t); %y
figure()
subplot(2,2,2)
plot3(A,B,t,'k',q1,l,t,'b')
set(gca,'Xlim',[0;35],'Ylim',[-2;2],'Zlim',[0;35]);
hold on
grid on
title('Position des masses 1 et 2 pout le cas tige');
xlabel('coordonnée en x')
ylabel('coordonnée en y')
zlabel('temps')
legend('Masse 2','Masse 1');

%position de la masse 2 pour le cas ressort/pivot
C = q2.*cos(w*t);
D = q2.*sin(w*t);
subplot(2,2,1)
plot3(C,D,t,'r')
view(-45,90)
set(gca,'Xlim',[-5;5],'Ylim',[-5;5],'Zlim',[0;35]);
hold on
grid on
title('Position de la masse 2 pour le cas pivot/ressort');
xlabel('Position en x');
ylabel('Position en y');
zlabel('Temps');
legend('Masse 2');

%position des masses pour l'approximation
E = A + C;
F = B + D;
subplot(2,2,[3,4]);
plot3(q1,l,t,E,F,t,'g')
set(gca,'Xlim',[0;35],'Ylim',[-5;5],'Zlim',[0;35]);
hold on
grid on
title('Position des masses 1 et 2 pour le mouvement chaotique approximé');
xlabel('Position en x');
ylabel('Position en y');
zlabel('Temps');
legend('Masse 1','Masse 2');

%2. simulation
%cas tige
figure()
subplot(2,2,2)
O = animatedline('color','k');
P = animatedline('color','b');
set(gca,'Xlim',[0;40],'Ylim',[-2;2],'Zlim',[0;35]);
view(-45,90)
hold on
grid on
title('Simulation masse 1 et 2 avec tige')
xlabel('position en x');
ylabel('position en y')
zlabel('temps');
legend('position de la masse 2','position de la masse 1');

%cas ressort/pivot
subplot(2,2,1)
Q = animatedline('color','r');
set(gca,'Xlim',[-5;5],'Ylim',[-5;5],'Zlim',[0;35]);
hold on
grid on
view(-45,90)
title('Simulation masse 2 pivot/ressort');
xlabel('Position en x');
ylabel('Position en y');
zlabel('Temps');
legend('position de la masse 2');

%cas approximé
subplot(2,2,[3,4])
M = animatedline('color','b');
N = animatedline('color','g');
set(gca,'Xlim',[0,40],'Ylim',[-5,5],'Zlim',[0,35]);
hold on
grid on
view (0,90)
title('Simulation des deux masses dans le cas approximé');
xlabel('Position en x');
ylabel('Position en y');
zlabel('temps');
legend('Masse 1','Masse 2');

%création de la simulation
for i=1:length(t)
    addpoints(O,A(i),B(i),t(i));
    addpoints(P,q1(i),l(i),t(i));
    addpoints(Q,C(i),D(i),t(i));
    addpoints(M,q1(i),l(i),t(i));
    addpoints(N,E(i),F(i),t(i));
    T=scatter(t(i),q1(i),'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
    drawnow
    pause(0.01);
    delete(T);
end
saveas(gcf,'Simulation.png');



