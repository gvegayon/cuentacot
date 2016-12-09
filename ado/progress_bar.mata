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

