function [t,theta] = curva_referencia(theta0,omega0_sq,N,n_gauss)
% Construye la curva parametrica de referencia.

[xg,wg] = gauss_legendre(n_gauss);
u = linspace(0,sqrt(theta0),N+1);
t = zeros(1,N+1);
theta = theta0-u.^2;

for i = 1:N
    M = (u(i+1)-u(i))/2;
    P = (u(i+1)+u(i))/2;
    ug = M*xg+P;
    dseno = 2*cos(theta0-ug.^2/2).*sin(ug.^2/2);
    Phi = 2*ug./sqrt(2*omega0_sq*dseno);
    t(i+1) = t(i)+M*sum(wg.*Phi);
end

theta(end) = 0;
end
