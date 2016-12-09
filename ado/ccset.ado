*! version 0.13.8.29  29ago2013
*! Configura cuentacot
*! autor George G. Vega Yon
program def ccset

	vers 11.0

	syntax varlist(min=2 max=2 numeric)
	
	tokenize `varlist'

	global CCPANEL `1'
	global CCPERIODO `2'
	
	di "{title:Configuracion contador de cotizaciones}"
	di as text "{it:Variable panel  }:" as result "$CCPANEL"
	di as text "{it:Variable tiempo }:" as result "$CCPERIODO"
end
