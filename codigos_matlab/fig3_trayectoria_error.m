clear all; clc; close all;

% parametros
L = 3;
g = 9.81;
theta0 = 89*pi/180;
dt = 0.10;
N = 64;
omega0_sq = 3*g/(2*L);

% solucion de referencia y soluciones numericas
tstar = cuadratura_tiempo(0,theta0,omega0_sq,N,4);
[tref,thref] = curva_referencia(theta0,omega0_sq,300,4);
[tE,thE] = euler_barra(theta0,omega0_sq,dt);
[tR,thR] = rk4_barra(theta0,omega0_sq,dt);

% error en la posicion angular
indE = find(tE > 0 & tE <= tstar);
indR = find(tR > 0 & tR <= tstar);
error_theta_E = zeros(size(indE));
error_theta_R = zeros(size(indR));

for i = 1:length(indE)
    theta_ref = angulo_biseccion(tE(indE(i)),theta0,omega0_sq,N,4);
    error_theta_E(i) = abs(thE(indE(i))-theta_ref)*180/pi;
end

for i = 1:length(indR)
    theta_ref = angulo_biseccion(tR(indR(i)),theta0,omega0_sq,N,4);
    error_theta_R(i) = abs(thR(indR(i))-theta_ref)*180/pi;
end

% error en el tiempo
indTE = 2:length(tE);
indTR = 2:length(tR);
error_t_E = zeros(size(indTE));
error_t_R = zeros(size(indTR));

for i = 1:length(indTE)
    tq = cuadratura_tiempo(thE(indTE(i)),theta0,omega0_sq,N,4);
    error_t_E(i) = abs(tE(indTE(i))-tq);
end

for i = 1:length(indTR)
    tq = cuadratura_tiempo(thR(indTR(i)),theta0,omega0_sq,N,4);
    error_t_R(i) = abs(tR(indTR(i))-tq);
end

fprintf('Tiempo de referencia: %.15f s\n',tstar);
fprintf('Tiempo de Euler:      %.15f s\n',tE(end));
fprintf('Tiempo de RK4:        %.15f s\n',tR(end));

% figura 3
figure('Color','w','Position',[80 80 1300 380]);

subplot(1,3,1); hold on; box on;
plot(tref,thref*180/pi,'k-','LineWidth',1);
plot(tR,thR*180/pi,'b+','LineWidth',1.2);
plot(tE,thE*180/pi,'r--','LineWidth',1);
xlabel('t (s)'); ylabel('\theta (^o)');
legend({'Analitica','RK4','Euler'},'Location','southwest','Box','off','FontSize',8);
xlim([0,max([tE(end),tR(end)])*1.03]); ylim([0,92]);
set(gca,'FontSize',9); grid on;

subplot(1,3,2); hold on; box on;
semilogy(tE(indE),error_theta_E,'r-.o','LineWidth',1,'MarkerSize',5,'MarkerFaceColor','none');
semilogy(tR(indR),error_theta_R,'b--s','LineWidth',1,'MarkerSize',5,'MarkerFaceColor','none');
xlabel('t (s)'); ylabel('error |\theta_n-\theta^*(t_n)| (^o)');
legend({'Euler','RK4'},'Location','southeast','Box','off','FontSize',8);
set(gca,'FontSize',9,'YScale','log'); grid on;

subplot(1,3,3); hold on; box on;
semilogy(tE(indTE),error_t_E,'r-.o','LineWidth',1,'MarkerSize',5,'MarkerFaceColor','none');
semilogy(tR(indTR),error_t_R,'b--s','LineWidth',1,'MarkerSize',5,'MarkerFaceColor','none');
xlabel('t (s)'); ylabel('error |t_n-t^*(\theta_n)| (s)');
legend({'Euler','RK4'},'Location','southeast','Box','off','FontSize',8);
set(gca,'FontSize',9,'YScale','log'); grid on;

print(gcf,'fig3_trayectoria_error.png','-dpng','-r220');
