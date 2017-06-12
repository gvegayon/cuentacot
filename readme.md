# CUENTACOT2: Stata module for Contributions Counting

Para uso de bases de datos de remuneraciones/cotizaciones. Genera variables de
tipo dicotomicas en base a algoritmo de cuenta de numero de cotizaciones de cada
individuo para cada momento del tiempo.

El directorio `ado` contiene la ultima version del modulo. Esta esta escrita
principalmente en `mata`, mas aun, esta escrita de tal forma que es rapida
y eficiente en el manejo de memoria. El archivo `cuentacot.ado` disponible
en el directorio principal de este repositorio es una version antigua (disponible
en SSC)

Adicionalmente, en la carpeta `pagossc` se encuentra otro modulo que tiene
como objetivo calcular monto de los pagos del seguro de cesantia.

# IMPORTANTE

Este software no viene con ningun tipo de garantias. Uselo bajo su propia
responsabilidad.

# Instalacion

1.  Descarga el siguiente ZIP https://github.com/gvegayon/cuentacot/archive/master.zip
2.  Descomprime el zip y obten el dir completo, por ejemplo /home/george/Downloads/cuentacot-master
3.  Desde stata, usa los siguientes comandos

```
. net from /home/george/Downloads/cuentacot-master

. net install cuentacot2
. mata mata mlib query
```

4.  Para estar seguro que la instalacion fue un exito, deberias poder utilizar los
    archivos ejemplos_cuentacot2.do junto con el dta set_test.dta
    
# Author

George G. Vega Yon (g [aquivaunpunto] vegayon en gmail)
