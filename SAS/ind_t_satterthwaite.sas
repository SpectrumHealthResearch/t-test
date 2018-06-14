/******************************************************************************
Independent samples t test with Satterthwaite adjusted degrees of freedom

Paul W. Egeler, M.S., GStat

16 Aug 2017

Reference: 
P.V. Rao. (2007). Statistical Research Methods in the Life Sciences. pp 139-140 
ISBN-13: 978-0-495-41422-3
ISBN-10:     0-495-41422-0
******************************************************************************/
%macro ind_t_satterthwaite(x_1, s_1, x_2, s_2, n_1, n_2, tails = 2 /* Choose: U, L, 2 */);
data _null_;

x_1=&x_1; s_1=&s_1; 
x_2=&x_2; s_2=&s_2; 
n_1=&n_1; n_2=&n_2;

x_d = x_1 - x_2;
se = sqrt(s_1**2 / n_1 + s_2**2 / n_2);

k_inv = 
	(s_1**2 / n_1 / (s_1**2 / n_1 + s_2**2 / n_2))**2 / (n_1 - 1)
  + (s_2**2 / n_2 / (s_1**2 / n_1 + s_2**2 / n_2))**2 / (n_2 - 1);

/*nu = floor(1/k_inv);*/
nu = 1/k_inv;

t_calc = x_d / se;

%if &tails. eq 2 %then %do;

	p = cdf("T",abs(t_calc) * -1,nu) * 2;

%end;
%else %if &tails. eq  U %then %do;

	p = cdf("T",1 - t_calc,nu);

%end;
%else %do;

	p = cdf("T",t_calc,nu);
	
%end;

hbar1 = repeat("=",80);
hbar2 = repeat("-",80);
hbar3 = repeat("*",80);
file print;

put hbar3;
put "Independent samples t test";
put "with Satterthwaite adjusted degrees of freedom";
put hbar3;

put "Summary statistics:";
put hbar1;
put "Sample 1";
put x_1= s_1= n_1= ;
put hbar2;
put "Sample 2";
put x_2= s_2= n_2=;
put ;

put "Analysis:";
put hbar1;
put x_d=;
put se=;
put t_calc=;
put nu=;
put p=;


run;
%mend ind_t_satterthwaite;
