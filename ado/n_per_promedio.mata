// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
real colvector n_per_promedio(
	real colvector variable, /* Variable para la cual calcular la media movil */
	real colvector panel,    /* Id de persona */
	real colvector tiempo,   /* Variable de tiempo */
	real colvector nsolic,   /* Vector indicativo de solicitud o no */
	real scalar nper,        /* Tamano de la ventana */
	|real scalar enlaguna,
	real scalar progreso
)
{
	real colvector promedio, marcalaguna
	real scalar i, j, k, ultobsi
	
	if (nsolic == J(0,1,.)) nsolic = J(length(panel),1,0)
	
	/* Si es que la cuenta es solo sobre lagunas */
	if (enlaguna == J(1,1,.)) enlaguna = 0
	marcalaguna = cc_mark_lagunas(enlaguna, panel, tiempo, nsolic)
	
	// Chequea si es que el usuario requirio barra de progreso
	if (progreso == 1) 
	{
		pointer(real scalar) vector pb
		pb = _cc_progress_bar_set(length(nsolic))
		_cc_progress_bar(1, pb)
	}
	else progreso = 0
	
	// Vector de resultado
	promedio = variable

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
			promedio[i] = promedio[i-1]
			continue
		}
		
		/* Obteniendo el indice de la ultima observacion valida */
		ultobsi = ultvalido(panel, tiempo, i, nper, nsolic)
		
		/* Incrementando contador */
		j = i
		k = 1
		while (ultobsi <= --j)
		{
			promedio[i] = promedio[i] + variable[j] 
			k=k+1
		}
		promedio[i] = promedio[i]/k
	}

	return(promedio)

}
end
