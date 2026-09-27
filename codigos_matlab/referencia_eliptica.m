function tstar = referencia_eliptica(theta,theta0,omega0)
% Evalua la expresion eliptica mediante ellipke, ellipj y biseccion.

m = (1+sin(theta0))/2;
K = ellipke(m);
valor = sqrt((1+sin(theta))/(1+sin(theta0)));

a = 0;
b = K;
for j = 1:60
    u = (a+b)/2;
    sn = ellipj(u,m);
    if sn < valor
        a = u;
    else
        b = u;
    end
end

F = (a+b)/2;
tstar = (K-F)/omega0;
end
