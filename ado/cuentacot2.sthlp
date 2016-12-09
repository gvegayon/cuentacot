{smcl}
{* *! version 0.14.2  20feb2014}{...}
{cmd:help cuentacot2}
{hline}

{title:Title}

{phang}
{bf:cuentacot2} {hline 2} Contador complejo de cotizaciones

{title:Syntax}

{phang}
Configuraci{c o'}n inicial (setup).

{p 8 17 2}
{cmdab:ccset} {help varname:var_panel} {help varname:var_tiempo}

{phang}
Cuenta cotizaciones discontinuas.

{p 8 17 2}
{cmdab:ccdis} {help newvar:var_nueva} {ifin} [, {opt nsolic}({help varname}) {opt r:eplace}]

{phang}
Cuenta cotizaciones discontinuas en una ventana de tiempo.

{p 8 17 2}
{cmdab:ccdis_en_n} {help newvar:var_nueva} {ifin} [, {opt nsolic}({help varname}) {opt nper}({it:#}) {opt r:eplace} {opt enl:aguna} {opt altm}]

{phang}
Cuenta cotizaciones continuas.

{p 8 17 2}
{cmdab:cccont} {help newvar:var_nueva} {ifin} [, {opt nsolic}({help varname}) {opt r:eplace}]

{phang}
Cuenta cotizaciones continuas en una ventana de tiempo.

{p 8 17 2}
{cmdab:cccont_en_n} {help newvar:var_nueva} {ifin} [, {opt nsolic}({help varname}) {opt nper}({it:#}) {opt r:eplace} {opt enl:aguna}]

{phang}
Cuenta cotizaciones continuas con un mismo empleador en una ventana de tiempo.

{p 8 17 2}
{cmdab:cccont_en_n_empl} {help newvar:var_nueva} {ifin} ,  {opt e:mpl}({help varname}) [{opt nsolic}({help varname}) {opt nper}({it:#}) {opt r:eplace} {opt enl:aguna}]

{phang}
Media m{c o'}vil de una variable (t{c i'}picamente ingreso).

{p 8 17 2}
{cmdab:ccpromedio} {help newvar:var_nueva} {cmd:=} {help varname} {ifin} [, {opt nsolic}({help varname}) {opt nper}({it:#}) {opt r:eplace} {opt enl:aguna} {opt altm}]

{phang}
Cuenta de solicitudes/giros en una ventana de tiempo.

{p 8 17 2}
{cmdab:ccbeneficios} {help newvar:var_nueva} {ifin} , {opt nsolic}({help varname}) 
[{opt nper}({it:#}) {opt g:iros} {opt r:eplace} {opt enl:aguna}]

{phang}
Calcula saldo CIC din{c a'}micamente incluyendo giros

{p 8 17 2}
{cmdab:ccsaldo_cic} {help newvar:var_nueva} {ifin} , 
{opt ing:reso}({help varname})
{opt ind:efinido}({help varname})
[{opt m:ontocic}({help varname})
{opt r:eplace}
{opt coti:ndef}({it:#})
{opt cotp:lazo}({it:#})
{opt rent:abilidad}({it:#}) 
{opt saldoi:nicial}({help varname})
{opt com:ision}({it:#})
{opt matcoti:ndef}({it:{help varname}})
{opt matcotp:lazo}({it:{help varname}})
{opt matrent:abilidad}({it:{help m2_op_join:matriz}})
{opt matcom:ision}({it:{help varname}})]

{phang}
Asigna n{c u'}mero de empleador de manera din{c a'}mica al interior de las historias de cada persona.

{p 8 17 2}
{cmdab:ccanalizaempl} {help newvar:var_nueva} {ifin} ,  {opt e:mpl}({help varname}) [{opt r:eplace}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt nsolic}}Variable que contiene n{c u'}mero de solicitud a seguro de cesant{c i'}a.{p_end}
{synopt:{opt nper}}Tama{c n~}o de la ventana.{p_end}
{synopt:{opt empl}}Variable que contiene el id del empleador.{p_end}
{synopt:{opt reaplace}}Si es que la variable a crear ya existe, la reemplaza.{p_end}
{synopt:{opt enlaguna}}Opci{c o'}n que activa el c{c a'}lculo din{c a'}mico s{c o'}lo previo a lagunas (m{c a'}s r{c a'}pido.{p_end}
{synopt:{opt altm}}Opci{c o'}n que activa el uso de un algoritmo de c{c a'}lculo
alternativo el cual puede ser varias decenas de veces m{c a'}s r{c a'}pido.{p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
{cmd:cuentacot2} permite realizar cuentas complejas sobre cotizaciones 
continuas/discontinuas considerando ventanas de tiempo, solicitudes al SC,
cambio de empleador, etc. Internamente, el algoritmo determina qu{c e'}
observacions deben considerarse para incluir en c{c a'}lculos asociados
a ventanas de tiempo, de esta forma las lasgunas (y solicitudes al SC) 
son consideradas al momento de realizar las cuentas.
{p_end}

{pstd}
Para funcionar es necesario configurar utilizando el comando {cmd:ccset} (tal
como se hace con {cmd:tsset}) determinando la variable panel (persona) y tiempo.
La variable de tiempo debe ser ``continua'', es decir, 1, 2, 3, ...
{p_end}

{pstd}
En el caso de desear acelerar el c{c a'}lculo, la opci{c o'}n {opt enlaguna} indica
al comando que cuente cotizaciones/beneficios s{c o'}lo para las observaciones
que se encuentran justo antes de una laguna.
{p_end}

{pstd}
De contar con el {it:pegue} de la base de giros y rentas del Seguro de Cesant{c i'}a
(caso especial utilizado en la Superintendencia), al especificar n{c u'}mero de solicitud
(en {opt nsolic}), las cuentas considerar{c a'}n solicitudes al seguro, haciendo que
en las observaciones marcadas como solicitudes al seguro el contador vuelva a 0 inmediatamente
despu{c e'}s de la solicitud. Al mismo tiempo, el comando {cmd:ccbeneficios} permite
tomar ventaja de este set de datos y contar tanto el n{c u'}mero de solicitudes
realizadas (y pagadas) como el n{c u'}mero de pagos realizado en ventanas de tiempo.
La opci{c o'}n {opt nsolic} debe contener (en principio) la variable {cmd:nsolic}
que viene ya sea de la base de solicitudes o de giros y debe ser o {it:missing} o
distinto de {it:missing}, pues {cmd:cuentacot2} interpretar{c a'} cualquier valor 
distinto de {it:missing} como una solicitud.
{p_end}

{title:Calcula saldo CIC din{c a'}micamente}

{pstd}
El comando {cmd:ccsaldo_cic} permite establecer tasas de cotizaci{c o'}n,
rentabilidad y comisiones por tramo de forma tal que sean diferentes para cada
momento de tiempo. Esto se hace incluyendo una matriz de nx2, donde cada fila
representa un tramo de tiempo, la columna 1 el momento del tiempo hasta cuando
el valor correspondiente aplica y la columna 2 el valor correspondiente al tramo,
por ejemplo,
{p_end}

{phang2}{cmd:matcotindef((`=tm(2011m1)',.03\.,.035))}{p_end}

          1      2
    +---------------+
  1 |   612    .03  |
  2 |     .   .035  |
    +---------------+

{pstd}
entrega indica que, para los individuos con contrato indefinido, hasta enero
de 2011 aplica una tasa de 3%, luego, por el resto del periodo ({cmd:.} punto
implica ``sin fin'') aplica una tasa de 3.5%.
{p_end}

{pstd}
Un segundo ejemplo, agregando que hasta mayo de 2012 aplica la tasa de 3.5% para
luego pasar a una tasa de 4%, ser{c i'}a:
{p_end}

{phang2}{cmd:matcotindef((`=tm(2011m1)',.03\`=tm(2012m5)',.035\.,.04))}{p_end}

          1      2
    +---------------+
  1 |   612    .03  |
  2 |   628   .035  |
  3 |     .    .04  |
    +---------------+


{title:Acceso al Seguro de Cesant{c i'}a}

{dlgtab:Cuentas Individuales}

{pstd} Para ambos contratos:{p_end}
{p 4 7 2}
{bf:a.} {it:Haber sido despedido por algunas de las causales provistas en el N 6 del art{c i'}culo 159 o en el art{c i'}culo 161, ambos del c{c o'}digo del trabajo}
{p_end}

{pstd}Por tipo de contrato:{p_end}
{p 4 7 2}
{bf:b.} {it: {bf:Contrato indefinido} Contar con al menos {ul:12 cotizaciones} desde la afiliaci{c o'}n o desde el {c u'}ltimo giro SC realizado.}
{p_end}

{p 4 7 2}
{bf:c.} {it: {bf:Contrato a plazo} Contar con al menos {ul:6 cotizaciones} desde la afiliaci{c o'}n o desde el {c u'}ltimo giro SC realizado.}
{p_end}

{p 7 7 2}Tasas de reemplazo CIC{p_end}
{p2colset 7 16 16 2}
{p2col :N {space 4}{c |}}Tasa {p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c +}{c -}{dup 6:{c -}}}{p_end}
{p2col :1 {space 4}{c |}}50%{p_end}
{p2col :2 {space 4}{c |}}45%{p_end}
{p2col :3 {space 4}{c |}}40%{p_end}
{p2col :4 {space 4}{c |}}35%{p_end}
{p2col :5 {space 4}{c |}}30%{p_end}
{p2col :6 {space 4}{c |}}25%{p_end}
{p2col :7 y + {c |}}25%{p_end}
{p2colreset}{...}

{dlgtab:Fondo Solidario}

{pstd}Antes de la reforma: S{c o'}lo trabajadores con contrato indefinido{p_end}

{p 4 7 2}
{bf:a.} {it:Registrar 12 cotizaciones mensuales continuas en el Fondo de Cesant{c i'}a Solidario en el per{c i'}odo inmediatamente anterior al despido}
{p_end}

{p 4 7 2}
{bf:b.} {it:Haber sido despedido por algunas de las causales provistas en el N 6 del art{c i'}culo 159 o en el art{c i'}culo 161, ambos del c{c o'}digo del trabajo}
{p_end}

{p 4 7 2}
{bf:c.} {it:Que los recursos de su cuenta individual por cesant{c i'}a sean insuficientes para obtener una prestaci{c o'}n por cesant{c i'}a por los per{c i'}odos, porcentajes y montos se{c n~}alados por la ley}
{p_end}

{p 7 7 2}
Es decir, que la suma de las tasas de reemplazo correspondientes por la
remuneraci{c o'}n promedio de los {c u'}ltimos 12 meses sea inferior a su saldo
en CIC.
{p_end}

{p 4 7 2}
{bf:d.} {it:Encontrarse cesante al momento de la solicitud}
{p_end}


{pstd}Despu{c e'}s de la reforma: Independiente del tipo de contrato del trabajador{p_end}

{p 4 7 2}
{bf:a.} {it:Registrar {ul:12 cotizaciones} mensuales en el Fondo de Cesant{c i'}a Solidario desde su afiliaci{c o'}n al Seguro o desde que se deveng{c o'} el {c u'}ltimo giro a que hubieren tenido derecho conforme a esta ley, en los {c u'}ltimos 24 meses anteriores contados al mes del t{c e'}rmino del contrato. Sin embargo, las {ul:tres {c u'}ltimas cotizaciones realizadas deben ser continuas y con el mismo empleador}.}
{p_end}

{p 4 7 2}
{bf:b.} {it:Haber sido despedido por algunas de las causales provistas en el N 6 del art{c i'}culo 159 o en el art{c i'}culo 161, ambos del c{c o'}digo del trabajo}
{p_end}

{p 4 7 2}
{bf:3.} {it:Encontrarse cesante al momento de la solicitud}
{p_end}

{p 4 7 2}
{bf:c.} {it:Que los recursos de su cuenta individual por cesant{c i'}a sean insuficientes para obtener una prestaci{c o'}n por cesant{c i'}a por los per{c i'}odos, porcentajes y montos se{c n~}alados por la ley}
{p_end}

{p 7 7 2}
Es decir, que la suma de las tasas de reemplazo correspondientes por la
remuneraci{c o'}n promedio de los {c u'}ltimos 12 meses sea inferior a su saldo
en CIC.
{p_end}

{p 4 7 2}
{bf:d.} {it:Encontrarse cesante al momento de la solicitud}
{p_end}

{p 7 7 2}Contrato Indefinido{p_end}
{p2colset 7 16 16 2}
{p2col :N {space 4}{c |}}Tasa {p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c +}{c -}{dup 6:{c -}}}{p_end}
{p2col :1 {space 4}{c |}}50%{p_end}
{p2col :2 {space 4}{c |}}45%{p_end}
{p2col :3 {space 4}{c |}}40%{p_end}
{p2col :4 {space 4}{c |}}35%{p_end}
{p2col :5 {space 4}{c |}}30%{p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c +}{c -}{dup 6:{c -}}}{p_end}
{p2col :6* {space 3}{c |}}25%{p_end}
{p2col :7* {space 3}{c |}}25%{p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c BT}{c -}{dup 6:{c -}}}{p_end}
{p2colreset}{...}
{p 6 6 2}{it:*: Pagos adicionales en crisis}{p_end}

{p 7 7 2}Contrato a Plazo, Obra o Faena{p_end}
{p2colset 7 16 16 2}
{p2col :N {space 4}{c |}}Tasa {p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c +}{c -}{dup 6:{c -}}}{p_end}
{p2col :1 {space 4}{c |}}35%{p_end}
{p2col :2 {space 4}{c |}}30%{p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c +}{c -}{dup 6:{c -}}}{p_end}
{p2col :3* {space 3}{c |}}25%{p_end}
{p2col :4* {space 3}{c |}}25%{p_end}
{p2col 7 20 20 0:{dup 6:{c -}}{c BT}{c -}{dup 6:{c -}}}{p_end}
{p2colreset}{...}
{p 6 6 2}{it:*: Pagos adicionales en crisis}{p_end}

{p 4 7 2}
{bf:5.} {it:No haber recibido beneficio FCS m{c a'}s de 2 veces en los {c u'}ltimos 5 a{c n~}os}
{p_end}

{title:C{c o'}digo de fuente}

{pstd}Funciones principales:{p_end}

{pstd}cccont {help ccot_source##cot_continuas:cot_continuas}{p_end}
{pstd}ccdis  {help ccot_source##cot_discontinuas:cot_discontinuas}{p_end}
{pstd}ccbeneficios {help ccot_source##n_per_beneficios:n_per_beneficios}{p_end}
{pstd}cccont_en_n {help ccot_source##n_per_cot_continuas:n_per_cot_continuas}{p_end}
{pstd}cccont_emplen_n {help ccot_source##n_per_cot_continuas_empleador:n_per_cot_continuas_empleador}{p_end}
{pstd}ccdis_en_n {help ccot_source##n_per_cot_discontinuas:n_per_cot_discontinuas}{p_end}
{pstd}ccpromedio {help ccot_source##n_per_promedio:n_per_promedio}{p_end}
{pstd}ccsaldo_cic {help ccot_source##aldo_cic:aldo_cic}{p_end}

{pstd}Funciones auxiliares:{p_end}

{pstd}Establece periodos validos {help ccot_source##ultvalido:ultvalido}{p_end}
{pstd}Marca lagunas {help ccot_source##cc_mark_lagunas:cc_mark_lagunas}{p_end}
{pstd}Selecciona un subset de los datos (in if) {help ccot_source##cc_range:cc_range}{p_end}

{title:Referencias}

{p 0 2} Versi{c o'}n de 1 de julio de 2012 "Ley N 19728: Establece un Seguro de Desempleo" (14 de mayo 2001), {browse "http://www.leychile.cl/Navegar?idNorma=184979"}{p_end}

{p 0 2} Versi{c o'}n original de "Ley N 19728: Establece un Seguro de Desempleo" (14 de mayo 2001), {browse "http://www.leychile.cl/Navegar?idNorma=184979&tipoVersion=0"}{p_end}

{p 0 2}Vega, George (2012) "CUENTACOT: Stata module for Contributions Counting", Statistical Software Components S457321, {it:Boston College Department of Economics}, {browse "http://ideas.repec.org/c/boc/bocode/s457321.html"}

{p 0 2}Superintendencia de Pensiones (2010b) "Seguro de Cesantía en Chile", {it: Gráfica LOM}, disponible en {browse "http://www.spensiones.cl/573/article-7513.html"}

{p 0 2}Vega, George (2012) "Cuentas Difíciles: Implementación del comando cuentacot", disponible en {browse "https://sites.google.com/site/gvegayon/software/cuentacot.zip"}


{title:Author}

{pstd}
George Vega Yon, Superindentencia de Pensiones. {browse "mailto:gvega@spensiones.cl"}
{p_end}
