# Códigos MATLAB/Octave

Los archivos reproducen las figuras y las comprobaciones numéricas del trabajo.
Todos deben permanecer en la misma carpeta.

## Figuras del artículo

- `fig3_trayectoria_error.m`: trayectoria y errores para Euler y RK4.
- `fig4_convergencia_energia.m`: convergencia del tiempo de caída y deriva de energía.
- `fig5b_experimental.m`: comparación con los datos experimentales.

Para ejecutar la figura experimental también se necesitan:

- `IMG_7641_h264_datos.csv`
- `IMG_7642_datos.csv`

## Comprobaciones complementarias

- `comparacion_regularizacion.m`: compara la cuadratura aplicada antes y después de regularizar la singularidad.
- `mini_prueba_convergencia_gauss.m`: compara reglas de Gauss-Legendre de 2, 3 y 4 puntos, tanto por número de subintervalos como por cantidad de evaluaciones.
- `mini_prueba_convergencia_gauss_tiempos.m`: basado en el script `mini_prueba_convergencia_gauss.m` se comparan los tiempos de cálculo de cada regla.

## Funciones utilizadas

- `gauss_legendre.m`: nodos y pesos de las reglas de 2, 3 y 4 puntos.
- `cuadratura_tiempo.m`: evaluación de la integral regularizada.
- `curva_referencia.m`: construcción paramétrica de la solución de referencia.
- `euler_barra.m`: método de Euler y localización lineal del impacto.
- `rk4_barra.m`: método RK4 y localización del impacto mediante Hermite y Newton.
- `angulo_biseccion.m`: inversión de la relación entre tiempo y ángulo.
- `referencia_eliptica.m`: evaluación independiente mediante `ellipke` y `ellipj`.

Los scripts usan instrucciones disponibles en MATLAB R2015 y evitan funciones locales dentro de scripts. La lectura de los datos experimentales se realiza con `dlmread` para facilitar la ejecución en GNU Octave.
