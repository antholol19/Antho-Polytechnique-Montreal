function [elDof,dFreedom]=dof(nEls,pDeg,connect)
%output the element number of dof's and their matrix
elDof=pDeg+1;
dFreedom=connect;
% m=max(max(connect));
% for ne=1:nEls
%     for i=3:elDof(ne)
%         m=m+1;
%         dFreedom(ne,i)=m;
%     end
% end
