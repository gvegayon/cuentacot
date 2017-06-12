/* Compila y arma paquete de cuentacot2 */

clear all
set more off
set trace off
mata mata clear

net from /home/george/Dropbox/repos/cuentacot/

set matastrict on

/* Compila programas de mata */
do cot_continuas.mata
do utils.mata
do n_per_cot_continuas.mata
do n_per_cot_continuas_empleador.mata
do cot_discontinuas.mata
do n_per_cot_discontinuas.mata
do n_per_cot_discontinuas2.mata
do n_per_promedio.mata
do n_per_promedio2.mata
do n_per_beneficios.mata
do saldo_cic.mata
do progress_bar.mata
do cc_analizar_empl.mata

/* Genera libreria */
mata: mata mlib create lccot, replace
mata: mata mlib add lccot *()

/* Archivos de ayuda mata */
// Necesitas instalar devtools (github.com/gvegayon/devtools)
// run ../../dev_tools/build_source_hlp.mata
/*
mata:
archmata = dir(".","files","*.mata")
_sort(archmata,1)
dt_moxygen(archmata, "ccot_source.sthlp", 1)
end
*/

net install cuentacot2, replace force

mata mata mlib query

do ../ejemplos.do
