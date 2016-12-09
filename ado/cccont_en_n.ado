*! version 0.13.8.29  29ago2013
*! Ultimas N continuas
*! autor George G. Vega Yon
program def cccont_en_n
	
	vers 11.0

	syntax name(name=varname) [if] [in] [, NSolic(varname) NPer(integer 24) Replace ENLaguna PROgreso]
	
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
	
	// Calculando
	qui gen `varname' = .
	lab var `varname' "Cuenta de cotizaciones continuas en `nper' meses"
	#delimit ;
	mata: st_store(cc_range("`touse'"), "`varname'", 
		n_per_cot_continuas(
			st_data(cc_range("`touse'"),"$CCPANEL"), 
			st_data(cc_range("`touse'"),"$CCPERIODO"),
			st_data(cc_range("`touse'"),"`nsolictouse'"),
			`nper',
			`enlaguna',
			`progreso'
			)
		);
	#delimit cr	
end
