*! vers 1.13.10 14oct2013
*! auth: George G. Vega
*! Calcula pagos SC para una N observaciones
program def pagossc
	
	vers 11.0

	#delimit ;
	syntax varlist(min=2 max=4 numeric) [if] [in] [, Prefix(name) 
		Replace Maxp(integer 12) 
		TFCSIndef(string) TCICIndef(string)
		TFCSPlazo(string) TCICPlazo(string)
		LIndef(string) LPlazo(string) TIempo(varname)
		];
	#delimit cr
	
	/* Chequeando que parallel este instalado */
	cap findfile parallel.ado
	if (_rc) {
		di "-cnu- requiere de -parallel- para funcionar..."
		di "descargando de -ssc-..."
		ssc install parallel
		di "listo."
	}
	
	local replace = length("`replace'") > 0
	
	tokenize `varlist'
	loca saldo `1'
	loca renta `2'
	loca indef `3'
	loca derechofcs `4'
	
	/* Chequeando variables no especificadas */
	if ("`tiempo'"=="") local tiempo J(0,1,.)
	else local tiempo st_data(.,"`tiempo'")
	
	if (!length("`indef'")) {
		tempvar indef
		qui gen `indef' = 1
	}
	if (!length("`derechofcs'")) {
		tempvar derechofcs
		qui gen `derechofcs' = 0
	}
	
	if (!length("`prefix'")) local prefix pagos
	
	/* Chequeando matrices */
	foreach mat in lindef lplazo {
		if ("``mat''"=="") local `mat' J(0,0,.)
	}
	
	foreach vec in tfcsindef tcicindef tfcsplazo tcicplazo {
		if ("``vec''"=="") local `vec' J(0,1,.)
	}
	
	/* Marcando muestra */
	marksample touse
		
	#delim ;
	mata: pagossc(
		st_data(.,"`saldo'"), 
		st_data(.,"`renta'"), 
		st_data(.,"`indef'"), 
		st_data(.,"`derechofcs'"), 
		st_data(.,"`touse'"),
		`replace',
		`maxp',
		"`prefix'",
		`tfcsindef',
		`tfcsplazo',
		`tcicindef',
		`tcicplazo',
		`lindef',
		`lplazo',
		`tiempo'
		);
	#delim cr
end

mata:
void pagossc(
	real colvector saldo,
	real colvector renta,
	real colvector indef,
	real colvector derechofcs,
	real colvector touse,
	real scalar replace,
	real scalar maxp,
	string scalar prefix,
	real colvector tasas_fcs_indef,
	real colvector tasas_fcs_plazo,
	real colvector tasas_cic_indef,
	real colvector tasas_cic_plazo,
	real matrix limit_fcs_indef,
	real matrix limit_fcs_plazo,
	real colvector tiempo
)
{
	// Definiendo variables
	real scalar i, nfcs, ncic;
	string scalar tmpname;
	string rowvector varnames_fcs, varnames_cic;
	class pagos_sc scalar output;
	real idx;
	
	/* Chequeando tiempo */
	if (tiempo == J(0,1,.)) tiempo = J(1,rows(saldo),.)
	
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
	
	varnames_fcs = J(1,0,"")
	varnames_cic = J(1,0,"")
	
	for(i=1;i<=rows(saldo);i++)
	{	
		/* Verifica si se ha presionado la tecla break (parallel) */
		parallel_break()
				
		/* Si es que no se incluye en el calculo, pasa al siguiente */
		if (!touse[i]) continue
		
		// Largo actual de las variables
		nfcs = length(varnames_fcs)
		ncic = length(varnames_cic)
				
		// Calcula pagos
		if (indef[i]) 
			output = pagossci(derechofcs[i], saldo[i], renta[i], 1, maxp,
				tasas_fcs_indef, limit_fcs_indef, tasas_cic_indef, tiempo[i])
		else
			output = pagossci(derechofcs[i], saldo[i], renta[i], 0, maxp,
				tasas_fcs_plazo, limit_fcs_plazo, tasas_cic_plazo, tiempo[i])
		
		
		
		// Checkeando numero de variables
		while (length(output.fcs) > length(varnames_fcs))
		{
			tmpname = prefix+"fcs"+strofreal(length(varnames_fcs)+1)
			
			varnames_fcs = varnames_fcs, tmpname
			if ((idx=_st_addvar("float", tmpname))<0)
			{
				if (replace) 
				{
					stata("cap drop "+tmpname)
					(void) st_addvar("float", tmpname)
				}
				else exit(error(-idx))
			}
		}
		while (length(output.cic) > length(varnames_cic))
		{
			tmpname = prefix+"cic"+strofreal(length(varnames_cic)+1)
			varnames_cic = varnames_cic, tmpname
			if ((idx=_st_addvar("float", tmpname))<0)
			{
				if (replace) 
				{
					stata("cap drop "+tmpname)
					(void) st_addvar("float", tmpname)
				}
				else exit(error(-idx))
			}
		}
		
		// Agregando pagos
		nfcs = length(varnames_fcs) - length(output.fcs)
		ncic = length(varnames_cic) - length(output.cic)
		
		if (nfcs) st_store(i, varnames_fcs, (output.fcs', J(1,nfcs,.)))
		else st_store(i, varnames_fcs, output.fcs')
		
		if (ncic) st_store(i, varnames_cic, (output.cic', J(1,ncic,.)))
		else st_store(i, varnames_cic, output.cic')
	}	
	
	if (nfcs) stata("qui order "+prefix+"fcs* "+prefix+"cic*, last")
	else stata("qui order "+prefix+"cic*, last ")
}
	
	
end
