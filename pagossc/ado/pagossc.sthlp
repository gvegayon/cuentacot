{smcl}
{* *! version 0.13.10  14oct2013}{...}
{cmd:help pagossc}
{hline}

{title:Title}

{phang}
{bf:pagossc} {hline 2} Calcula monto de los pagos del SC

{title:Syntax}

{phang}
Implementacion vectorial (gen).

{p 8 17 2}
{cmdab:pagossc}
{it:{help varname:saldo}}
{it:{help varname:renta}}
[{it:{help varname:indef}}
{it:{help varname:derechofcs}}]
{ifin}
[, {opt p:refix}({it:{help name}})
{opt r:eplace}
{opt m:axp}({it:{help integer}})
{opt tfcsi:ndef}({it:{help m2_op_join:vector}})
{opt tfcsp:lazo}({it:{help m2_op_join:vector}})
{opt tcici:ndef}({it:{help m2_op_join:vector}})
{opt tcicp:lazo}({it:{help m2_op_join:vector}})
{opt li:ndef}({it:{help m2_op_join:matriz}})
{opt lp:lazo}({it:{help m2_op_join:matriz}})
]

{phang}
Implementacion escalar.

{p 8 17 2}
{cmdab:pagossci}
{it:saldo#}
{it:renta#}
[{it:indef#}
{it:derechofcs#}]
[{cmd:using} {it:{help filename}}]
[, {opt b:ooktabs} {opt mat:save}({it:{help name}})
{opt texd:oc}
{opt m:axp}({it:{help integer}})
{opt tfcsi:ndef}({it:{help m2_op_join:vector}})
{opt tfcsp:lazo}({it:{help m2_op_join:vector}})
{opt tcici:ndef}({it:{help m2_op_join:vector}})
{opt tcicp:lazo}({it:{help m2_op_join:vector}})
{opt li:ndef}({it:{help m2_op_join:matriz}})
{opt lp:lazo}({it:{help m2_op_join:matriz}})
]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Opciones b{c a'}sicas}
{synopt:{opt p:refix}}Prefijo para el nombre de las variables que se generar{c a'}n.{p_end}
{synopt:{opt r:eplace}}Reemplaza la variable/archivo.{p_end}
{synopt:{opt b:ooktabs}}Imprimir las tablas usando {cmd:booktabs}.{p_end}
{synopt:{opt mat:save}}Nombre de matriz donde se guardar{c a'}n los pagos.{p_end}
{synopt:{opt tex:doc}}Para escribir en un archivo de tex ya abierto.{p_end}
{synopt:{opt m:axp}}N{c u'}mero m{c a'}ximo de pagos a calcular (por defecto 12).{p_end}

{syntab:L{c i'}mites y tasas de reemplazo personalizadas}
{synopt:{opt tfcsi:ndef}}Tasas de reemplazo FCS para contrato indefinido.{p_end}
{synopt:{opt tfcsp:lazo}}Tasas de reemplazo FCS para contrato a plazo.{p_end}
{synopt:{opt tcici:ndef}}Tasas de reemplazo CIC para contrato indefinido.{p_end}
{synopt:{opt tcicp:lazo}}Tasas de reemplazo CIC para contrato a plazo.{p_end}
{synopt:{opt li:ndef}}L{c i'}mites FCS inferiores y superiores para contrato indefinido.{p_end}
{synopt:{opt lp:lazo}}L{c i'}mites FCS inferiores y superiores para contrato a plazo.{p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
En base a las tasas de reemplazo y limites superiores e inferiores para cada
tipo de contrato y beneficio, el m{c o'}dulo calcula el valor correspondiente
a cada pago ya sea si el individuo tiene derecho o no al FCS.
{p_end}

{pstd}
En el caso de que una observaci{c o'} cuente con un saldo cuantioso en su cuenta
individual, con el objetivo de evitar que {cmd:pagossc} itere indefinidamente
mientras calcula los pagos, utilizando la opci{c o'}n {opt m:axp} se le obliga a
{cmd:pagossc} que s{c o'}lo calcule hasta cierta cantidad de pagos. Para las 
observaciones que se ven afectadas por esta opci{c o'}n, el comando suma el saldo
que falt{c o'} distribuir al {c u'}ltimo pago calculado. Esta opci{c o'}n se
encuentra por defecto en 12.
{p_end}

{title:Examples}

{pstd}Calculando pagos con saldo 200.000, renta 250.000, contrato indefinido
y con derecho al SC{p_end}
{phang2}{cmd:. pagossci 200000 250000 1 1, r mats(mimat)}{p_end}

\hline N & Monto FCS & Monto CIC & Total \\ \hline
  1 &         0 &   125.000 &   125.000\\ 
  2 &    37.500 &    75.000 &   112.500\\ 
  3 &   100.000 &         0 &   100.000\\ 
  4 &    87.500 &         0 &    87.500\\ 
  5 &    75.000 &         0 &    75.000\\ 
\hline & & Total &   500.000 \\\hline

{phang2}{cmd:. mat list mimat}{p_end}

mimat[5,3]
      fcs     cic   total
1       0  125000  125000
2   37500   75000  112500
3  100000       0  100000
4   87500       0   87500
5   75000       0   75000

{title:Notes}

{pstd}
El comando {cmd:pagossc} permite establecer tasas de reemplazo y l{c i'}mites
para el pago de beneficios de Fondo Solidario y Cuenta Individual.
Esto se hace incluyendo una matrices mata como se observa m{c a'}s abajo.
{p_end}

{pstd}
Por defecto tanto {cmd:pagossci} como {cmd:pagossc} est{c a'}n utilizando las
siguientes tablas de pago (vigentes al 14 de octubre de 2013)
{p_end}

{phang2}Tasas de reemplazo para indefinido para ambos contratos{p_end}
{phang2}{cmd:(.50\ .45\ .40\ .35\ .30)}{p_end}


{phang2}Tasas de reemplazo para plazo fijo para ambos contratos{p_end}
{phang2}{cmd:(.35\ .30)}{p_end}
	
{phang2}Limintes indefinidos {p_end}
{phang2}{cmd:(234794, 108747 \211315, 90211 \187835, 79089 \164356, 69204 \140877, 59317)}{p_end}
{phang2}Cual se ve as{c i'}:{p_end}

            1        2
    +-------------------+
  1 |  234794   108747  |
  2 |  211315    90211  |
  3 |  187835    79089  |
  4 |  164356    69204  |
  5 |  140877    59317  |
    +-------------------+
		
{phang2}Limintes plazo fijo{p_end}
{phang2}{cmd:(164356, 69204 \140877, 59317)}{p_end}
{phang2}Cual se ve as{c i'}:{p_end}

	            1        2
    +-------------------+
  1 |  164356    69204  |
  2 |  140877    59317  |
    +-------------------+

{title:Author}

{pstd}
George G. Vega Yon, Superindentencia de Pensiones. {browse "mailto:gvega@spensiones.cl"}
{p_end}

