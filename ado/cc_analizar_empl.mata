*! cc_analizar_empl vers. 0.14.2
*! date 20feb2014
mata
real colvector function cc_analizar_empl(
	real colvector panel,
	real colvector empl,
	| real scalar progreso
	)
{
	real scalar i, j, k, cuenta, N
	real colvector resultado
	real matrix tmpids, tmpids0

	N = length(panel);
	
	tmpids    = J(N,2,.)
	tmpids0   = tmpids
	resultado = J(N,1,.)

	// Chequea si es que el usuario requirio barra de progreso
	if (progreso == 1) 
	{
		pointer(real scalar) vector pb
		pb = _cc_progress_bar_set(N)
		_cc_progress_bar(1, pb)
	}
	else progreso = 0

	j            = 0
	resultado[1] = j
	tmpids[1,]   = (j,empl[1])
	cuenta       = 1
	for(i=2;i<=N;i++)
	{
	
		parallel_break()
		
		// Barra de progreso
		if (progreso == 1) _cc_progress_bar(i, pb)
	
		// Chequeando que corresponda a la misma persona
		if (panel[i] == panel[i-1])
		{
			if (empl[i] == empl[i-1]) resultado[i] = j
			else // Si es que no coincide con el empleador actual
			{
				for(k=1;k<=cuenta;k++)
				{
					// En el caso de que encuentra el match
					if (tmpids[k,2] == empl[i])
					{
						resultado[i] = k
						j = k
						break
					} // En el caso de que no logra encontrar nada
					else if (tmpids[k,1] != empl[i] & k == cuenta)
					{
						j = ++cuenta - 1
						resultado[i] = j
						tmpids[j,] = (j,empl[i])
						break
					}
				}
			}
		}
		else
		{
			// Reinicializando para siguiente persona
			cuenta       = 1
			j            = 0
			resultado[i] = 0
			tmpids       = tmpids0
			tmpids[1,]   = (j, empl[i])
			continue
		}
	}
	
	return(resultado)
}
end
