seikibunpu(n)={
	local(c,d,i);
	
	c=0;
	
	for(i=1,n,
		d=random(2);
		if(d==0,c=c-1,c=c+1);
	);
	return(c);
}

gauss(p,sig,x)={
	local(c,i);
	
	c=0;
	
	for(i=-1,1,
		c=c+exp(-1/2*(x+i*p)^2/sig^2);
	);
	
	return(c);
}

gaussrand_bak(p,sig)={
	local(b,c,d,x,total,i,r);
	
	total=0;
	
	b=vector(p);
	c=vector(p);
	for(x=0,p-1,
		b[x+1]=gauss(p,sig,x);
		total=total+b[x+1];
		\\print(x","g);
	);
	
	c[1]=b[1]/total;
	
	for(i=2,p-1,
		c[i]=c[i-1]+b[i]/total;
	);
	c[p]=1.;
	
	\\print(c);
	
	r=random(1.);
	d=-1;
	for(i=1,p,
		if(r<=c[i] && d==-1, d=i-1);
	);
	
	return(d);
}


gaussrand_list(p,sig)={
	local(b,c,x,total,i,r);
	
	total=0;
	
	b=vector(p);
	c=vector(p);
	for(x=0,p-1,
		b[x+1]=gauss(p,sig,x);
		total=total+b[x+1];
		\\print(x","g);
	);
	
	c[1]=b[1]/total;
	
	for(i=2,p-1,
		c[i]=c[i-1]+b[i]/total;
	);
	c[p]=1.;
	
	return(c);
}

gaussrand(rand_list)={
	local(c,d,i,r);
	
	c=rand_list;
	
	r=random(1.);
	d=-1;
	for(i=1,p,
		if(r<=c[i] && d==-1, d=i-1);
	);
	if (d > (p-1)/2,
        d = d - p;
    	);
	return(d);
}

print_sum(m)={
	local(str);
	str = Str("minimize\n");
	str = concat(str,"z1");
	for(i=2,m+1,
		str = concat(str," + z");
		str = concat(str, Str(i));
	);
	str = concat(str,"\n");
	return(str);
}


print_constraints(W,U,n,m,p)={
	local(str);
	str = "Subject To\n";
	for(i=1,m-n,
		str = concat(str,"c");
		str = concat(str,Str(i));
		str = concat(str,": ");
		for(j=1,n,
			str = concat(str,Str(W[j,i]));
			str = concat(str," x");
			str = concat(str,Str(j));
			if(j-n,
				str = concat(str," + ");,
	
				str = concat(str," -x");
				str = concat(str,Str(n+i));
				str = concat(str," + ");
				str = concat(str,Str(p));
				str = concat(str," y");
				str = concat(str,Str(i));
				str = concat(str," = ");
				str = concat(str,Str(U[i]));
				str = concat(str,"\n");
			);
		);
	);
	return(str);
}

print_constraints2()={
	local(str);
	str = "";
	a = 0;
	for(i = n+1,m+n,
		str = concat(str,"c");
		str = concat(str,Str(i+a));
		str = concat(str,": ");
		str = concat(str,"z");
		str = concat(str,Str(i-n));
		str = concat(str," - x");
		str = concat(str,Str(i-n));
		str = concat(str," > 0");
		str = concat(str,"\n");
		a = a + 1;
		str = concat(str,"c");
		str = concat(str,Str(i+a));
		str = concat(str,": ");
		str = concat(str,"z");
		str = concat(str,Str(i-n));
		str = concat(str," + x");
		str = concat(str,Str(i-n));
		str = concat(str," > 0");
		str = concat(str,"\n");
	);
	return(str);
}


/*
print(print_constraints(W,U,10,20,21));
*/

print_x_bounds(m)={
	local(str);
	str = Str("bounds\n");
	for(i=1,m+1,
		str = concat(str,"x");
		str = concat(str,Str(i));
		str = concat(str," free\n");
	);
	return(str);
}

print_y_bounds(n)={
	local(str);
	str = "";
	for(i=1,n,
		str = concat(str,"y");
		str = concat(str,Str(i));
		str = concat(str," free\n");
	);
	return(str);
}


print_ranges(m,hanni)={
	local(str);
	str = "";
	str = Str("bounds\n");
	for(i=1,m,
		str = concat(str,"-");
		str = concat(str,Str(hanni));
		str = concat(str,"< ");
		str = concat(str,"x");
		str = concat(str,Str(i));
		str = concat(str," <");
		str = concat(str,Str(hanni));
		str = concat(str,"\n");
	);
	return(str);
}

/*
print(print_bounds(10));
*/

print_generals(n,m)={
	local(str);
	str = Str("general\n");
	for(i=1,m,
		str = concat(str,"x");
		str = concat(str,Str(i));
		str = concat(str," ");
		if(i-m,
			str = concat(str,"");,
			for(j=1,n,
				str = concat(str,"y");
				str = concat(str,Str(j));
				if(j-n,
					str=concat(str," ");,
					for(k=1,m,
						str = concat(str," z");
						str = concat(str,Str(k));
					);
				);
			);
		);
	);
	str = concat(str,"\n");
	return(str);
}

/*
print(print_generals(3,6));
*/

{
	setrand(20250117);
	n = 3;
	m = 6;
/*	p = nextprime(n*n); */
	p = nextprime(1000);
	h = 2;
/*	sig = 0.7; */
/*	sig = 0.000217 * p; */
	sig = 1.6;

	W = matrix(n,m-n,i,j,0);
	
/*
	W = matid(n);
*/


/*
«—v‘f‚Éƒ[ƒ‚ª‚È‚­‚È‚é‚æ‚¤ˆ—
	for(i=1,n,
		for(j=1,n,
			if(W[i,j],,
				c = random(p);
				W[i,j] = p-c+1
			);
		);
	);

*/


	for(i=1,n,
		for(j=1,n,
			if(i-j,,
				c = random(p);
				W[j,j] = p-c+1;
/*
				if(n-j,
				c = random(p);
				W[j,j+1] = p-c+1;,
				);
*/
			);
		);
	);



	print("W‚Í"W);

 	A0 = matrix(n,n,i,j,random(p));
	A1 = matrix(n,m-n,i,j,random(p));
	A1 = A0 * W;
	A1 = A1 % p;

	A = concat(A0,A1);
/*	print("A‚Í"A); */


	s=vector(n,i,1);
	e=vector(m,i,1);

	rand_list=gaussrand_list(p,sig);
	check = 0;
/*
	A = qflll(A);
	A = A%p;
	A = mattranspose(A);
	for (i=1,n,
	  for (j=1,m,
	    if (A[i,j] == 0,
	      A[i,j] = 1
	    )
	  )
	);
*/

	/*
	Z = matrix(22, 11);
	A = concat(A, Z);
	*/

	for(i=1,n,
		s[i]=random(p);
	);
	for(i=1,m,e[i]=gaussrand(rand_list));

	e_max = max(abs(e[1]),abs(e[2]));
	for(i=3,m,
		e_max = max(e_max,abs(e[i]));
	);

	hanni = e_max;

	T=s*A+e;
	T=T%p;

/*
	A0 = A[, 1..n];
	A1 = A[, n+1..m];
*/

	t0 = vector(n,i,T[i]);
	t1 = vector(m-n,i,T[n+i]);

	e0 = vector(n,i,e[i]);
	e1 = vector(m-n,i,e[n+i]);

/*
	A0_inv = A0 ^ -1;

	W = A0_inv * A1;
	W = W%p;
*/

	
	U = (t0 * W)-t1;
	U=U%p;
/*	print(U); */

	objective = "";
	objective = concat(objective,print_sum(m));

	constraints = print_constraints(W,U,n,m,p);
	constraints2 = print_constraints2();

/*	bounds = print_bounds(m); */
	bounds1 = print_ranges(m,hanni);
/*	bounds1 = print_x_bounds(m); */
	bounds2 = print_y_bounds(n); 
/*	bounds2 = print_ranges(m,hanni); */
	bounds = concat(bounds1,bounds2);
	generals = print_generals(n,m);
	end = "end";

	lp_content = "";
	lp_content = concat(lp_content,objective);
	lp_content = concat(lp_content,constraints);
	lp_content = concat(lp_content,constraints2);
	lp_content = concat(lp_content,bounds);
	lp_content = concat(lp_content,generals);
	lp_content = concat(lp_content,end);

	write("problem3.lp", lp_content);
/*	print(lp_content); */
	fileopen("from_PARI_3.csv","w");
	filewrite(0, e);
	fileclose(0);
/*	print("e‚Í"e); */
	print("e‚Ìabsmax"e_max);

}