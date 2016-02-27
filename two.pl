%working_directory(CWD,'/Users/carlos/Desktop').
%[[1,2],[3,4],[5,6]]. 

%Tests wheter M is a matrix with the given contraints.
matrix(M) :- matrix(M,_). %Encapsulation
matrix([H],R) :-	%What is the length of the HEAD
	is_list(H), 	%Not to be fooled by non lists
	length(H,R).	%Gets the length of the HEAD
matrix([H|T],L2):-	%Are all the lengths of the rows equal?
	length(H,L1),	%Measures the length of the current row
	matrix(T,L2),	%calls recursively 
	L1==L2.			%Are they equal?
	

size([H|T],R,C) :- 	%To get the size of the matrix
	matrix([H|T]),	%Is it a proper matrix?
	length([H|T],R), %The number of rows,	
	length(H,C).	%Now we know that all the columns have the same number of elements, so we pick to measure the first.
	
rowI(M,I,RI) :- 	%To get the Ith row of the matrix
	matrix(M),		%Is it a matrix?
	nth1(I,M,RI).	%Gets the Ith element of the List.
	
columnJ(M,J,CJ) :-	%To get the Jth column of the Matrix
	matrix(M),		%Is it a matrix?
	maplist(nth1(J),M,CJ).	%Maps the function get Jth (indexed by 1) in the columns.
	
product(M1,M2,R) :-  	%Calculates the matrix product of M1 and M2
	matrix(M1),			%Is M1 a matrix?
	matrix(M2), 		%Is M2 a matrix?
    transpose(M2,T),	%Gets the transpose because it's easier to multiply in this way
    maplist(sprod(T),M1,R).	%As we can see we only need to map this product over the first matrix

sprod(T,M1,R) :-		%This product is the dot product of the columns of M1 times T, which can be demonstrated that carries the matrix multiplication in pieces, rather that summing over two indices (common way)
	maplist(dot(M1),T,R).	%in deed maps the dot product of the column of M1 to T

dot(V1,V2,R) :-			%Performs the dot product of the two lists (or vectors) V1 and V2.
	dot(V1,V2,0,R).		%Inicializes from zero.
dot([],[],R,R).			%Extreme case
dot([H1|V1],[H2|V2],T,R) :-	%General case
	T2 is T + H1 * H2,	%Multiplies and sums the accumulated
	dot(V1,V2,T2,R).	%And calls recursively

traceMatrix(M, T) :-	%Performs the sum of the diagonal of M,
	diagonal(M, D),		%convniently we will use the custom predicate diagonal
	sumlist(D, T).		%and sum its elements

diagonal(M, D) :-		%Gets the diagonal of M - Encapsulation
	diagonal(M, D, 1).	%Calls the general method
diagonal(M, [], I) :-	%Extreme case
	length(M, N),		%size
	I > N, !.			%If nonsquare, cut
diagonal(M, [CJ|D], I) :-	%General case
	nth1(I, M, RT),			%Ith element 
	nth1(I, RT, CJ),		
	I2 is I+1,				%Counter
	diagonal(M, D, I2).		%Call recursively

listFirst([], []).			%Gets the first element of a list representing a matrix
listFirst([[A|_]|L], [A|L2]) :-		%The first
	listFirst(L, L2).				%The first of the first

listFollowers([], []).				 %The list of lists of the tails of M
listFollowers([[_|F]|L], [F|L2]) :-	 %Gets the tails without heads
	listFollowers(L, L2).			%Recursively

decompose([], [], []).		%The tails of the forming lists
decompose([[A|F]|L], [A|L1], [F|L2]) :- 	%It will get the tails
	decompose(L, L1, L2).	%Recursively

transpose([], []).			%Calculates the tranpose of a matrix. Extreme case
transpose(M, []) :-			%Iniciatlization
	nil(M),	!.				%If M can unify with the empty list. (like null) then cut						
transpose(M, [D1|T]) :-		%General case
	decompose(M, D1, L),	%Using decompose
	transpose(L, T).		%Recursion

nil([]).					%Like Null
nil([[]|Z]) :- nil(Z).