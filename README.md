# La barra que desafía la caída libre

Material complementario del trabajo «La barra que desafía la caída libre: métodos numéricos en contexto».

## Contenido

- [`derivacion_eliptica.md`](derivacion_eliptica.md): derivación de la solución implícita exacta del modelo a partir de la integral de tiempo, transformación de módulo recíproco y referencias.
- Códigos MATLAB: se incorporarán una vez revisados y comparados con los resultados del artículo. **Este repositorio inicial aún no contiene una implementación reproducible.**

## Parámetros del ejemplo numérico del artículo

Longitud de barra `L = 3 m`, gravedad `g = 9.81 m/s^2`, ángulo inicial `theta0 = 89 grados`; los cálculos trigonométricos usan radianes. El tiempo de caída del modelo ideal es aproximadamente `2.36885626016 s`.

## Alcance

La referencia elíptica describe el modelo ideal sin disipación. La cuadratura de Gauss–Legendre, Euler y RK4 son evaluaciones numéricas con sus propios errores. Los datos experimentales también incorporan diferencias físicas y de medición.

## Referencia matemática

NIST Digital Library of Mathematical Functions, capítulo 19, ecuaciones [19.2.4](https://dlmf.nist.gov/19.2.E4), [19.2.8](https://dlmf.nist.gov/19.2.E8) y [19.7.4](https://dlmf.nist.gov/19.7.E4).
