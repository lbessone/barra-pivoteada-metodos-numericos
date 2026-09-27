```md
# La barra que desafía la caída libre

Material complementario del trabajo «La barra que desafía la caída libre: métodos numéricos en contexto».

## Contenido

- [`derivacion_eliptica.md`](derivacion_eliptica.md): derivación de la solución implícita del modelo en términos de integrales elípticas y transformación de módulo recíproco.
- `referencia_alta_precision.py`: comprobación independiente del tiempo de caída mediante la expresión elíptica y la cuadratura de la integral regularizada, utilizando la biblioteca `mpmath`.
- `codigos_matlab/`: códigos para generar las figuras del artículo y realizar las comprobaciones numéricas. Las funciones auxiliares necesarias se encuentran en la misma carpeta.

Entre las comprobaciones incluidas en `codigos_matlab/` se encuentran:

- `comparacion_regularizacion.m`: compara la cuadratura antes y después de regularizar la singularidad integrable.
- `mini_prueba_convergencia_gauss.m`: compara las reglas de Gauss–Legendre de 2, 3 y 4 puntos según el número de subintervalos y de valores del integrando.
- `mini_prueba_convergencia_gauss_tiempos.m`: añade una medición de los tiempos de ejecución de esas reglas. Los tiempos dependen del equipo y de las condiciones de ejecución.

## Datos experimentales

`IMG_7641.MOV` e `IMG_7642.MOV` son los videos originales de los ensayos, grabados con un iPhone. Los archivos `IMG_7641_h264_datos.csv` e `IMG_7642_h264_datos.csv` contienen los datos obtenidos al procesar esos videos. El código `fig5b_experimental.m` utiliza los CSV para comparar las trayectorias medidas con las calculadas mediante el modelo.

El archivo `trackeo_barra.m` es un programa auxiliar de seguimiento manual desarrollado con asistencia de inteligencia artificial. Permite señalar el pivote y marcar la posición del extremo libre en los fotogramas seleccionados. A partir de esas marcas calcula el ángulo de la barra y exporta los datos en un CSV separado por punto y coma, con las columnas `t;x;y;angv;ang;angrad`. El tiempo se cuenta desde el primer fotograma marcado.

Para ejecutar `trackeo_barra.m` se necesita MATLAB con `VideoReader`, además de `ffmpeg` y `ffprobe` accesibles desde el sistema. El programa convierte el archivo MOV a MP4 antes de recorrer sus fotogramas. La selección de los puntos de la barra es manual: la asistencia de IA se utilizó para desarrollar este programa auxiliar, no para generar los videos ni para identificar automáticamente las posiciones experimentales.

## Parámetros del ejemplo numérico del artículo

Longitud de la barra `L = 3 m`, gravedad `g = 9.81 m/s^2` y ángulo inicial `theta0 = 89 grados`. Los cálculos trigonométricos utilizan radianes. El tiempo de caída del modelo ideal es aproximadamente `2.36885626016 s`.

## Alcance

La expresión elíptica describe la solución del modelo ideal sin disipación. Sus valores decimales, la cuadratura de Gauss–Legendre y los resultados de Euler y RK4 se obtienen numéricamente. Los datos experimentales también están sujetos a incertidumbres de medición y a diferencias entre el dispositivo real y el modelo ideal.
```
