// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
real colvector saldo_cic(
	real colvector panel,      /* Id de persona */
	real colvector tiempo,     /* Variable de tiempo */
	real colvector indef, 
	real colvector ingreso,
	| real colvector pago_cic,
	real colvector montoinicial,
	real scalar cot_indef,
	real scalar cot_plazo,
	real scalar rentabilidad,       /* Rentabilidad mensual del fondo */
	real colvector rentreal,
	real scalar comision,
	real matrix serie_cot_indef,    /* Mat. Serie de cotizaciones indef */
	real matrix serie_cot_plazo,    /* Mat. Serie de cotizaciones indef */
	real matrix serie_rentabilidad, /* Mat. Serie de rentabilidad */
	real matrix serie_comision      /* Mat. Serie de comisiones */
)
{
	real colvector saldo
	real colvector s_cot_indef, s_cot_plazo, s_rentabilidad, s_comision
	real scalar i, j, nmeses, N, ini
	
	N = length(panel)
	
	/* Variables en blanco */
	if (pago_cic  == J(0,1,.))    pago_cic     = J(N,1,0)
	if (montoinicial == J(0,1,.)) montoinicial = J(N,1,0)
	if (comision == J(1,1,.))     comision     = (1+0.006)^(1/12) - 1
	if (cot_indef == J(1,1,.))    cot_indef    = .006 + .016
	if (cot_plazo == J(1,1,.))    cot_plazo    = .028
	if (rentabilidad == J(1,1,.)) rentabilidad = 1.03^(1/12) - 1
	
	/* Armando series 
	Estas series se alimentan de, si es que existen, matrices que indican valores
	por periodo de tiempo, en particular, son matrices de nx2 donde la primera
	columna indica -tiempo- y la segunda el -valor- a asignar hasta ese periodo
	de tiempo. Estos valores se asignan a cada observacion utilizando la funcion
	-serie_tramos()-
	*/
	if (serie_cot_indef==J(0,0,.)) s_cot_indef = J(N,1,cot_indef)
	else s_cot_indef = serie_tramos(serie_cot_indef,tiempo)
	
	if (serie_cot_plazo==J(0,0,.)) s_cot_plazo = J(N,1,cot_plazo)
	else s_cot_plazo = serie_tramos(serie_cot_plazo,tiempo)
		
	if (serie_rentabilidad==J(0,0,.) & rentreal == J(0,1,.)) s_rentabilidad = J(N,1,rentabilidad)
	else if (serie_rentabilidad!=J(0,0,.) & rentreal == J(0,1,.)) s_rentabilidad = serie_tramos(serie_rentabilidad,tiempo)
	else s_rentabilidad = rentreal
	
	if (serie_comision==J(0,0,.)) s_comision = J(N,1,comision)
	else s_comision = serie_tramos(serie_comision,tiempo)
	
	/* Vector de resultado */
	saldo = J(N,1,0)

	/* Si es que renta es 0*/
	_editmissing(ingreso, 0)
	_editmissing(pago_cic, 0)
	
	saldo[1] = 
		ingreso[1]*(s_cot_indef[1]*indef[1] + s_cot_plazo[1]*(1-indef[1])) + 
		montoinicial[1]
	
	for(i=2;i<=N;i++)
	{		
		/* Checkea parallel */
		parallel_break()
		
		/* Si es que el individuo anterior no es el mismo, continar */
		if (panel[i] != panel[i-1]) {
			saldo[i] = 
				ingreso[i]*(s_cot_indef[i]*indef[i] + s_cot_plazo[i]*(1-indef[i])) +
				montoinicial[i]
			continue
		}
		
		/* Numero de meses transcurridos */
		nmeses = tiempo[i] - tiempo[i-1]

		//saldo=max(saldo[_n-1]*((1+`rent')^(mesn-mesn[_n-1]))*(1-`comis') + cotiz + aporte - egreso,0) if _n > 1 
		// if (i<100) s_comision[i],s_rentabilidad[i]
		saldo[i] = 
			max((
				(saldo[i-1])*                                                    /* Saldo actual       */
				((1+s_rentabilidad[i])^(nmeses))*(1-s_comision[i]) -             /* Rentabilidad       */ 
				pago_cic[i-1],0)) +                                              /* Pago de beneficios */
			ingreso[i]*(s_cot_indef[i]*indef[i] + s_cot_plazo[i]*(1-indef[i]))   /* Cotizacion         */
		
	}

	return(saldo)

}
end
