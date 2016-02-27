and1(0,0,0).
and1(0,1,0).
and1(1,0,0).
and1(1,1,1).

or1(0,0,0).
or1(1,0,1).
or1(0,1,1).
or1(1,1,1).

not1(0,1).
not1(1,0).

xor1(0,0,0).
xor1(0,1,1).
xor1(1,0,1).
xor1(1,1,0).

nand1(0,0,1).
nand1(1,0,1).
nand1(0,1,1).
nand1(0,0,0).

circuit(X,Y,Z) :- nand1(X,Y,T1),
	not1(X,T2),
	xor1(T1,T2,T3),
	not1(T3,Z).