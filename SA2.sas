proc power;                                                                                                                             
  twosamplesurvival test=logrank                                                                                                        
    curve("control")  = 1:0.91                  
    refsurvival = "control"                                                                                                               
    hazardratio = 0.3 to 0.8 by .005                                                                                                                    
    accrualtime = 2                                                                                                                       
    followuptime = 4 
    groupweights = 1 | 1 
    power = .9                                                                                                                           
    ntotal = .;                                                                                                                           
plot x = effect; 
run;

/*Problem 2 */
/*A*/

proc phreg data=timp.burn_treatments;
class treatment(ref='Standard');
model Days*Infection(0) = Treatment;
hazardratio treatment;
run;

/*B and C*/
proc phreg data=timp.burn_treatments;
class treatment(ref='Standard');
model Days*Infection(0) = Treatment Treatment*Area;
run;

/*D*/

proc phreg data=timp.burn_treatments;
class treatment(ref='Standard') excision(ref='Yes');
model Days*Infection(0) = Treatment Excision;
hazardratio excision;
run;

proc phreg data=timp.burn_treatments;
class treatment(ref='Standard') excision(ref='Yes') Days_to_Excision;
model Days*Infection(0) = Treatment Ex;
Ex=0;
if Days > Days_to_Excision and Days_to_Excision ne . then Ex=1;
hazardratio treatment;
hazardratio Ex;
run;

/*Question 3*/
/*A*/
proc sort data= timp.dialysis_infections out=acute;
by method;
where subtype EQ 'Acute nephritis';
run;
ods graphics on;
proc lifetest data=acute plots=s;
strata method;
time days*infection(0);
run;
ods graphics off;

proc sort data= timp.dialysis_infections out=Glomerulo;
by method;
where subtype EQ 'Glomerulo nephritis';
run;
ods graphics on;
proc lifetest data=Glomerulo plots=s;
strata method;
time days*infection(0);
run;
ods graphics off;

proc sort data= timp.dialysis_infections out=Polycystic;
by method;
where subtype EQ 'Polycystic kidney disease';
run;
ods graphics on;
proc lifetest data=Polycystic plots=s;
strata method;
time days*infection(0);
run;
ods graphics off;

proc sort data= timp.dialysis_infections out=Other;
by method;
where subtype EQ 'Other';
run;
ods graphics on;
proc lifetest data=Other plots=s;
strata method;
time days*infection(0);
run;
ods graphics off;



/*B and C*/
proc phreg data= timp.dialysis_infections;
class method subtype;
strata subtype;
model days*Infection(0)= age method;
hazardratio age;
hazardratio method;
run;

/*D*/
proc phreg data= timp.dialysis_infections;
class method subtype;
model days*Infection(0)= subtype*method age;
hazardratio method;
run;

/*F*/
proc phreg data= timp.dialysis_infections;
class method subtype;
model days*Infection(0)= subtype*method age;
hazardratio method;
ModelDvsModelB: test subtype*method = method = 0;
run;

/*Question 4 */
/*A*/
ods graphics on;
proc lifetest data=timp.nephrectomy_outcomes plots=cif;
strata type;
time Years*Censor(0) / eventcode=1;
run;
ods graphics off;
/*C*/
ods graphics on;
proc lifetest data=timp.nephrectomy_outcomes plots=cif;
strata type;
time Years*Censor(0) / eventcode=2;
run;
ods graphics off;
