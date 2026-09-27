clear all; clc; close all;

% parametros
L = 3;
g = 9.81;
theta0 = 89*pi/180;
omega0_sq = 3*g/(2*L);
omega0 = sqrt(omega0_sq);

N = [1 2 4 8 16 32 64];
nrep = 100;

tref = referencia_eliptica(0,theta0,omega0);

error2 = zeros(size(N));
error3 = zeros(size(N));
error4 = zeros(size(N));

tiempo2 = zeros(size(N));
tiempo3 = zeros(size(N));
tiempo4 = zeros(size(N));

for k = 1:length(N)

    % Primera evaluacion fuera del cronometraje
    % para evitar incluir el costo inicial de carga.
    I2 = cuadratura_tiempo(0,theta0,omega0_sq,N(k),2);
    I3 = cuadratura_tiempo(0,theta0,omega0_sq,N(k),3);
    I4 = cuadratura_tiempo(0,theta0,omega0_sq,N(k),4);

    error2(k) = abs(I2-tref);
    error3(k) = abs(I3-tref);
    error4(k) = abs(I4-tref);

    tic
    for j = 1:nrep
        I2 = cuadratura_tiempo(0,theta0,omega0_sq,N(k),2);
    end
    tiempo2(k) = toc/nrep;

    tic
    for j = 1:nrep
        I3 = cuadratura_tiempo(0,theta0,omega0_sq,N(k),3);
    end
    tiempo3(k) = toc/nrep;

    tic
    for j = 1:nrep
        I4 = cuadratura_tiempo(0,theta0,omega0_sq,N(k),4);
    end
    tiempo4(k) = toc/nrep;

end

fprintf('Referencia eliptica: %.15f s\n\n',tref);

fprintf('Errores:\n');
fprintf('%6s %10s %14s %10s %14s %10s %14s\n', ...
        'N','eval. 2p','error 2p','eval. 3p','error 3p', ...
        'eval. 4p','error 4p');

for k = 1:length(N)
    fprintf('%6d %10d %14.3e %10d %14.3e %10d %14.3e\n', ...
            N(k),2*N(k),error2(k), ...
            3*N(k),error3(k), ...
            4*N(k),error4(k));
end

fprintf('\nTiempo medio por integral, en microsegundos:\n');
fprintf('%6s %14s %14s %14s\n', ...
        'N','tiempo 2p','tiempo 3p','tiempo 4p');

for k = 1:length(N)
    fprintf('%6d %14.3f %14.3f %14.3f\n', ...
            N(k),1e6*tiempo2(k), ...
            1e6*tiempo3(k),1e6*tiempo4(k));
end

figure('Color','w');
hold on;
box on;

loglog(2*N,error2,'ko-', ...
       'LineWidth',1,'MarkerFaceColor','none');

loglog(3*N,error3,'bs-', ...
       'LineWidth',1,'MarkerFaceColor','none');

loglog(4*N,error4,'r^-', ...
       'LineWidth',1,'MarkerFaceColor','none');

set(gca,'YScale','log','XScale','log');
xlabel('numero de evaluaciones');
ylabel('error absoluto (s)');
legend({'2 puntos','3 puntos','4 puntos'}, ...
       'Location','southwest','Box','off');
grid on;

print(gcf,'mini_prueba_convergencia_gauss.png', ...
      '-dpng','-r200');

figure('Color','w');
hold on;
box on;

loglog(tiempo2,error2,'ko-', ...
       'LineWidth',1,'MarkerFaceColor','none');

loglog(tiempo3,error3,'bs-', ...
       'LineWidth',1,'MarkerFaceColor','none');

loglog(tiempo4,error4,'r^-', ...
       'LineWidth',1,'MarkerFaceColor','none');

set(gca,'YScale','log','XScale','log');
xlabel('tiempo medio por integral (s)');
ylabel('error absoluto (s)');
legend({'2 puntos','3 puntos','4 puntos'}, ...
       'Location','southwest','Box','off');
grid on;

print(gcf,'mini_prueba_error_tiempo.png', ...
      '-dpng','-r200');