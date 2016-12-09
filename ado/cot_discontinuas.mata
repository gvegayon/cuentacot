// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
real colvector cot_discontinuas(
	real colvector panel, 
	real colvector tiempo,
	real colvector nsolic
) 
{
	real colvector contador
	real scalar i
	
	// Vector de resultado
	contador = J(rows(panel),1,1)
	
	// Loop de obs 1 hasta obs N
	for(i=2;i<=rows(panel);i++)
	{	
		// Si es que es el mismo individuo, entra
		if (panel[i] == panel[i - 1])
		{
			// Verifica si es que la observacion actual no es solicitud
			if (nsolic[i] == 0 & nsolic[i - 1] == 0) 
				contador[i] = contador[i - 1] + ((tiempo[i] - tiempo[i - 1]) >= 1)
			else if (nsolic[i] == 0 & nsolic[i - 1] == 1)
				contador[i] = 1
			else 
				contador[i] = contador[i - 1]
		}
	}
	return(contador)
}
end
