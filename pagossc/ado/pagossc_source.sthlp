*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -pagos_sc.class.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
mata:

// Definicion de clase
class pagos_sc {
    // Vectores
    real colvector cic
    real colvector fcs
    real colvector tot
    
    // Constants
    real scalar ncic
    real scalar nfcs
    real scalar ntot
    
    // Funciones
{smcl}
*! {marker print}{bf:function -{it:print}- in file -{it:pagos_sc.class.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
    void print()
{smcl}
*! {marker new}{bf:function -{it:new}- in file -{it:pagos_sc.class.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
    void new()
{smcl}
*! {marker update}{bf:function -{it:update}- in file -{it:pagos_sc.class.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
    void update()
{smcl}
*! {marker write_tex}{bf:function -{it:write_tex}- in file -{it:pagos_sc.class.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
    void write_tex()
{smcl}
*! {marker as_matrix}{bf:function -{it:as_matrix}- in file -{it:pagos_sc.class.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
    real matrix as_matrix()
{smcl}
*! {marker origen_n_pagos}{bf:function -{it:origen_n_pagos}- in file -{it:pagos_sc.class.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
    real scalar origen_n_pagos()
}

// Define objeto nuevo
void pagos_sc::new() {
    cic = J(0,1,.)
    fcs = J(0,1,.)
    tot = J(0,1,.)
    
    ncic = J(1,1,.)
    nfcs = J(1,1,.)
    ntot = J(1,1,.)
}

// Actualiza suma de los pagos
void pagos_sc::update() {
    real scalar i
    
    ncic = rows(select(cic, cic:!=0))
    nfcs = rows(select(fcs, fcs:!=0))

    tot = J(0,1,.)
    for(i=1;i<=min((rows(cic),rows(fcs)));i++) {
        tot = tot \ (cic[i]+fcs[i])
    }
    
    if (rows(cic) < rows(fcs)) {
        for(i=(rows(cic)+1);i<=rows(fcs);i++) {
            tot = tot \ fcs[i]
        }
    }
    else {
        for(i=(rows(fcs)+1);i<=rows(cic);i++) {
            tot = tot \ cic[i]
        }
    }
    
    ntot = rows(tot)
}

// Imprime tabla de pagos en formato latex
void pagos_sc::write_tex(|string scalar fname, real scalar booktabs, real scalar replace, real scalar texdoc) {
    
    real scalar i, fh
    string scalar toprule, midrule, bottomrule
    string scalar lines
    
    if (replace == J(1,1,.)) replace = 0
    if (texdoc == J(1,1,.)) texdoc = 0
    
    if (booktabs == J(1,1,.) | booktabs == 1) {
        toprule = "\\toprule"
        midrule = "\\midrule"
        bottomrule = "\\bottomrule\n"
    }
    else {
        toprule = "\\hline"
        midrule = "\\hline"
        bottomrule = "\\hline\n"
    }

    if (rows(fcs) > 0) lines = sprintf("%s N & Monto FCS & Monto CIC & Total \\\\\\\\ %s", toprule, midrule)
    else lines = sprintf("%s N & Monto CIC & Total \\\\\\\\ %s", toprule, midrule)
    for(i=1;i<=ntot;i++) {
        if (nfcs > 0) {
            if (rows(cic) >= i & rows(fcs) >= i)
                lines=lines+sprintf("\n%3.0f & %9,0fc & %9,0fc & %9,0fc\\\\\\\\ ", i, fcs[i], cic[i], tot[i])
            else if (rows(cic) < i & rows(fcs) >= i)
                lines=lines+sprintf("\n%3.0f & %9,0fc & %9,0fc & %9,0fc\\\\\\\\ ", i, fcs[i], 0, tot[i])
            else if (rows(cic) >= i & rows(fcs) < i)
                lines=lines+sprintf("\n%3.0f & %9,0fc & %9,0fc & %9,0fc\\\\\\\\ ", i, 0, cic[i], tot[i])
        }
        else {
            lines=lines+sprintf("\n%3.0f & %9,0fc & %9,0fc\\\\\\\\ ", i, cic[i], tot[i])
        }
    }
    if (rows(fcs) > 0) lines = lines+sprintf("\n%s & & Total & %9,0fc \\\\\\\\", midrule, sum(tot))+bottomrule
    else lines = lines+sprintf("\n%s & Total & %9,0fc \\\\\\\\", midrule, sum(tot))+bottomrule
    printf(lines)
    
    // Escribe el archivo en un tex
    if (fname != J(1,1,"") & fname != "") {
        fname = strtrim(fname)
        if (!regexm(fname, "\.tex$")) fname=fname+".tex"
    
        if (fileexists(fname)) {
            if (replace) unlink(fname)
            else _error(1)
        }
        fh = fopen(fname, "w")
        fwrite(fh, sprintf(lines))
        fclose(fh)
        display(sprintf("{text:El archivo fue creado con exito y guardado en %s}\n", fname))
    }
    else if (texdoc) { // Si es que desea incluirlo en un archivo de tex con texdoc
        if (strlen(st_global("TeXdoc_docname"))) {
            fh = fopen(st_global("TeXdoc_docname"), "a")
            fwrite(fh, sprintf(lines))
            fclose(fh)
        }
        else {
            _error(499, "Texdoc no inicializado")
        }
    }
}

// Indica numero de pagos extraidos de CIC/FCS
real scalar pagos_sc::origen_n_pagos(real scalar npagos, string scalar fuente) {
    // Mixtos
    real scalar mixtos
    mixtos = ncic + nfcs - length(tot)
    if (fuente == "fcs") {
        if (npagos < (ntot - nfcs)) return(0)
        else return(min((npagos - (ntot - nfcs),nfcs)))
    }
    else if (fuente == "cic") {
        if (npagos < ncic) return(npagos)
        else return(ncic)
    }
    else if (fuente == "mixto") {
        if (mixtos > 0) return(mixtos)
        else return(0)
    }
    else return(-1)
}

// Convertir en matriz
real matrix pagos_sc::as_matrix() {
    if (rows(fcs) == 0) return((cic,tot))
    else return((fcs,(cic\J(rows(fcs)-rows(cic),1,0)),tot))
}

// Funcion para imprimir en pantalla los pagos
void pagos_sc::print() {
    real scalar i
    
    printf("Pagos CIC\n")
    for(i=1;i<=rows(cic);i++) {
        printf("%3.0f %9.0f\n", i, cic[i])
    }
    
    printf("Pagos FCS\n")
    for(i=1;i<=rows(fcs);i++) {
        printf("%3.0f %9.0f\n", i, fcs[i])
    }
    
    printf("Pagos TOT\n")
    for(i=1;i<=ntot;i++) {
        printf("%3.0f %9.0f\n", i, tot[i])
    }
    printf("Beneficio total %9.0f\n", sum(tot))
}
end
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -pagos_sc.class.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:Beginning of file -pagossci.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
mata:
// Funcion para calcular los pagos
class pagos_sc scalar pagossci(
    real scalar derechofcs, 
    real scalar saldo,
    real scalar renta,
    | real scalar indef,
    real scalar maxp,         /* En el caso de CIC, el numero maximo de pagos que debe calcular */
    real colvector tasas_fcs,
    real matrix limites_fcs,
    real colvector tasas_cic,
    real scalar tiempo
    ) 
    {
    
    real scalar i, maxpagos
    real scalar aporte_cic, aporte_fcs, aporte_tot
    class pagos_sc scalar pagos

    // Inicializando objetos
    if (indef == J(1,1,.)) indef = 1

    if (tiempo==J(1,1,.))
    {
        if (indef)
        { // Si su contrato es indefinido
            if (tasas_fcs == J(0,1,.)) tasas_fcs = (.50\ .45\ .40\ .35\ .30);
            if (tasas_cic == J(0,1,.)) tasas_cic = (.50\ .45\ .40\ .35\ .30);
            
            if (limites_fcs == J(0,0,.)) 
                limites_fcs = 
                    234794, 108747 \
                    211315, 90211 \
                    187835, 79089 \
                    164356, 69204 \
                    140877, 59317;
        }
        else
        {
            if (tasas_fcs == J(0,1,.)) tasas_fcs = (.35\ .30)
            if (tasas_cic == J(0,1,.)) tasas_cic = (.35\ .30)
            
            if (limites_fcs == J(0,0,.)) 
                limites_fcs = 
                    164356, 69204 \
                    140877, 59317;
        }
    }
    else asigna_tablas(tiempo, limites_fcs, indef)
    
    maxpagos = rows(tasas_fcs)
    
    if (!derechofcs) {
        i = 0
        while (saldo > 1) {
            if (++i < maxpagos) aporte_cic = floor(min((renta*tasas_cic[i], saldo)))
            else aporte_cic = floor(min((renta*tasas_cic[maxpagos],saldo)))
            
            // Recalculando saldo y agregando
            saldo = max((0, saldo - aporte_cic))
            
            /* Si es que esta en el ultimo pago, le suma el resto */
            if (i==maxp) 
            {
                aporte_cic = aporte_cic + saldo;
                saldo = 0;
            }
            
            pagos.cic = pagos.cic\aporte_cic
        }
    }
    else {
        i = 0
        while(++i<=maxpagos) {
            if (saldo > 0) {
                // Aporte cic
                aporte_tot = max((min((floor(renta*tasas_fcs[i]),limites_fcs[i,1])),limites_fcs[i,2]))
                aporte_cic = min((aporte_tot, saldo))
                
                // Aporte FCS
                saldo = saldo - aporte_cic
                aporte_fcs = aporte_tot - aporte_cic
            }
            else {
                aporte_cic = 0
                aporte_fcs = max((min((floor(renta*tasas_fcs[i]), limites_fcs[i,1])),limites_fcs[i,2]))
            }
            if (aporte_cic) pagos.cic = pagos.cic\aporte_cic            
            pagos.fcs = pagos.fcs\aporte_fcs
        }
    }
    
    // Actualizando suma y numero de pagos
    pagos.update()
    
    // Imprimiendo
    return(pagos)
}

/* Chequea extructura de las tablas */
{smcl}
*! {marker check_tablas}{bf:function -{it:check_tablas}- in file -{it:pagossci.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
real scalar check_tablas(real matrix tabla, real scalar eslimite)
{
    real scalar ncols;
    
    ncols = cols(tabla);
    if (eslimite)
    {
        if (ncols != 2) return(1)
        else return(0)
    }
    
    if (!eslimite)
    {
        if (ncols != 1) return(1)
        else return(0)
    }
}

/* Asigna tabla de limites de manera dinamica */
{smcl}
*! {marker asigna_tablas}{bf:function -{it:asigna_tablas}- in file -{it:pagossci.mata}-}
*! {back:{it:(previous page)}}
*!{dup 78:{c -}}{asis}
void asigna_tablas(
    real scalar fecha, 
    real matrix limites, 
    real scalar indef
)
{
    if (fecha<=528)
    {/* Vigencia 1/2/2002 al 31/1/2004 
    mata mofd(date("20040131", "YMD"))
    */
        limites = 
            125000,65000\
            112500,54000\
            100000,46000\
            87500,38500\
            75000,30000
    }
    else if (fecha <= 540)
    {/*Vigencia 1/2/2004 al 31/1/2005
    mata modf(date("20050131", "YMD"))
    */
        limites = 
            126340,65697\
            113706,54579\
            101072,46493\
            88348,38913\
            75804,30322
    }
    else if (fecha <= 552)
    { /*Vigencia 1/2/2005 al 31/1/2006
    mata mofd(date("20060131", "YMD"))
    */
        limites = 
            129408,67292\
            116467,55904\
            103526,47622\
            90586,39858\
            77645,31058
    }
    else if (fecha <= 564)
    {/*Vigencia 1/2/2006 al 31/1/2007
    mata mofd(date("20070131", "YMD"))
    */
        limites =
            134149,69757\
            120734,57952\
            107319,49367\
            93904,41318\
            80489,32196
    }
    else if (fecha <= 576)
    {/*Vigencia 1/2/2007 al 31/1/2008
    mata mofd(date("20080131", "YMD"))
    */
        limites =
            137594,71548\
            123834,59440\
            110075,50635\
            96315,42379\
            82556,33023
    }
    else if (fecha <= 588)
    {/*Vigencia 1/2/2008 al 31/1/2009
    mata mofd(date("20090131", "YMD"))
    */
        limites =
            148360,77146\
            133523,64091\
            118687,54597\
            103851,45695\
            89015,35607
    }
    else if (fecha <= 600)
    {/*Vigencia 1/2/2009 al 31/1/2010
    mata mofd(date("20100131", "YMD"))
    */
        limites =
            158882,82617\
            142993,68636\
            127105,58469\
            111216,48936\
            95328,38132
    }
    else if (fecha <= 612)
    {/*Vigencia 1/2/2010 al 31/1/2011
    mata mofd(date("20110131", "YMD"))
    */
        limites =
            198691,92025\
            178822,76339\
            158953,66928\
            139084,58562\
            119215,50196
    }
    else if (fecha <= 624)
    {/*Vigencia 1/2/2011 al 31/1/2012
    mata mofd(date("20120131", "YMD"))
    */
        limites =
            208024,96348\
            187222,79925\
            166419,70072\
            145617,61313\
            124815,52554
    }
    else if (fecha <= 636)
    {/*Vigencia 1/2/2012 al 31/1/2013
    mata mofd(date("20130131", "YMD"))
    */
        limites =
            221024,102369\
            198922,84920\
            176819,74451\
            154717,65145\
            132615,55838
    }
    else 
    {/*Vigencia 1/2/2013 al 31/1/2014*/
        limites =
            234794, 108747\
            211315, 90211\
            187835, 79089\
            164356, 69204\
            140877, 59317
    }
    
    if (!indef) limites = limites[(rows(limites)-1)::rows(limites),]
    return
}
end

*! {smcl}
*! {c TLC}{dup 78:{c -}}{c TRC}
*! {c |} {bf:End of file -pagossci.mata-}{col 83}{c |}
*! {c BLC}{dup 78:{c -}}{c BRC}
