clear all; clc; close all;

% parametros
L = 3;
g = 9.81;
theta0 = 89*pi/180;
dt = 0.10;
dt_conv = [0.20 0.10 0.05 0.025 0.0125 0.00625];
N = 64;
omega0_sq = 3*g/(2*L);
tstar = cuadratura_tiempo(0,theta0,omega0_sq,N,4);

% convergencia del tiempo de caida
error_E = zeros(size(dt_conv));
error_R = zeros(size(dt_conv));

for i = 1:length(dt_conv)
    [tE,thE,omE] = euler_barra(theta0,omega0_sq,dt_conv(i));
    [tR,thR,omR] = rk4_barra(theta0,omega0_sq,dt_conv(i));
    error_E(i) = abs(tE(end)-tstar);
    error_R(i) = abs(tR(end)-tstar);
end

pE = polyfit(log(dt_conv),log(error_E),1);
pR = polyfit(log(dt_conv),log(error_R),1);

% deriva de la energia para dt=0.1 s
[tE,thE,omE] = euler_barra(theta0,omega0_sq,dt);
[tR,thR,omR] = rk4_barra(theta0,omega0_sq,dt);

E0 = g*L*sin(theta0)/2;
energia_E = L^2*omE(1:end-1).^2/6+g*L*sin(thE(1:end-1))/2;
energia_R = L^2*omR(1:end-1).^2/6+g*L*sin(thR(1:end-1))/2;
error_energia_E = abs(energia_E-E0)/E0;
error_energia_R = abs(energia_R-E0)/E0;

fprintf('Orden de Euler: %.3f\n',pE(1));
fprintf('Orden de RK4:   %.3f\n',pR(1));
fprintf('Error maximo de energia, Euler: %.4e\n',max(error_energia_E));
fprintf('Error maximo de energia, RK4:   %.4e\n',max(error_energia_R));

% figura 4
figure('Color','w','Position',[80 80 950 420]);

subplot(1,2,1); hold on; box on;
loglog(dt_conv,error_E,'ro','LineWidth',1,'MarkerFaceColor','none');
loglog(dt_conv,error_R,'bs','LineWidth',1,'MarkerFaceColor','none');
refE = error_E(1)*(dt_conv/dt_conv(1));
refR = error_R(1)*(dt_conv/dt_conv(1)).^4;
loglog(dt_conv,refE,'r--','LineWidth',1);
loglog(dt_conv,refR,'b--','LineWidth',1);
xlabel('\Delta t (s)'); ylabel('e(\Delta t)=|t_{num}-t^*| (s)');
legend({sprintf('Euler (p=%.2f)',pE(1)),sprintf('RK4 (p=%.2f)',pR(1)), ...
        'ref. O(\Delta t)','ref. O(\Delta t^4)'}, ...
        'Location','southeast','Box','off','FontSize',9);
set(gca,'FontSize',10,'YScale','log','XScale','log'); grid on;

subplot(1,2,2); hold on; box on;
semilogy(tE(1:end-1),error_energia_E,'r-.','LineWidth',1);
semilogy(tR(1:end-1),error_energia_R,'b--','LineWidth',1);
xlabel('t (s)'); ylabel('\epsilon_E(t)=|E-E_0|/E_0');
legend({'Euler','RK4'},'Location','southeast','Box','off','FontSize',9);
set(gca,'FontSize',10,'YScale','log'); grid on;

print(gcf,'fig4_convergencia_energia.png','-dpng','-r220');
