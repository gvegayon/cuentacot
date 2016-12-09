mata:
/* ultvalido: Computa cual es el indice de la ultima observacion valida para la
cuenta de cotizaciones en una ventana de tiempo particular tomando en consideracion:
 - Variables panel y tiempo,
 - Numero de periodos,
 - Solicitudes
 - Empleador
 */
real scalar ultvalido(
	real colvector panel,
	real colvector tiempo,
	real scalar i,
	real scalar nper,
	| real colvector nsolic,
	real colvector emp,
	real scalar solic_reset /* Dicotomica, 1: Reiniciar cuenta frente a solicitudes, 0: No reinicial cuenta */
)
{
	/* Definicion de variables */
	real scalar j, meses
	j = i
	if (nsolic      == J(0,1,.)) nsolic      = J(length(panel),1,0)
	if (emp         == J(0,1,.)) emp         = J(length(panel),1,0)
	if (solic_reset == J(1,1,.)) solic_reset = 1
	
	/* Si es que llego a la primera obs */
	if (j==1) return(j)

	/* Decrece j mientras se encuentre en el mismo panel */
	while (panel[i] == panel[--j])
	{
		/* Compara con ventana de tiempo */
		meses = tiempo[i] - tiempo[j]
	
		/* Si es que llego a otro empleador */
		if (emp[i] != emp[j])   return(j + 1)
		/* Si es que llego a una solicitud */
		else if (nsolic[j] & solic_reset)
			return(j + 1)
		/* Si es que llego a la primera obs, esta tiene tratamiento especial.
		Esto se debe a problemas observados durante el desarrollo del modulo */
		else if (j == 1)
        {
			if (meses >= nper)  return(j + 1)
			else                return(j)
		}
		
		/* Si es que supero el numero de meses */
		else if (meses > nper)  return(j + 1)
		
		/* Si es que Calza justo el numero de meses */
		else if (meses == nper) return(j + 1)
		
		/* Si es que falta */
		else if (meses < nper)  continue
	}
	/* Al retorno se le suma 1 pues, si salio del while es porque se encontro con
	un individuo diferente en el panel */
	return(j + 1)
}
end


mata:
/* cc_mark_lagnas: Marca con 1 si es que es laguna (se incluye en calculo)
 */
real colvector cc_mark_lagunas(
	real scalar marcar,
	|real colvector panel,
	real colvector tiempo,
	real colvector nsolic
)
{
	real scalar i
	real colvector marca
	
	/* Si es que requiere marcar las lagunas */
	if (marcar) 
	{
		marca = J(length(panel),1,0)
		
		marca[1] = 1
		for(i=2;i<=length(panel);i++)
		{
			/* Si es que esta dentro del panel */
			if (panel[i] == panel[i-1])
				/* Si es que hay laguna */
				if (((tiempo[i] - tiempo[i-1]) > 1) | nsolic[i])
					marca[i-1] = 1
		}
	} /* Caso contrario */
	else marca = J(length(panel),1,1)

	return(marca)
}

end

/* Obtiene subset de variables que indica */
mata:
real colvector cc_range(string scalar mark)
{
	return(select(1::c("N"), st_data(.,mark)))
}
end

/* Arma vector de una variable en funcion de tiempo */
cap mata mata drop serie_tramos()
mata:

real matrix serie_tramos(
	real matrix descrip,
	real colvector panel
)
{
	/* Asignando variable */
	real colvector output
	real scalar i,j,tmpt,tmpv
	
	output = J(length(panel),1,.)
	
	for(i=1;i<=rows(descrip);i++)
	{
		tmpt = descrip[i,1]
		tmpv = descrip[i,2]
		for(j=1;j<=length(panel);j++)
			if (panel[j] <= tmpt & output[j] == .) output[j]=tmpv
	}
	return(output)
}
end


mata: serie_tramos((3,.7\.,.5),1::10)
