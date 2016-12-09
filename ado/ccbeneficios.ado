*! version 0.13.8.29  29ago2013
*! Cuenta solicitudes/giros realizados en N
*! autor George G. Vega Yon
program def ccbeneficios
	
	vers 11.0

	syntax name(name=varname) [if] [in] , NSolic(varname) [NPer(integer 24) Giros Replace ENLaguna]
	
	/* Verifica configuracion */
	_cc_check_config
	local enlaguna = length("`enlaguna'") > 0
	
	/* Cuenta solicitudes o giros */
	local cuenta_solic = !length("`giros'")
	
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
	
	if (`cuenta_solic') lab var `varname' "Cuenta de solicitudes al SC en `nper' meses"
	else lab var `varname' "Cuenta de giros al SC en `nper' meses"
	
	#delimit ;
	mata: st_store(cc_range("`touse'"), "`varname'", 
		n_per_beneficios(
			st_data(cc_range("`touse'"),"$CCPANEL"), 
			st_data(cc_range("`touse'"),"$CCPERIODO"),
			st_data(cc_range("`touse'"),"`nsolictouse'"),
			`nper',
			`cuenta_solic',
			`enlaguna'
			)
		);
	#delimit cr	
end
