mata:
// Funcion para calcular los pagos
class pagos_sc scalar pagossci(
	real scalar derechofcs, 
	real scalar saldo,
	real scalar renta,
	| real scalar indef,
	real scalar maxp,         /* En el caso de CIC, el numero maximo de pagos que debe calcular */
	real colvector tasas_fcs,
	real matrix limites_fcs,
	real colvector tasas_cic,
	real scalar tiempo
	) 
	{
	
	real scalar i, maxpagos
	real scalar aporte_cic, aporte_fcs, aporte_tot
	class pagos_sc scalar pagos

	// Inicializando objetos
	if (indef == J(1,1,.)) indef = 1

	if (tiempo==J(1,1,.))
	{
		if (indef)
		{ // Si su contrato es indefinido
			if (tasas_fcs == J(0,1,.)) tasas_fcs = (.50\ .45\ .40\ .35\ .30);
			if (tasas_cic == J(0,1,.)) tasas_cic = (.50\ .45\ .40\ .35\ .30);
			
			if (limites_fcs == J(0,0,.)) 
				limites_fcs = 
					234794, 108747 \
					211315, 90211 \
					187835, 79089 \
					164356, 69204 \
					140877, 59317;
		}
		else
		{
			if (tasas_fcs == J(0,1,.)) tasas_fcs = (.35\ .30)
			if (tasas_cic == J(0,1,.)) tasas_cic = (.35\ .30)
			
			if (limites_fcs == J(0,0,.)) 
				limites_fcs = 
					164356, 69204 \
					140877, 59317;
		}
	}
	else asigna_tablas(tiempo, limites_fcs, indef)
	
	maxpagos = rows(tasas_fcs)
	
	if (!derechofcs) {
		i = 0
		while (saldo > 1) {
			if (++i < maxpagos) aporte_cic = floor(min((renta*tasas_cic[i], saldo)))
			else aporte_cic = floor(min((renta*tasas_cic[maxpagos],saldo)))
			
			// Recalculando saldo y agregando
			saldo = max((0, saldo - aporte_cic))
			
			/* Si es que esta en el ultimo pago, le suma el resto */
			if (i==maxp) 
			{
				aporte_cic = aporte_cic + saldo;
				saldo = 0;
			}
			
			pagos.cic = pagos.cic\aporte_cic
		}
	}
	else {
		i = 0
		while(++i<=maxpagos) {
			if (saldo > 0) {
				// Aporte cic
				aporte_tot = max((min((floor(renta*tasas_fcs[i]),limites_fcs[i,1])),limites_fcs[i,2]))
				aporte_cic = min((aporte_tot, saldo))
				
				// Aporte FCS
				saldo = saldo - aporte_cic
				aporte_fcs = aporte_tot - aporte_cic
			}
			else {
				aporte_cic = 0
				aporte_fcs = max((min((floor(renta*tasas_fcs[i]), limites_fcs[i,1])),limites_fcs[i,2]))
			}
			if (aporte_cic) pagos.cic = pagos.cic\aporte_cic			
			pagos.fcs = pagos.fcs\aporte_fcs
		}
	}
	
	// Actualizando suma y numero de pagos
	pagos.update()
	
	// Imprimiendo
	return(pagos)
}

/* Chequea extructura de las tablas */
real scalar check_tablas(real matrix tabla, real scalar eslimite)
{
	real scalar ncols;
	
	ncols = cols(tabla);
	if (eslimite)
	{
		if (ncols != 2) return(1)
		else return(0)
	}
	
	if (!eslimite)
	{
		if (ncols != 1) return(1)
		else return(0)
	}
}

/* Asigna tabla de limites de manera dinamica */
void asigna_tablas(
	real scalar fecha, 
	real matrix limites, 
	real scalar indef
)
{
	if (fecha<=528)
	{/* Vigencia 1/2/2002 al 31/1/2004 
	mata mofd(date("20040131", "YMD"))
	*/
		limites = 
			125000,65000\
			112500,54000\
			100000,46000\
			87500,38500\
			75000,30000
	}
	else if (fecha <= 540)
	{/*Vigencia 1/2/2004 al 31/1/2005
	mata modf(date("20050131", "YMD"))
	*/
		limites = 
			126340,65697\
			113706,54579\
			101072,46493\
			88348,38913\
			75804,30322
	}
	else if (fecha <= 552)
	{ /*Vigencia 1/2/2005 al 31/1/2006
	mata mofd(date("20060131", "YMD"))
	*/
		limites = 
			129408,67292\
			116467,55904\
			103526,47622\
			90586,39858\
			77645,31058
	}
	else if (fecha <= 564)
	{/*Vigencia 1/2/2006 al 31/1/2007
	mata mofd(date("20070131", "YMD"))
	*/
		limites =
			134149,69757\
			120734,57952\
			107319,49367\
			93904,41318\
			80489,32196
	}
	else if (fecha <= 576)
	{/*Vigencia 1/2/2007 al 31/1/2008
	mata mofd(date("20080131", "YMD"))
	*/
		limites =
			137594,71548\
			123834,59440\
			110075,50635\
			96315,42379\
			82556,33023
	}
	else if (fecha <= 588)
	{/*Vigencia 1/2/2008 al 31/1/2009
	mata mofd(date("20090131", "YMD"))
	*/
		limites =
			148360,77146\
			133523,64091\
			118687,54597\
			103851,45695\
			89015,35607
	}
	else if (fecha <= 600)
	{/*Vigencia 1/2/2009 al 31/1/2010
	mata mofd(date("20100131", "YMD"))
	*/
		limites =
			158882,82617\
			142993,68636\
			127105,58469\
			111216,48936\
			95328,38132
	}
	else if (fecha <= 612)
	{/*Vigencia 1/2/2010 al 31/1/2011
	mata mofd(date("20110131", "YMD"))
	*/
		limites =
			198691,92025\
			178822,76339\
			158953,66928\
			139084,58562\
			119215,50196
	}
	else if (fecha <= 624)
	{/*Vigencia 1/2/2011 al 31/1/2012
	mata mofd(date("20120131", "YMD"))
	*/
		limites =
			208024,96348\
			187222,79925\
			166419,70072\
			145617,61313\
			124815,52554
	}
	else if (fecha <= 636)
	{/*Vigencia 1/2/2012 al 31/1/2013
	mata mofd(date("20130131", "YMD"))
	*/
		limites =
			221024,102369\
			198922,84920\
			176819,74451\
			154717,65145\
			132615,55838
	}
	else 
	{/*Vigencia 1/2/2013 al 31/1/2014*/
		limites =
			234794, 108747\
			211315, 90211\
			187835, 79089\
			164356, 69204\
			140877, 59317
	}
	
	if (!indef) limites = limites[(rows(limites)-1)::rows(limites),]
	return
}
end

