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
	void print()
	void new()
	void update()
	void write_tex()
	real matrix as_matrix()
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
