function [t,theta,omega] = euler_barra(theta0,omega0_sq,h)
% Metodo de Euler hasta el impacto.

t = 0;
theta = theta0;
omega = 0;

while theta(end) > 0
    theta_n = theta(end);
    omega_n = omega(end);

    theta_np1 = theta_n+h*omega_n;
    omega_np1 = omega_n-h*omega0_sq*cos(theta_n);

    if theta_np1 <= 0
        alfa = theta_n/(theta_n-theta_np1);
        t(end+1) = t(end)+alfa*h;
        theta(end+1) = 0;
        omega(end+1) = omega_n+alfa*(omega_np1-omega_n);
    else
        t(end+1) = t(end)+h;
        theta(end+1) = theta_np1;
        omega(end+1) = omega_np1;
    end
end
end
