*! version 0.14.2  20feb2014
*! Verifica configuracion de cuentacot2 (cc)
*! autor George G. Vega Yon
program define _cc_check_config
	vers 11.0
	
	// Chequeando que parallel este instalado
	cap findfile parallel.ado
	if (_rc) {
		di "-cuentacot- requiere de -parallel- para funcionar..."
		di "descargando de -ggvega.com-..."
		net install parallel, from(http://software.ggvega.com/stata) replace
		di "listo."
	}
	
	if (!length("$CCPANEL") & !length("$CCPERIODO")) {
		di as error "cuentacot2 no configurado -CCPANEL- ni -CCPERIODO-"
		error 1
	}
	else if (!length("$CCPANEL")) {
		di as error "cuentacot2 no configurado -CCPANEL-"
		error 1
	}
	else if (!length("$CCPERIODO")) {
		di as error "cuentacot2 no configurado -CCPERIODO-"
		error 1
	}
end
