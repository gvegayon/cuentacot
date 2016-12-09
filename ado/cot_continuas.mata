mata:
real colvector cot_continuas(
	real colvector panel, 
	real colvector tiempo,
	real colvector nsolic,
	| real colvector emp
) 
{
	real colvector contador
	real scalar i
	
	// Vector de resultado
	contador = J(rows(panel),1,1)
	
	if (emp == J(0,1,.)) emp = J(rows(panel),1,1)
	
	// Loop de obs 1 hasta obs N
	for(i=2;i<=rows(panel);i++)
	{
	
		// Si es que es el mismo individuo, entra
		if (panel[i] == panel[i - 1])
		{
			/* Verifica si es solicitud */
			if (nsolic[i])
			{
				contador[i] = contador[i-1]
				continue
			}
			
			// Verifica si es el mismo empledor
			if (emp[i] != emp[i-1])
			{
				contador[i] = 1
				continue
			}
		
			// Verifica que sea continua
			if ((tiempo[i] - tiempo[i - 1]) == 1)
			{
				/* Verifica si viene saliendo de una solicitud */
				if ((nsolic[i] == 0) & (nsolic[i - 1] == 1)) continue 
				else contador[i] = contador[i - 1] + 1
			}
			else if (tiempo[i] == tiempo[i - 1]) contador[i] = contador[i - 1]
		}
	}
	return(contador)
}
end
