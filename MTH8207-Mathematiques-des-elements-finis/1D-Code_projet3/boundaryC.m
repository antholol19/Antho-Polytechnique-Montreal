function [K,F]=boundaryC(nB,bEls,bPts,bType,connect,K,F)

m=max(max(connect));
Kbc=K;
Fbc=F;
g=1;

%set dirichlet boundary values
u0(:,1)=zeros(m,1);  
u0(:,2)=zeros(m,1); %set different boundary points to different 
u0(1,1) = 0;
u0(3,2) = 0; %condition de dirichlet u'=0 (s'applique a la 3e fonction de base globale)

%set Neumann boundary values
gamma=zeros(nB,1);
alpha=ones(nB,1);
k=1;
g=1;
%set Robin boundary values      ROBIN NOT FULLY IMPLEMENTED YET
%betaR=1;
%gammaR=1;

for nb=1:nB
    be=bEls(nb); %boundary element
    bp=bPts(nb); %boundary point
    bt=bType(nb);
    c=connect(be,bp);

    if bt==1            %Dirichlet
        if nb==1
            Fbc=Fbc-K*u0(:,nb);
            Fbc(1)=u0(1,nb);
            Kbc(1,:)=0;
            %Kbc(:,c)=0;
            Kbc(1,1)=1;
        else
            Fbc=Fbc-K*u0(:,nb);
            Fbc(3)=u0(3,nb);
            Kbc(3,:)=0;
            %Kbc(:,3)=0;
            Kbc(3,3)=1;
        end
        
    end
    
    if bt==2            %Neumann
        Fbc(c)=Fbc(c)-k*gamma(nb)/alpha(nb);
    end
   
   % if bt==3            %Robin
   %     Kbc(c,c)=Kbc(c,c)+betaR;
   %     Fbc(c)=Fbc(c)+gammaR;
   % end  
end
Fbc(c)=Fbc(c)+g; %ajout de gv(L)   
K=Kbc;
F=Fbc;
