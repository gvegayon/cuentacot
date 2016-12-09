*! vers 1.13.10 14oct2013
*! auth: George G. Vega
*! Calcula pagos SC para una obsevacion
program def pagossci

	vers 11.0
	
	#delimit ;
	syntax anything [using/] [, 
		Replace Booktabs MATSave(name) TEXDoc Maxp(integer 12) 
		TFCSIndef(string) TCICIndef(string)
		TFCSPlazo(string) TCICPlazo(string)
		LIndef(string) LPlazo(string) TIempo(string)
		];
	#delimit cr
	
	tokenize `anything'
	local saldo `1'
	local renta `2'
	loca indef `3'
	loca derechofcs `4'
	
	if ("`idnef'" == "") local indef = 1
	if ("`derechofcs'" == "") local derechofcs = 0
	if ("`tiempo'"=="") local tiempo J(1,1,.)
	
	/* Chequeando matrices */
	foreach mat in lindef lplazo {
		if ("``mat''"=="") local `mat' J(0,0,.)
	}
	
	foreach vec in tfcsindef tcicindef tfcsplazo tcicplazo {
		if ("``vec''"=="") local `vec' J(0,1,.)
	}
	
	#delimit;
	mata: pagossc_print(
		`derechofcs', 
		`=`saldo'', 
		`=`renta'', 
		"`using'",
		`=length("`booktabs'")>0', 
		`=length("`replace'")>0',
		"`matsave'",
		`indef',
		`=length("`texdoc'")>0',
		`maxp',
		`tfcsindef',
		`tfcsplazo',
		`tcicindef',
		`tcicplazo',
		`lindef',
		`lplazo',
		`tiempo'
		);
	#delimit cr
end

mata:
void pagossc_print(
	real scalar derechofcs,
	real scalar saldo,
	real scalar renta,
	string scalar fname,
	real scalar booktabs,
	real scalar replace,
	string scalar matsave,
	real scalar indef,
	real scalar texdoc,
	real scalar maxp,
	real colvector tasas_fcs_indef,
	real colvector tasas_fcs_plazo,
	real colvector tasas_cic_indef,
	real colvector tasas_cic_plazo,
	real matrix limit_fcs_indef,
	real matrix limit_fcs_plazo,
	real scalar tiempo
) {
	
	class pagos_sc scalar output
	
	/* Importando matrices */
	if (tasas_fcs_indef==J(0,1,.)) tasas_fcs_indef = (.50\ .45\ .40\ .35\ .30);

	if (tasas_fcs_plazo==J(0,1,.)) tasas_fcs_plazo = (.35\ .30);
	
	if (tasas_cic_indef==J(0,1,.)) tasas_cic_indef = (.50\ .45\ .40\ .35\ .30);
	
	if (tasas_cic_plazo==J(0,1,.)) tasas_cic_plazo = (.35\ .30);
	
	if (limit_fcs_indef==J(0,0,.)) 
		limit_fcs_indef = 
				234794, 108747 \
				211315, 90211 \
				187835, 79089 \
				164356, 69204 \
				140877, 59317;
		
	if (limit_fcs_plazo==J(0,0,.)) 
		limit_fcs_plazo = 
				164356, 69204 \
				140877, 59317;
	

	// Calcula pagos
	if (indef) 
		output = pagossci(derechofcs, saldo, renta, 1, maxp,
			tasas_fcs_indef, limit_fcs_indef, tasas_cic_indef, tiempo)
	else
		output = pagossci(derechofcs, saldo, renta, 0, maxp,
			tasas_fcs_plazo, limit_fcs_plazo, tasas_cic_plazo, tiempo)
	
	// Exporta segun requisitos del usuario
	output.write_tex(fname, booktabs, replace, texdoc)
	
	if (matsave != "") {
		st_matrix(matsave, output.as_matrix())
				
		// Nombrando columnas		
		if (output.nfcs > 0) st_matrixcolstripe(matsave, (J(3,1,""),("fcs"\"cic"\"total")))
		else st_matrixcolstripe(matsave, (J(2,1,""),("cic"\"total")))
		
		// Nombrando filas
		st_matrixrowstripe(matsave, (J(output.ntot,1,""),strofreal(1::output.ntot)))
	}
}
end

/*
mata: x=calc_pagos(0,21000, 10000)

mata: x=calc_pagos(1,21000, 10000)

mata:x.write_tex("20130520_prueba",1, 1)
*/
