# De la integral de tiempo a la integral elíptica

Esta nota desarrolla la solución implícita del **modelo ideal** de una barra homogénea articulada en un extremo y liberada desde el reposo. Se escribe `F(phi,k)` para la integral elíptica incompleta de primera especie **en la convención de módulo `k`**. La función `ellipticF(phi,m)` de MATLAB, en cambio, recibe el parámetro `m=k^2`.

## 1. Punto de partida

Sea `omega0^2 = 3g/(2L)`, y sea `0 <= theta <= theta0 < pi/2`. Por conservación de la energía, durante la caída se tiene

$$
\dot\theta=-\sqrt{2\omega_0^2(\sin\theta_0-\sin\theta)}.
$$

El signo negativo corresponde a que el ángulo disminuye. Al separar variables, el tiempo de llegada al ángulo `theta` es

$$
t^*(\theta)=\int_{\theta}^{\theta_0}
\frac{ds}{\sqrt{2\omega_0^2(\sin\theta_0-\sin s)}}. \tag{1}
$$

Esta expresión es exacta dentro del modelo. Su valor decimal debe evaluarse numéricamente.

## 2. Cómo elegir el cambio de variable

La forma estándar de Legendre contiene `1-k^2 sin^2(x)` bajo una raíz cuadrada [DLMF, 19.2.4](https://dlmf.nist.gov/19.2.E4). En (1) aparece `sin(s)` sin elevar al cuadrado. Para llevarlo a la forma estándar, se usa la identidad de ángulo doble

$$
\sin s=-\cos\!\left(\frac\pi2+s\right)
=2\sin^2\!\left(\frac\pi4+\frac{s}{2}\right)-1.
$$

Esto **motiva** (y no exige memorizar) el cambio

$$
x=\frac\pi4+\frac{s}{2},\qquad ds=2\,dx.
$$

El término `pi/4` proviene de dividir entre dos el desplazamiento `pi/2` de la identidad anterior. Si `a=sin(theta0)` y `k1^2=2/(1+a)`, entonces

$$
a-\sin s=(1+a)-2\sin^2x=(1+a)(1-k_1^2\sin^2x).
$$

Los límites `s=theta` y `s=theta0` pasan a `x=pi/4+theta/2` y `x=pi/4+theta0/2`. Por tanto,

$$
t^*(\theta)=\frac{\sqrt2}{\omega_0\sqrt{1+a}}
\int_{\pi/4+\theta/2}^{\pi/4+\theta_0/2}
\frac{dx}{\sqrt{1-k_1^2\sin^2x}}. \tag{2}
$$

## 3. Identificación con la integral elíptica

La definición [DLMF, 19.2.4](https://dlmf.nist.gov/19.2.E4) es

$$
F(\varphi,k)=\int_0^{\varphi}\frac{dx}{\sqrt{1-k^2\sin^2x}}.
$$

Por diferencia de integrales con límite inferior cero, (2) se convierte en

$$
t^*(\theta)=\frac{\sqrt2}{\omega_0\sqrt{1+a}}
\left[
F\!\left(\frac\pi4+\frac{\theta_0}{2},k_1\right)
-F\!\left(\frac\pi4+\frac\theta2,k_1\right)
\right],\qquad k_1=\sqrt{\frac{2}{1+a}}>1. \tag{3}
$$

Los dos términos `F` son necesarios porque (1) integra entre dos ángulos, mientras que `F` se define desde cero. En el intervalo físico, `k1 sin(x) <= 1`; el extremo superior es el punto donde vale la igualdad. La integral impropia sigue siendo convergente.

## 4. Transformación a un módulo menor que uno

Para usar un módulo en `(0,1)`, ponemos `k=1/k1=sqrt((1+a)/2)` y en cada término de (3) hacemos `sin(beta)=k1 sin(x)`. La [transformación de módulo recíproco de DLMF, 19.7.4](https://dlmf.nist.gov/19.7.E4) da, en este intervalo real,

$$
F(x,k_1)=\frac1{k_1}F\!\left(\arcsin(k_1\sin x),\frac1{k_1}\right).
$$

En el extremo inicial `x0=pi/4+theta0/2`, se cumple `k1 sin(x0)=1`, por lo que la amplitud transformada es `pi/2`. Allí [DLMF, 19.2.8](https://dlmf.nist.gov/19.2.E8) identifica `F(pi/2,k)=K(k)`. En el extremo correspondiente a `theta`,

$$
k_1\sin\!\left(\frac\pi4+\frac\theta2\right)
=\sqrt{\frac{1+\sin\theta}{1+\sin\theta_0}}.
$$

Además, `sqrt(2)/(sqrt(1+a) k1)=1`. El resultado final es

$$
\boxed{
t^*(\theta)=\frac1{\omega_0}\left[
K(k)-F\!\left(
\arcsin\sqrt{\frac{1+\sin\theta}{1+\sin\theta_0}},k
\right)\right],
\qquad k^2=\frac{1+\sin\theta_0}{2}.
} \tag{4}
$$

Comprobaciones: `t*(theta0)=0` y, para `theta=0`, (4) da el tiempo de caída. La expresión (4) reemplaza la ecuación (10) de la versión enviada inicialmente: la transformación de módulo de aquella ecuación, tal como estaba impresa, no conduce a (4).

## 5. Evaluación numérica y alcance de la exactitud

Para `L=3 m`, `g=9.81 m/s^2` y `theta0=89°`, (4) da aproximadamente `t*(0)=2.36885626016 s`. MATLAB utiliza el **parámetro** `m=k^2=(1+sin(theta0))/2` en `ellipticF(phi,m)` y `ellipticK(m)`, mientras que estas ecuaciones matemáticas usan el **módulo** `k`.

La forma cerrada (4) es exacta **dentro de las hipótesis del modelo**; la evaluación por software es aproximada. Para cuantificar el error de una cuadratura hay que comparar sus resultados con una evaluación de mayor precisión y controlar la estabilización al aumentar la precisión de trabajo. La coincidencia entre dos resultados de doble precisión, por sí sola, no es una cota rigurosa del error. Cerca de `theta0`, la resta `K-F` puede perder cifras por cancelación; para esos ángulos conviene emplear la integral regularizada o precisión aumentada.

## Referencias para citar

- NIST Digital Library of Mathematical Functions (DLMF), capítulo 19, [ecuación 19.2.4](https://dlmf.nist.gov/19.2.E4): definición de la integral elíptica incompleta de primera especie.
- DLMF, [ecuación 19.2.8](https://dlmf.nist.gov/19.2.E8): relación entre integral completa e incompleta, `K(k)=F(pi/2,k)`.
- DLMF, [ecuación 19.7.4](https://dlmf.nist.gov/19.7.E4): transformación de módulo recíproco.
- [Cómo citar la DLMF](https://dlmf.nist.gov/help/cite): entrada bibliográfica y formato de enlaces permanentes a ecuaciones.

El desplazamiento `x=pi/4+s/2` y la aplicación a la barra se **derivan aquí** a partir de la identidad trigonométrica y de la forma canónica de 19.2.4; no se atribuyen como una fórmula específica publicada en la DLMF.
