clear all; clc; close all;

% parametros
L = 3;
g = 9.81;
theta0 = 89*pi/180;
omega0_sq = 3*g/(2*L);
omega0 = sqrt(omega0_sq);
N = [1 2 4 8 16 32 64 128];

[xg,wg] = gauss_legendre(4);
tref = referencia_eliptica(0,theta0,omega0);
error_directa = zeros(size(N));
error_regular = zeros(size(N));

for k = 1:length(N)
    % cuadratura aplicada directamente sobre s
    s = linspace(0,theta0,N(k)+1);
    I = 0;
    for i = 1:N(k)
        M = (s(i+1)-s(i))/2;
        P = (s(i+1)+s(i))/2;
        sg = M*xg+P;
        phi = 1./sqrt(2*omega0_sq*(sin(theta0)-sin(sg)));
        I = I+M*sum(wg.*phi);
    end
    error_directa(k) = abs(I-tref);

    % cuadratura despues del cambio u=sqrt(theta0-s)
    I = cuadratura_tiempo(0,theta0,omega0_sq,N(k),4);
    error_regular(k) = abs(I-tref);
end

fprintf('Referencia eliptica: %.15f s\n\n',tref);
fprintf('%8s %12s %18s %18s\n','N','evaluaciones','sin regularizar','regularizada');
for k = 1:length(N)
    fprintf('%8d %12d %18.3e %18.3e\n',N(k),4*N(k), ...
            error_directa(k),error_regular(k));
end

% comparacion de errores
figure('Color','w'); hold on; box on;
loglog(4*N,error_directa,'r--o','LineWidth',1,'MarkerFaceColor','none');
loglog(4*N,error_regular,'b-s','LineWidth',1,'MarkerFaceColor','none');
xlabel('numero de evaluaciones');
ylabel('error absoluto (s)');
legend({'Sin regularizar','Regularizada'},'Location','southwest','Box','off');
grid on;
print(gcf,'comparacion_convergencia_regularizacion.png','-dpng','-r200');
set(gca,'YScale','log','XScale','log'); grid on;

% forma de los integrandos
s = linspace(0,0.9999*theta0,1000);
phi = 1./sqrt(2*omega0_sq*(sin(theta0)-sin(s)));
u = linspace(0,sqrt(theta0),1000);
Phi = zeros(size(u));
Phi(1) = 2/sqrt(2*omega0_sq*cos(theta0));
dseno = 2*cos(theta0-u(2:end).^2/2).*sin(u(2:end).^2/2);
Phi(2:end) = 2*u(2:end)./sqrt(2*omega0_sq*dseno);

figure('Color','w','Position',[80 80 900 380]);
subplot(1,2,1); plot(s*180/pi,phi,'r-','LineWidth',1); box on; grid on;
xlabel('s (^o)'); ylabel('\phi(s)'); xlim([0 theta0*180/pi]);
subplot(1,2,2); plot(u,Phi,'b-','LineWidth',1); box on; grid on;
xlabel('u'); ylabel('\Phi(u)');
print(gcf,'comparacion_integrandos.png','-dpng','-r200');
