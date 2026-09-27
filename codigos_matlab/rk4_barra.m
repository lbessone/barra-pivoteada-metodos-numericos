function [t,theta,omega] = rk4_barra(theta0,omega0_sq,h)
% Metodo RK4 hasta el impacto. El cruce se localiza con Hermite y Newton.

t = 0;
theta = theta0;
omega = 0;

while theta(end) > 0
    y = [theta(end);omega(end)];

    k1 = [y(2);-omega0_sq*cos(y(1))];
    y2 = y+h*k1/2;
    k2 = [y2(2);-omega0_sq*cos(y2(1))];
    y3 = y+h*k2/2;
    k3 = [y3(2);-omega0_sq*cos(y3(1))];
    y4 = y+h*k3;
    k4 = [y4(2);-omega0_sq*cos(y4(1))];

    yn = y+h*(k1+2*k2+2*k3+k4)/6;

    if yn(1) <= 0
        th1 = y(1);    om1 = y(2);
        th2 = yn(1);   om2 = yn(2);
        tau = th1/(th1-th2);

        for j = 1:20
            H = (2*tau^3-3*tau^2+1)*th1 ...
                +(tau^3-2*tau^2+tau)*h*om1 ...
                +(-2*tau^3+3*tau^2)*th2 ...
                +(tau^3-tau^2)*h*om2;
            dH = (6*tau^2-6*tau)*th1 ...
                 +(3*tau^2-4*tau+1)*h*om1 ...
                 +(-6*tau^2+6*tau)*th2 ...
                 +(3*tau^2-2*tau)*h*om2;
            tau_n = tau-H/dH;
            if abs(tau_n-tau) < 1e-14
                tau = tau_n;
                break
            end
            tau = tau_n;
        end

        dH = (6*tau^2-6*tau)*th1 ...
             +(3*tau^2-4*tau+1)*h*om1 ...
             +(-6*tau^2+6*tau)*th2 ...
             +(3*tau^2-2*tau)*h*om2;
        t(end+1) = t(end)+tau*h;
        theta(end+1) = 0;
        omega(end+1) = dH/h;
    else
        t(end+1) = t(end)+h;
        theta(end+1) = yn(1);
        omega(end+1) = yn(2);
    end
end
end
