%working_directory(CWD,'/Users/carlos/Dropbox/Courseware_/L&KM/01/').
%[uno].
second([_|[H1|_]],H1). %Returns the head of the tail of the input
%\
removeLast1([H,_],[H]). %base case, if the input consists of two elements, return the head
removeLast1([H|T],L) :- %if the list consists on more the two elements 
	removeLast1(T,L1),  %call recursion on the tail
	append([H],L1,L).   %append the result with the head
	
removeLast2([H,_],[H]). %base case, if the input consists of two elements, return the head
removeLast2([H|T],[H|L1]) :-%if the list consists on more the two elements
	removeLast2(T,L1).	%call recursion on the tail and append the result with the head
	
replace([],_,_,[]).  %base case, the replace on an empty list is the empty list
replace([H|T],H,Y,[Y|L]) :-  % if X is the Head, replace and append the tail 
	replace(T,H,Y,L).   %call recursion on the tail for further appearance of X
replace([H|T],X,Y,[H|L]) :- % %if X is not the Head, append the result of the recursion.
	replace(T,X,Y,L). % look in the tail recursively
	
correspondence(X,[],X). %base case, correspondance with empty dictionary is the same
correspondence([H1|T1],[[E1,E2]|T2],R) :- % main call
	replace([H1|T1],E1,E2,RE), %replace call in the full list with the head of the dictionary
	correspondence(RE,T2,R). %recursive call in the tail of the dictionary

decompose([],[],[]). %base case, the empty list contains empty lists of positive and negative
decompose([H|T],[H|L1],L2) :- % call for positive and apend of the results in the correct list
	H > 0,  %The head is positive
	decompose(T,L1,L2). %recursive call on the tail
decompose([H|T],L1,[H|L2]) :- %call for nonpositive and append of the results  in the correct list
	H =< 0, %The head is nonpositive
	decompose(T,L1,L2). %recursive call in the tail

		
	
