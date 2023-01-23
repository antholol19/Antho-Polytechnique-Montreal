function [K,F]=element(nEls,nodes,xiQ,wQ,connect,k,f)
%build element matrices k & f, then K & F
n=1;
m=max(max(connect));

K=zeros(m);
F=zeros(m,1);
for ne=1:nEls
   x1=nodes(n);
   x2=nodes(n+1);
   n=n+1;
   h=x2-x1;
   jac=h/2;
   nQ=4;  %order of gaussian quadrature
   kEl=zeros(4);
   fEl=zeros(4,1);
   for l=1:nQ
       xi=xiQ(l,nQ);
       wq=wQ(l,nQ);
       xq=(h/2)*xi+(x1+x2)/2;   %global coordinate of xi
       [N,d2N]=shape(xi);
       d2N=d2N/jac^2;
       [kQ,fQ]=evals(xq,k,f);
       for i=1:4
           fEl(i)=fEl(i)+wq*fQ*N(i)*jac;   %sum element f  
           for j=1:4
               kEl(i,j)=kEl(i,j)+wq*kQ*d2N(j)*d2N(i)*jac;
           end
       end
   end

   for i=1:4   %build global matrices K and F
       ci=connect(ne,i);
       F(ci)=F(ci)+fEl(i);
       for j=1:4
           cj=connect(ne,j);
           K(ci,cj)=K(ci,cj)+kEl(i,j);
       end
   end
end
   
   
   
   
   