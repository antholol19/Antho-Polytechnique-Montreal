function [nN,nodes,connect,nB,bEls,bPts]=mesh(xMin,xMax,nEls)
%inputs domain boundary points, # of elements; outputs # of nodes,
%their coordinates, connectivity matrix, # of boundary points

nN=nEls+1;  %# of nodes
nodes=(xMin: (xMax-xMin)/nEls: xMax); %coordinates of element edges
connect=zeros(nEls,4);  %init connectivity matrix

%matrice de connectivité d'hermite 
for j=1:nEls
    if j==1
        connect(j,1)=1;
        connect(j,2)=2;
        connect(j,3)=3;
        connect(j,4)=4;
    else
        connect(j,1)=connect(j-1,2);
        connect(j,2)=connect(j-1,4)+1;
        connect(j,3)=connect(j-1,4);
        connect(j,4)=connect(j,2)+1;
    end
end

%boundary conditions
nB=2;               %# of boundary elements
bEls=zeros(2,1);    %boundary elements
bEls(1)=1;
bEls(2)=nEls;
bPts=zeros(2,1);  %boundary point nodes
bPts(1)=1;
bPts(2)=2;
end