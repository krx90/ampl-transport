set ORIG;
#origins

set DEST;
#destinations

set PROD;
#products

param supply {ORIG,PROD} >= 0;
#amount available at origins larger than zero

param demand {DEST,PROD} >= 0;
	check {p in PROD}:
		sum {i in ORIG} supply[i,p] = sum {j in DEST} demand [j,p];
#amounts required at destinations greater than zero
#checks if the sum of supply is equal to sum of demand

param limit {ORIG,DEST} >= 0;
#l.20
#maximum shipments on routes

param minload >= 0;
#minimum load parameter must be greater than zero 

param maxserve integer > 0;
#maximum of destinations serves must be larger than zero 

param vcost {ORIG,DEST,PROD} >= 0;
#variable shipment cost on routes has to be greater than zero

var Trans {ORIG,DEST,PROD} >= 0;
#units to be shipped has to be greater than zero

param fcost {ORIG,DEST} >= 0;
#fixed cost per route has to be greater than zero 

var Use {ORIG,DEST} binary;
#binary values if a route is used 

minimize Total_Cost:
	sum {i in ORIG, j in DEST, p in PROD} vcost[i,j,p] * Trans[i,j,p]
+	sum {i in ORIG, j in DEST} fcost[i,j] * Use[i,j];
subject to Supply {i in ORIG, p in PROD}:
	sum {j in DEST} Trans[i,j,p] = supply[i,p];
subject to Max_Serve {i in ORIG}:
	sum {j in DEST} Use[i,j] <= maxserve;
subject to Demand {j in DEST, p in PROD}:
	sum {i in ORIG} Trans[i,j,p] = demand[j,p];
subject to Multi {i in ORIG, j in DEST}:
	sum {p in PROD} Trans[i,j,p] <= limit[i,j] * Use [i,j];
subject to Min_Ship {i in ORIG, j in DEST}:
	sum {p in PROD} Trans[i,j,p] >= minload * Use[i,j];