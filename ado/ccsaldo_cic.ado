*! version 0.13.10.10  10oct2013
*! Saldo en cuenta CIC
*! autor George G. Vega Yon
program def ccsaldo_cic
	
	vers 11.0

	#delimit ;
	syntax 
		name(name=varname) [if] [in] , 
		INGreso(varname) INDefinido(varname) 
		[Montocic(varname) Replace COTIndef(real .022) COTPlazo(real 0.028)
		RENTabilidad(real 0.00246627) COMision(real 0.0005)
		SALDOInicial(varname) MATCOTIndef(string) MATCOTPlazo(string)
		MATRENTabilidad(string) MATCOMision(string) real
		];
	#delimit cr
	
	/* Verifica configuracion */
	_cc_check_config
	
	// Explorando nsolic
	if (!length("`montocic'")) {
		tempvar montocic
		qui gen `montocic' = 0
	}
	
	// Explorando saldo inicla
	if (!length("`saldoinicial'")) {
		tempvar saldoinicial
		qui gen `saldoinicial' = 0
	}
	
	/* Chequeando valores de matrices */
	if ("`matcotindef'"=="") local matcotindef J(0,0,.)
	if ("`matcotplazo'"=="") local matcotplazo J(0,0,.)
	if ("`matrentabilidad'"=="") local matrentabilidad J(0,0,.)
	if ("`matcomision'"=="") local matcomision J(0,0,.)
	
	// Verificando si es que existe
	_cc_check_newvar `varname' `replace'
	
	/* Marcando muestra */
	marksample touse
	
	/* Verificando si quiere usar rentabilidad real */
	if (length("`real'")) {
		_pega_renta
		local varrenta = r(real)
		local rentreal st_data(cc_range("`touse'"), "`varrenta'")
	}
	else local rentreal J(0,1,.)
	
	// Calculando
	qui gen `varname' = .
	lab var `varname' "Saldo CIC estimado"
	#delimit ;
	mata: st_store(cc_range("`touse'"), "`varname'", 
		saldo_cic(
			st_data(cc_range("`touse'"),"$CCPANEL"), 
			st_data(cc_range("`touse'"),"$CCPERIODO"),
			st_data(cc_range("`touse'"),"`indefinido'"),
			st_data(cc_range("`touse'"),"`ingreso'"),
			st_data(cc_range("`touse'"),"`montocic'"),
			st_data(cc_range("`touse'"),"`saldoinicial'"),
			`cotindef',
			`cotplazo',
			`rentabilidad',
			`rentreal',
			`comision',
			`matcotindef',
			`matcotplazo',
			`matrentabilidad',
			`matcomision'
			)
		);
	#delimit cr
	if ("`real'"!="J(0,1,.)" & length("`real'")) drop `varrenta'
end

program def _pega_renta, rclass

	vers 11.0
	
	local curyear = regexr(c(current_date), "[0-9]* [a-zA-Z]* ","")
	local rand = "v"+strofreal(`=10000+int((20000-10000)*runiform())')
	
	gen `rand'orden = _n
	
	forval i=2002/`curyear' {
		qui valcuofon_afc , a(`i') s(`rand'`i')
	}
	
	/* Apendiando y guardando */
	preserve
	
	use valor_cuota_cic fecha using `rand'2002, clear
	rm `rand'2002.dta
	forval i = 2003/`curyear' {
		append using `rand'`i', keep(valor_cuota_cic fecha)
		rm `rand'`i'.dta
	}
	compress
	
	/* Calculando la media movil para suavizar */ 
	movavg valor_cuota_cic2 = valor_cuota_cic, lag(12)
	drop valor_cuota_cic
	ren valor_cuota_cic2 valor_cuota_cic
	
	/* Dejando solo lo que corresponde */
	sort fecha
	gen mes = mofd(fecha)
	bysort mes (fecha): keep if _n == _N
	
	drop if valor_cuota_cic == .
	
	/* Convirtiendo a valores reales */
	local renta = "v"+strofreal(`=1000+int((2000-1000)*runiform())')
	pesos_reales `renta' = valor_cuota_cic, tiempo(mes) mensual(201212)
	drop valor_cuota_cic
	
	/* Calculando rentabilidad */
	gen `renta'2 = .
	replace `renta'2 = `renta'/`renta'[_n-1] - 1 if `renta'[_n - 1] != .
	drop `renta'
	ren `renta'2 `renta'
	
	cap ren mes $CCPERIODO
	
	keep `renta' $CCPERIODO
	save `rand'datos, replace
		
	restore

	/* Pegando con valores */
	merge m:1 $CCPERIODO using `rand'datos, keep(1 3) nogen
	rm `rand'datos.dta
	
	sort `rand'orden
	drop `rand'orden
	
	cap drop copiarenta
	clonevar copiarenta = `renta'
	
	return local real `renta'

end
