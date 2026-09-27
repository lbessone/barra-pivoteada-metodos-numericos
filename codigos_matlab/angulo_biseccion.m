function theta = angulo_biseccion(t,theta0,omega0_sq,N,n_gauss)
% Invierte t*(theta) por biseccion.

a = 0;
b = theta0;

for j = 1:60
    theta = (a+b)/2;
    tq = cuadratura_tiempo(theta,theta0,omega0_sq,N,n_gauss);
    if tq < t
        b = theta;
    else
        a = theta;
    end
end

theta = (a+b)/2;
end
