function tstar = cuadratura_tiempo(theta,theta0,omega0_sq,N,n_gauss)
% Evalua la integral regularizada entre theta y theta0.

if theta >= theta0
    tstar = 0;
    return
end

[xg,wg] = gauss_legendre(n_gauss);
U = sqrt(theta0-theta);
u = linspace(0,U,N+1);
tstar = 0;

for i = 1:N
    M = (u(i+1)-u(i))/2;
    P = (u(i+1)+u(i))/2;
    ug = M*xg+P;

    % Forma estable de sin(theta0)-sin(theta0-ug^2).
    % Usamos la identidad:
    % sin(theta0)-sin(theta0-ug^2) =
    % 2*cos(theta0-ug^2/2)*sin(ug^2/2)
    % para evitar restar dos valores casi iguales.
    dseno = 2*cos(theta0-ug.^2/2).*sin(ug.^2/2);
    Phi = 2*ug./sqrt(2*omega0_sq*dseno);
    tstar = tstar+M*sum(wg.*Phi);
end
end
