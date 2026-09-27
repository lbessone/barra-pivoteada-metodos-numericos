"""Verificacion independiente del tiempo de caida del modelo ideal.

Requiere mpmath. No se usan entradas previamente redondeadas en double.
Ejecutar: python referencia_alta_precision.py
"""

import mpmath as mp


def calcular(cifras):
    with mp.workdps(cifras):
        g = mp.mpf("9.81")
        L = mp.mpf(3)
        theta0 = mp.mpf(89) * mp.pi / 180
        omega0 = mp.sqrt(3 * g / (2 * L))
        a = mp.sin(theta0)
        m = (1 + a) / 2  # Parametro m = k^2, no modulo k.
        phi = mp.asin(mp.sqrt(1 / (1 + a)))  # Angulo final theta = 0.

        t_eliptica = (mp.ellipk(m) - mp.ellipf(phi, m)) / omega0

        # Cuadratura adaptativa, independiente de las funciones elipticas.
        # sin(theta0)-sin(theta0-u^2) se evalua como
        # 2*cos(theta0-u^2/2)*sin(u^2/2), evitando cancelacion.
        def integrando(u):
            if u == 0:
                return mp.sqrt(2) / (omega0 * mp.sqrt(mp.cos(theta0)))
            den = 4 * omega0**2 * mp.cos(theta0 - u**2 / 2) * mp.sin(u**2 / 2)
            return 2 * u / mp.sqrt(den)

        t_cuadratura = mp.quad(integrando, [0, mp.sqrt(theta0)])
        return str(mp.nstr(t_eliptica, cifras - 5)), str(mp.nstr(t_cuadratura, cifras - 5)), str(mp.nstr(abs(t_eliptica - t_cuadratura), 8))


if __name__ == "__main__":
    print("mpmath", mp.__version__)
    for cifras in (40, 60):
        t_eliptica, t_cuadratura, diferencia = calcular(cifras)
        print("cifras de trabajo:", cifras)
        print("  expresion eliptica:", t_eliptica)
        print("  cuadratura regularizada:", t_cuadratura)
        print("  diferencia interna:", diferencia)
