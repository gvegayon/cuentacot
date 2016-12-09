*! version 0.13.9  4sep2013
*! Verifica si es que una variable existe o no
*! autor George G. Vega Yon
program define _cc_check_newvar
	args var rep
	
	cap confirm var `var', exact
	if (!_rc & !length("`rep'")) {
		di as error "Variable -`var'- ya existe. Utilice la opcion -replace-"
		error 110
	}
	else cap drop `var'
end
