// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
real colvector n_per_cot_discontinuas(
	real colvector panel,  /* Id de persona */
	real colvector tiempo, /* Variable de tiempo */
	real colvector nsolic, /* Vector indicativo de solicitud o no */
	real scalar nper,      /* Tamano de la ventana */
	|real scalar enlaguna,
	real scalar progreso
)
{
	real colvector contador, marcalaguna
	real scalar i, j, ultobsi
	
	if (nsolic == J(0,1,.)) nsolic = J(length(panel),1,0)
	
	/* Si es que la cuenta es solo sobre lagunas */
	if (enlaguna == J(1,1,.)) enlaguna = 0
	marcalaguna = cc_mark_lagunas(enlaguna, panel, tiempo, nsolic)
	
	// Vector de resultado
	contador = J(rows(panel),1,1)
	
		// Chequea si es que el usuario requirio barra de progreso
	if (progreso == 1) 
	{
		pointer(real scalar) vector pb
		pb = _cc_progress_bar_set(length(panel))
		_cc_progress_bar(1, pb)
	}
	else progreso = 0

	for(i=2;i<=length(panel);i++)
	{
	
		parallel_break()
		
		// Barra de progreso
		if (progreso == 1) _cc_progress_bar(i, pb)
	
		/* Si es que no se cuenta en la laguna, pasa al siguiente i */
		if (!marcalaguna[i]) continue
	
		/* Si es que el individuo anterior no es el mismo, continar */
		if (panel[i] != panel[i-1]) continue
		
		/* Si es que es una solicitud se repite el valor anterior */
		if (nsolic[i])
		{
			contador[i] = contador[i-1]
			continue
		}
		
		/* Obteniendo el indice de la ultima observacion valida */
		ultobsi = ultvalido(panel, tiempo, i, nper, nsolic)
		
		/* Incrementando contador */
		j = i
		while (ultobsi <= --j)
			contador[i] = contador[i] + (tiempo[j+1] != tiempo[j])
	}

	return(contador)

}
end
