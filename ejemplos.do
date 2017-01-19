/*
********************************************************************************
Titulo:
	Prueba el comando "cuentacot"
Fecha:
	18 de Agosto de 2011
Autor:
	George Vega Yon
*/

clear all
vers 11

set more off

// cd I:/programa_cuenta_cot/

use set_test.dta, clear
//do cuentacot.ado
/*
// Calcular cotizaciones discontinuas
cuentacot periodo idper idemp, dis ns(nsolic)

// Calcular cotizaciones continuas
cuentacot periodo idper, tip(tipcon) cont k nc(3) ns(nsolic)

// Calcular cotizaciones continuas con el mismo empleador
cuentacot periodo idper idemp, ns(nsolic) tip(tipcon) contemp k np(6) nc(3)

// Calcular cotizaciones discontinuas con el mismo empleador
cuentacot periodo idper idemp, ns(nsolic) tip(tipcon) emp k np(6) nc(3)

// Calcular 3 cotizaciones en 6 periodos discontinuas
cuentacot periodo idper, nsolic(nsolic) menndis k np(6) nc(3)

// Calcular 3 cotizaciones en 6 periodos continuas
cuentacot periodo idper, nsolic(nsolic) mennc k np(6) nc(3)
*/
////////////////////////////////////////////////////////////////////////////////

replace marca = "X" if marca != ""

// Ejemplos para presentacion
// Carlos el que cotiza siempre
cuentacot periodo idper, ncot(3) dis cont k

#delimit ;
listtex nombre-nsolic  cuenta_cot_dis cuenta_cot_cont cotiza_continuas3 
using presentacion/caso1_siempre.tex if nombre == "Carlos", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{2}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic &  cuenta\_cot\_dis & cuenta\_cot\_cont & cotiza\_continuas3 \\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

// Mateo, el que cotiza con 1 laguna
cuentacot periodo idper idemp, ncot(3) dis cont k

#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont cotiza_continuas3 
using presentacion/caso2_1_laguna.tex if nombre == "Mateo", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{3}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta\_cot\_dis & cuenta\_cot\_cont & cotiza\_continuas3 \\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

cuentacot periodo idper idemp, ncot(3) dis cont k emp contemp
// Camila, el cambia de empleador
#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont  cuenta_cot_cont_emp cuenta_3_ult_cot_emp
using presentacion/caso3_cambia_empleador.tex if nombre == "Camila", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{4}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta$\sim$ dis & cuenta$\sim$ cont & cuenta$\sim$ cont\_emp & cuenta\_3\_ult\_cot\_emp \\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

//Gustavo, Cotiza siempre pero cambia el contrato
cuentacot periodo idper idemp, ncot(3) dis cont k emp contemp tip(tipcon)
#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont  cuenta_cot_cont_emp cuenta_3_ult_cot_emp
using presentacion/caso4_cambia_contrato.tex if nombre == "Gustavo", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{4}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta$\sim$ dis & cuenta$\sim$ cont & cuenta$\sim$ cont\_emp & cuenta\_3\_ult\_cot\_emp \\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

// Paola, la multicot
cuentacot periodo idper idemp, ncot(3) dis cont k emp contemp
#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont  cuenta_cot_cont_emp cuenta_3_ult_cot_emp
using presentacion/caso5_multicot.tex if nombre == "Paola", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{4}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta$\sim$ dis & cuenta$\sim$ cont & cuenta$\sim$ cont\_emp & cuenta\_3\_ult\_cot\_emp \\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

// Miguel, el desempleado (sin solic)
cuentacot periodo idper idemp, ncot(3) nper(6) dis cont menncont menndis k
#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont cuenta_cot_3_en_6_cont cuenta_cot_3_en_6_dis
using presentacion/caso6a_solicitud.tex if nombre == "Miguel", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{4}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta$\sim$ dis & cuenta$\sim$ cont & cuenta3\_en\_6\_cont & cuenta\_3\_en\_6\_dis\\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

// Miguel, el desempleado (con solic)
cuentacot periodo idper idemp, ns(nsolic) ncot(3) nper(6) dis cont menncont menndis k
#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont cuenta_cot_3_en_6_cont cuenta_cot_3_en_6_dis
using presentacion/caso6b_solicitud.tex if nombre == "Miguel", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{4}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta$\sim$ dis & cuenta$\sim$ cont & cuenta3\_en\_6\_cont & cuenta\_3\_en\_6\_dis\\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr

// María, las grandes lagunas
cuentacot periodo idper idemp, ns(nsolic) ncot(3) nper(6) dis cont menncont menndis k
#delimit ;
listtex nombre-marca  cuenta_cot_dis cuenta_cot_cont cuenta_cot_3_en_6_cont cuenta_cot_3_en_6_dis
using presentacion/caso7_grandes_lagunas.tex if nombre == "Maria", type rstyle(tabular)
head("\begin{tabular}{m{30pt}<{\raggedrigth}*{5}{m{20pt}<{\centering}}*{4}{c}r}" "\toprule" 
"nombre & periodo & idper & idemp & tipcon & nsolic & marca &  cuenta$\sim$ dis & cuenta$\sim$ cont & cuenta3\_en\_6\_cont & cuenta\_3\_en\_6\_dis\\ \midrule") 
foot("\bottomrule" "\end{tabular}") replace
;
#delimit cr
