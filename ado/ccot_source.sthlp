*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -cc_analizar_empl.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! cc_analizar_empl vers. 0.14.2
*! date 20feb2014
mata
{smcl}
*! {marker cc_analizar_empl}{bf:function -{it:cc_analizar_empl}- in file -{it:cc_analizar_empl.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -cc_analizar_empl.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -cot_continuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
mata:
{smcl}
*! {marker cot_continuas}{bf:function -{it:cot_continuas}- in file -{it:cot_continuas.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -cot_continuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -cot_discontinuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
{smcl}
*! {marker cot_discontinuas}{bf:function -{it:cot_discontinuas}- in file -{it:cot_discontinuas.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -cot_discontinuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_beneficios.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
/* Contador de numero de beneficios pagados en una ventana de tiempo
puede ser sobre -solicitudes- (cuenta_solic=1) o -giros- (cuenta_solic=0)
*/
mata:
{smcl}
*! {marker n_per_beneficios}{bf:function -{it:n_per_beneficios}- in file -{it:n_per_beneficios.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
real colvector n_per_beneficios(
    real colvector panel,     /* Id de persona */
    real colvector tiempo,    /* Variable de tiempo */
    real colvector nsolic,    /* Vector indicativo de solicitud o no */
    real scalar nper,         /* Tamano de la ventana */
    real scalar cuenta_solic, /* 1: Cuenta solicitudes, 0: Cuenta giros */    
    | real scalar enlaguna,
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
    contador = J(rows(panel),1,0)

    if (nsolic[1]) contador[1] = 1
    
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
        
        /* Si es que la actual es una solicitud/giro */
        if (nsolic[i]) contador[i] = 1
        
        /* Si es que el individuo anterior no es el mismo, continar */
        if (panel[i] != panel[i-1]) continue
        
        /* Obteniendo el indice de la ultima observacion valida */
        ultobsi = ultvalido(panel, tiempo, i, nper, nsolic, J(0,1,.), 0)
        
        /* Incrementando contador */
        j = i
        
        /* Si es sobre solicitudes */
        if (cuenta_solic)
        {
            while (ultobsi <= --j)
                contador[i] = contador[i] + (tiempo[j+1] != tiempo[j])*nsolic[j]
        }
        /* Si es que es sobre giros */
        else
        {
            while (ultobsi <= --j)
                contador[i] = contador[i] + nsolic[j]
        }
    }

    return(contador)

}
end
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_beneficios.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_cot_continuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// CONTADOR DE COTIZACIONES CONTINUAS EN N PERIODOS
mata:
{smcl}
*! {marker n_per_cot_continuas}{bf:function -{it:n_per_cot_continuas}- in file -{it:n_per_cot_continuas.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
real colvector n_per_cot_continuas(
    real colvector panel, 
    real colvector tiempo,
    real colvector nsolic,
    real scalar nper,
    | real scalar enlaguna,
    real scalar progreso) 
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
        {
            /* Si es que el tiempo no es continuo, ir al siguiente */
            if ((tiempo[j+1] - tiempo[j]) > 1) break
            
            contador[i] = contador[i] + (tiempo[j+1] != tiempo[j])
        }
    }
    
    return(contador)
    
}
end
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_cot_continuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_cot_continuas_empleador.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// CONTADOR DE COTIZACIONES N CONTINUAS con el mismo empleador
mata:
{smcl}
*! {marker n_per_cot_continuas_empleador}{bf:function -{it:n_per_cot_continuas_empleador}- in file -{it:n_per_cot_continuas_empleador.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
real colvector n_per_cot_continuas_empleador(
    real colvector panel, 
    real colvector tiempo,
    real colvector empleador,
    real colvector nsolic,
    real scalar nper,
    | real scalar enlaguna,
    real scalar progreso) 
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
    
        /* Si es que el individuo anterior no es el mismo, ir al siguiente  */
        if (panel[i] != panel[i-1]) continue
        
        /* Si es cambia de empleador  */
        if (empleador[i] != empleador[i-1] & !nsolic[i]) continue
        
        /* Si es que es una solicitud se repite el valor anterior */
        if (nsolic[i])
        {
            contador[i] = contador[i-1]
            continue
        }
        
        /* Obteniendo el indice de la ultima observacion valida */
        ultobsi = ultvalido(panel, tiempo, i, nper, nsolic, empleador)
        
        /* Incrementando contador */
        j = i
        while (ultobsi <= --j)
        {
            /* Si es que el tiempo no es continuo, ir al siguiente */
            if ((tiempo[j+1] - tiempo[j]) > 1) break
            
            contador[i] = contador[i] + (tiempo[j+1] != tiempo[j])
        }
    }
    return(contador)
    
}
end
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_cot_continuas_empleador.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_cot_discontinuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
{smcl}
*! {marker n_per_cot_discontinuas}{bf:function -{it:n_per_cot_discontinuas}- in file -{it:n_per_cot_discontinuas.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_cot_discontinuas.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_cot_discontinuas2.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}

mata

{smcl}
*! {marker n_per_cot_discontinuas2}{bf:function -{it:n_per_cot_discontinuas2}- in file -{it:n_per_cot_discontinuas2.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_cot_discontinuas2.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_promedio.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
{smcl}
*! {marker n_per_promedio}{bf:function -{it:n_per_promedio}- in file -{it:n_per_promedio.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_promedio.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -n_per_promedio2.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}

mata
{smcl}
*! {marker n_per_promedio2}{bf:function -{it:n_per_promedio2}- in file -{it:n_per_promedio2.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -n_per_promedio2.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -progress_bar.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// mata mata clear

mata

// Computes the number of events to be develop before each bar is
// drawn.
pointer(real vector) vector function _cc_progress_bar_set(
    real scalar nevents,
    | real scalar nbars
    )
{

    pointer(real vector) vector result;
    
    result = J(3,1,NULL)

    if (nbars == J(1,1,.)) nbars = 60;
    
    // Creating the pointer ouput
    result[1] = &max((round(nevents/nbars),2))     // Step size
    result[2] = &nevents                           // Total events
    result[3] = &min((nbars,nevents/(*result[1]))) // Total bars
    
    return(result)
}

// Prints a progress bar in the screen depending on previous calculations
// based on the -_progress_bar_set- function and on the number of the current
// iteration
{smcl}
*! {marker _cc_progress_bar}{bf:function -{it:_cc_progress_bar}- in file -{it:progress_bar.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
void function _cc_progress_bar(
    real scalar nevent,
    pointer(real vector) vector pb
    )
    {
    
    if (nevent==1) // If it is the first line
    {
        string scalar nbars;
        nbars = "{dup "+strofreal(round(*pb[3]/5 - 2))+":-}"
        display("0"+nbars+"20"+nbars+"40"+nbars+"60%"+nbars+"80"+nbars+"100%")
    }
    else if (nevent == *pb[2]) // If it is the last line
        printf("| Done.\n")
    else if (!mod(nevent,(*pb[1])) ) // If it is in the middle
        printf("|")

    // Ordering the buffer to print the progress
    displayflush()

}


// Example
/*nevents = 5000
pb = _cc_progress_bar_set(nevents)
for (i=1;i<=nevents;i++) {
    for (j=1;j<=10000;j++) x = 1+1
    _cc_progress_bar(i, pb)
}

*pb[1]
*pb[2]
*pb[3]*/

end

*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -progress_bar.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -saldo_cic.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
// CONTADOR DE COTIZACIONES DISCONTINUAS
mata:
{smcl}
*! {marker aldo_cic}{bf:function -{it:aldo_cic}- in file -{it:saldo_cic.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -saldo_cic.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -utils.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
mata:
/* ultvalido: Computa cual es el indice de la ultima observacion valida para la
cuenta de cotizaciones en una ventana de tiempo particular tomando en consideracion:
 - Variables panel y tiempo,
 - Numero de periodos,
 - Solicitudes
 - Empleador
 */
{smcl}
*! {marker ultvalido}{bf:function -{it:ultvalido}- in file -{it:utils.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
{smcl}
*! {marker cc_mark_lagunas}{bf:function -{it:cc_mark_lagunas}- in file -{it:utils.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
{smcl}
*! {marker cc_range}{bf:function -{it:cc_range}- in file -{it:utils.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
real colvector cc_range(string scalar mark)
{
    return(select(1::c("N"), st_data(.,mark)))
}
end

/* Arma vector de una variable en funcion de tiempo */
cap mata mata drop serie_tramos()
mata:

{smcl}
*! {marker erie_tramos}{bf:function -{it:erie_tramos}- in file -{it:utils.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
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
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -utils.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
