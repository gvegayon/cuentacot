
mata

real colvector n_per_cot_discontinuas2(
	real colvector panel,
	real colvector tiempo,
	real colvector solicita,
	real scalar nper,
	| real scalar progreso
)
{
	real scalar i, j;
	real scalar N;
	real colvector cuenta;
	
	N = length(panel);
	
	// Chequea si es que el usuario requirio barra de progreso
	if (progreso == 1) 
	{
		pointer(real scalar) vector pb
		pb = _cc_progress_bar_set(N)
		_cc_progress_bar(1, pb)
	}
	else progreso = 0
	
	// Inicializando contadores
	cuenta = J(N,1,1);
	j    = 1; // j corresponde al ultimo indice valido
	for(i=2;i<=N;i++)
	{
		parallel_break()
		
		// Barra de progreso
		if (progreso == 1) _cc_progress_bar(i, pb)
		
		// Si es que no corresponde al panel
		if (panel[i]!=panel[i-1])
		{
			j    = i;
			continue;
		}
		
		// Si es que esta corresponde a una solicitud al SC, se repite el valor
		// del mes anterior
		if (solicita[i])
		{
			j=i+1; // El contador de periodos validos se setea en el siguiente
			cuenta[i]=cuenta[i-1];
			continue;
		}
		
		// no ha avanzado en tiempo
		if (tiempo[i]==tiempo[i-1])
		{
			cuenta[i]=cuenta[i-1];
			continue;
		}
		
		// Estableciendo cuenta nueva
		if (!solicita[i-1]) cuenta[i] = cuenta[i-1];
		else {
			cuenta[i] = 1;
			j=i;
			continue;
		}
		
		//printf("cuenta:%g tiempo[%g]:%g tiempo[%g]:%g", cuenta[i],i,tiempo[i],j,tiempo[j])
		// Ajustando
		if ((tiempo[i]-tiempo[j] + 1) <= nper) 
		{
			cuenta[i] = cuenta[i] + 1;
			//printf("\n")
		}
		else // if ((tiempo[i]-tiempo[j] + 1) > nper)
		{
			//printf("...entre\n")
			// Reajustando los periodos de tiempo
			while((tiempo[i]-tiempo[++j] + 1) > nper)
			{
				//printf("  cuenta:%g tiempo[%g]:%g tiempo[%g]:%g\n", cuenta[i],i,tiempo[i],j,tiempo[j])
				// Si es que corresponde a una solicitud, no corresponde
				// hacer nada (no ha sido considerada).
				if (solicita[j]) continue;
			
				// Se reajusta si y solo si la cotizacion no es una cotizacion
				// multiple (varias e un mes)
				if (tiempo[j-1]!=tiempo[j]) cuenta[i] = cuenta[i] - 1;
			}
		}

	}
	
	return(cuenta);
}

end
