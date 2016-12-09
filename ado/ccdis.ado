*! version 0.13.8.29  29ago2013
*! Cotizaciones discontinuas
*! autor George G. Vega Yon
program def ccdis

	vers 11.0

	syntax name(name=varname) [if] [in] [, NSolic(varname) Replace]
	
	/* Verifica configuracion */
	_cc_check_config
	
	// Explorando nsolic
	tempvar nsolictouse
	if length("`nsolic'") == 0 qui gen `nsolictouse' = 0
	else qui gen `nsolictouse' = `nsolic' != .
	
	// Verificando si es que existe
	_cc_check_newvar `varname' `replace'
	
	/* Marcando muestra */
	marksample touse
	
	// Calculando
	qui gen `varname' = .
	lab var `varname' "Cuenta de cotizaciones discontinuas"
	#delimit ;
	mata: st_store(cc_range("`touse'"), "`varname'", 
		cot_discontinuas(
			st_data(cc_range("`touse'"),"$CCPANEL"), 
			st_data(cc_range("`touse'"),"$CCPERIODO"),
			st_data(cc_range("`touse'"),"`nsolictouse'")
			)
		);
	#delimit cr	
end
