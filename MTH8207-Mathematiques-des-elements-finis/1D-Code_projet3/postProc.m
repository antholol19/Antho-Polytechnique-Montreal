function postProc(nEls,nodes,connect,u)
%plot the solution u and its derivative
n=1;
for ne=1:nEls
    for i=1:4
        c=connect(ne,i);
        uL(ne,i)=u(c);
    end
end
for ne=1:nEls
    nx=10;
    u=zeros(nx,1);
    d2u=zeros(nx,1);
    x1=nodes(n);
    x2=nodes(n+1);
    n=n+1;
    h=x2-x1;
    jac=2/h;
    x=(x1:(x2-x1)/(nx-1):x2);
    xi=(-1:2/(nx-1):1);
    for j=1:nx
        [N,d2N]=shape(xi(j));
        d2N=d2N*jac^2;
        for i=1:4
            u(j)=u(j)+N(i)*uL(ne,i);
            d2u(j)=d2u(j)+d2N(i)*uL(ne,i);
        end
    end
%     subplot(1,2,1)
    hold on
    axis square
    plot(x,u)
%     subplot(1,2,2)
    hold on
%     axis square
%     plot(x,d2u);
%     plot(x,(-1/6)*x.^3+(1/2)*x.^2) %question 4
%    plot(x,(-1/4)*x.^3+(2/3)*x.^2+(1/120)*x.^5) %question 5
end