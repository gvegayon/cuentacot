
mata
real colvector n_per_promedio2(
	real colvector variable, /* Variable para la cual calcular la media movil */
	real colvector panel,    /* Id de persona */
	real colvector tiempo,   /* Variable de tiempo */
	real colvector nsolic,   /* Vector indicativo de solicitud o no */
	real scalar nper,        /* Tamano de la ventana */
	|real scalar progreso
)
{
	real colvector promedio
	
	real scalar i, j, ntot
	real scalar N
	
	N = length(panel)
	
	// Chequea si es que el usuario requirio barra de progreso
	if (progreso == 1) 
	{
		pointer(real scalar) vector pb
		pb = _cc_progress_bar_set(N)
		_cc_progress_bar(1, pb)
	}
	else progreso = 0
	
	// Inicializando contadores
	promedio = variable
	ntot     = 1
	
	// j corresponde al ultimo indice valido
	j = 1
	for(i=2;i<=N;i++)
	{
		parallel_break()
		
		// Barra de progreso
		if (progreso == 1) _cc_progress_bar(i, pb)
				
		// Si es que no corresponde al panel
		if (panel[i]!=panel[i-1])
		{
			j    = i
			ntot = 1
			continue
		}
		
		// Si es que esta corresponde a una solicitud al SC, se repite el valor
		// del mes anterior
		if (nsolic[i])
		{
			j=i+1 // El contador de periodos validos se setea en el siguiente
			promedio[i]=promedio[i-1]
			continue
		}
		
		// no ha avanzado en tiempo, entonces se ajusta el promedio
		if (tiempo[i]==tiempo[i-1])
		{
			promedio[i]= (promedio[i-1]*ntot + variable[i])/(ntot + 1)
			ntot = ntot + 1
			continue;
		}
		
		// Estableciendo promedio nuevo
		if (nsolic[i-1])
		{	
			promedio[i] = variable[i]
			ntot = 1
		}
		else 
		{
			promedio[i] = (promedio[i-1]*ntot + variable[i])/(ntot + 1)
			ntot = ntot+1
		}
		
		// Ajustando
		
		// Reajustando los periodos de tiempo
		while((tiempo[i]-tiempo[j] + 1) > nper)
		{
			// Si es que corresponde a una solicitud, no corresponde
			// hacer nada (no ha sido considerada).
			if (nsolic[j]) 
			{
				j = j + 1
				continue;
			}
		
			promedio[i] = (promedio[i]*ntot - variable[j])/(ntot - 1);
			ntot = ntot-1
			j = j + 1
		}
	}
	
	return(promedio);
}

end
