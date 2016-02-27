length2([],0).
length2([_|L],X) :- length2(L,Y), X is Y+1.


longestList(L,M) :- longestList_sofar(L,M,[]).

longestList_sofar([],M,M).
longestList_sofar([H|L],X,M):-
	length2(H,S1),
	length2(M,S2),
	S1>S2,
	!,
	longestList_sofar(L,X,H).
longestList_sofar([_|L],X,M) :-
	longestList_sofar(L,X,M).