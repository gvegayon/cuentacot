*! version 0.14.3  3mar2014
*! Ultimas N continuas con el mismo empleador
*! autor George G. Vega Yon
program def cccont_en_n_empl, sortpreserve

	vers 11.0

	syntax name(name=varname) [if] [in] , Empl(varname) [NSolic(varname) NPer(integer 24) Replace ENLaguna PROgreso]
	
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
	
	// Dandole el orden apropiado para utilizar cuentacot
	sort $CCPANEL `empl' $CCPERIODO, stable
	
	// Calculando
	qui gen `varname' = .
	lab var `varname' "Cuenta de cotizaciones continuas con el empleador en `nper' meses"

	#delimit ;
	mata: st_store(cc_range("`touse'"), "`varname'", 
		cot_continuas(
			st_data(cc_range("`touse'"),"$CCPANEL"), 
			st_data(cc_range("`touse'"),"$CCPERIODO"),
			st_data(cc_range("`touse'"),"`nsolictouse'"),
			st_data(cc_range("`touse'"),"`empl'")
			)
		);
	#delimit cr	
end
