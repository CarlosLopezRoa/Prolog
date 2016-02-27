elem(X, [X | _]). 
elem(X, [Y | L]) :- elem(X,L).
elem2(X, [X | _]). 
elem2(X, [Y | L]) :- X\=Y, 
	elem2(X,L).
elem3(X, [X | _]). 
elem3(X, [Y | L]) :- X\==Y, 
	elem3(X,L).
	
