*! version 0.14.2  20feb2014
*! Asigna ids a empleadores partiendo por -0- de forma independiente
*! entre individuos.
*! autor George G. Vega Yon
program def ccanalizaempl

	vers 11.0

	syntax name(name=varname) [if] [in] , Empl(varname) [Replace]
	
	/* Verifica configuracion */
	_cc_check_config
	
	// Verificando si es que existe
	_cc_check_newvar `varname' `replace'
	
	/* Marcando muestra */
	marksample touse
	
	// Calculando
	qui gen `varname' = 0
	lab var `varname' "Numero (id) de empleador dentro del individuo"
	
	capture {
		bysort $CCPANEL (`empl'): replace `varname' = `varname'[_n-1] + (`empl'[_n-1] != `empl') if _n > 1
		sort $CCPANEL $CCPERIODO `empl'
	}

end
