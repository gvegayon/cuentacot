/* Compila y arma paquete de cuentacot2 */

clear all
set more off
set trace off
mata mata clear

// net from /home/george/Dropbox/repos/cuentacot/

set matastrict on

/* Compila programas de mata */
do pagossc/ado/pagos_sc.class.mata
do pagossc/ado/pagossci.mata

/* Genera libreria */
mata: mata mlib create lpagossc, replace dir(pagossc/ado)
mata: mata mlib add lpagossc *(), dir(pagossc/ado)

/* Archivos de ayuda mata */
// Necesitas instalar devtools (github.com/gvegayon/devtools)
// run ../../dev_tools/build_source_hlp.mata

cd pagossc/ado

mata:
archmata = dir(".","files","*.mata")
_sort(archmata,1)
dt_moxygen(archmata, "pagossc_source.sthlp", 1)
end


net from /home/george/Dropbox/repos/cuentacot
net install pagossc, replace force

mata mata mlib query


