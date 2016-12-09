*! version 0.13.8.29  29ago2013
*! Calcula el promedio en una ventana movil de unaq variable cualquiera
*! autor George G. Vega Yon
cap program drop ccpromedio
program define ccpromedio
	vers 11.0
	
	syntax name(name=varname) =/exp [if] [in] [, NSolic(varname) NPer(integer 24) Replace ENLaguna PROgreso ALTM]
	
	/* Verifica configuracion */
	_cc_check_config
	local enlaguna = length("`enlaguna'") > 0
	local progreso = length("`progreso'") > 0
	
	// Explorando nsolic
	tempvar nsolictouse
	if length("`nsolic'") == 0 qui gen `nsolictouse' = 0
	else qui gen `nsolictouse' = `nsolic' != .
	
	// Verificando si es que existe
	_cc_check_newvar `varname' `replace'
	
	/* Marcando muestra */
	marksample touse
	
	qui gen `varname' = .
	lab var `varname' "Promedio movil (`nper' meses) de la variable -`varname'-"
	
	if ("`altm'"=="") {
		#delimit ;
		mata: st_store(cc_range("`touse'"), "`varname'", 
			n_per_promedio(
				st_data(cc_range("`touse'"),"`exp'"),
				st_data(cc_range("`touse'"),"$CCPANEL"), 
				st_data(cc_range("`touse'"),"$CCPERIODO"),
				st_data(cc_range("`touse'"),"`nsolictouse'"),
				`nper',
				`enlaguna',
				`progreso'
				)
			);
		#delimit cr
	}
	else {
		#delimit ;
		mata: st_store(cc_range("`touse'"), "`varname'", 
			n_per_promedio2(
				st_data(cc_range("`touse'"),"`exp'"),
				st_data(cc_range("`touse'"),"$CCPANEL"), 
				st_data(cc_range("`touse'"),"$CCPERIODO"),
				st_data(cc_range("`touse'"),"`nsolictouse'"),
				`nper',
				`progreso'
				)
			);
		#delimit cr		
	}
end
