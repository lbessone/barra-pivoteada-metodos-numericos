function [xg,wg] = gauss_legendre(n)
% Nodos y pesos de Gauss-Legendre en [-1,1].

if n == 2
    xg = [-1/sqrt(3), 1/sqrt(3)];
    wg = [1, 1];
elseif n == 3
    xg = [-sqrt(3/5), 0, sqrt(3/5)];
    wg = [5/9, 8/9, 5/9];
elseif n == 4
    xg = [-sqrt(3/7+2/7*sqrt(6/5)), ...
          -sqrt(3/7-2/7*sqrt(6/5)), ...
           sqrt(3/7-2/7*sqrt(6/5)), ...
           sqrt(3/7+2/7*sqrt(6/5))];
    wg = [(18-sqrt(30))/36, (18+sqrt(30))/36, ...
          (18+sqrt(30))/36, (18-sqrt(30))/36];
else
    error('Solo se incluyen las reglas de 2, 3 y 4 puntos.');
end
end
