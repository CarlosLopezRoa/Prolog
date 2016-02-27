concat([],Y,Y).
concat(X,Y,Z) :- 
	X=[H1|T1],
	concat(T1,Y,Z1),
	Z=[H1|Z1].
	
remove(_,[],[]).
remove(X,[X|T],Z) :-
	remove(X,T,Z).
remove(X,[H | T],[H|Z]) :-
	X\=H,
	remove(X,T,Z).

myreverse([X],[X]).	
myreverse([H1|T1],Y) :-
	myreverse(T1,Z),
	append(Z,[H1],Y).