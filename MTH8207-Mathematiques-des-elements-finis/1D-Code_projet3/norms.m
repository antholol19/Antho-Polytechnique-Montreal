function [norm_L2,seminorm_H2]=norms(nEls,nodes,connect,xiQ,wQ,u)
%Calculate the L2 and H1 norms of the error e = u_exact - uh
n=1;
norm_L2=0; 
seminorm_H2=0;

for ne=1:nEls
    x1=nodes(n);
    x2=nodes(n+1);
    n=n+1;
    h=x2-x1;
    jac=h/2;
    nQ=4; %number of Gauss points
    for l=1:nQ
        xi=xiQ(l,nQ);
        wq=wQ(l,nQ);
        [N,d2N]=shape(xi);
        d2N=d2N/jac^2;
        xq=h/2*xi+(x1+x2)/2; %global coordinate of Gauss point xi

        % Finite element solution evaluated at Gauss point
        uh=0;
        duh=0;
        d2uh=0;
        for i=1:4
            c=connect(ne,i);
            uh=uh+N(i)*u(c);
            d2uh=d2uh+d2N(i)*u(c);
        end
        % Exact solution evaluated at Gauss point
        %Question 4
%         u_exact=(-1/6)*xq.^3+(1/2)*xq.^2;
%         d2u_exact = -xq+1;
        
        %Question 5
        u_exact=(-1/4)*xq^3+(2/3)*xq^2+(1/120)*xq^5;
        d2u_exact=(-3/2)*xq+(4/3)+(1/6)*xq^3;
        

        %Erreur norme L2,H1 et seminorme H2
        norm_L2 = norm_L2 + wq*(u_exact-uh)^2*jac;
        seminorm_H2 = seminorm_H2 + wq*(d2u_exact-d2uh)^2*jac; 
    end
end
norm_L2=sqrt(norm_L2);
seminorm_H2=sqrt(seminorm_H2);
