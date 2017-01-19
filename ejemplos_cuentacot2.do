clear all
set more off
set trace off

use set_test, clear

// Creando variables para ccset
gen fecha = mod(periodo, 100) + floor(periodo/100)*12
ccset idper fecha

// Cotizaciones discontinuas
ccdis discontinuas
cccont continuas
