clear all; clc; close all;

archivos = {'IMG_7641_h264_datos.csv','IMG_7642_datos.csv'};
dt = [0.02 0.03];
etiqueta_x = [0.35 0.35];

L = 2.80;
g = 9.81;
Ut = 0.03;
Utheta = 2;
N = 64;
omega0_sq = 3*g/(2*L);

verde = [0 0.55 0.15];
verde_claro = [0.65 0.93 0.65];

figure('Color','w','Position',[100 100 900 650]);
hold on; box on;

for k = 1:length(archivos)
    datos = dlmread(archivos{k},';',1,0);
    t_exp = datos(:,1);
    theta_exp = datos(:,5);
    theta0 = theta_exp(1)*pi/180;

    [tref,thref] = curva_referencia(theta0,omega0_sq,N,4);
    [tE,thE] = euler_barra(theta0,omega0_sq,dt(k));
    [tR,thR] = rk4_barra(theta0,omega0_sq,dt(k));

    omega_exp = sqrt(max(0,2*omega0_sq*(sin(theta0)-sin(theta_exp*pi/180))));
    banda = sqrt(Utheta^2+(omega_exp*180/pi*Ut).^2);

    hb = fill([t_exp;flipud(t_exp)], ...
              [theta_exp-banda;flipud(theta_exp+banda)], ...
              verde_claro,'FaceAlpha',0.2,'EdgeColor','none');
    he = plot(t_exp,theta_exp,'o','Color',verde,'MarkerSize',5.5,'LineStyle','none');
    ha = plot(tref,thref*180/pi,'k-','LineWidth',1);
    hr = plot(tR,thR*180/pi,'b+','LineWidth',1.2);
    hu = plot(tE,thE*180/pi,'r--','LineWidth',1);

    if k == 1
        h_leyenda = [hb he ha hr hu];
    end

    theta0_deg = theta0*180/pi;
    ytexto = theta0_deg+6;
    plot([t_exp(1) etiqueta_x(k)],[theta0_deg ytexto],'-', ...
         'Color',[0.4 0.4 0.4],'LineWidth',0.8);
    text(etiqueta_x(k)+0.01,ytexto,sprintf('\\theta_0 \\approx %.0f^o',theta0_deg), ...
         'FontSize',12,'FontWeight','bold');

    fprintf('%s: theta0=%.2f, referencia=%.4f, RK4=%.4f, Euler=%.4f s\n', ...
            archivos{k},theta0_deg,tref(end),tR(end),tE(end));
end

xlabel('t (s)'); ylabel('\theta (^o)');
ylim([0 98]); grid on;
legend(h_leyenda,{'Banda de incertidumbre en t y \theta','Experimental', ...
       'Analitica (cuadratura)','RK4','Euler'}, ...
       'Location','northeast','Box','on');

print(gcf,'fig5b_experimental.png','-dpng','-r200');
