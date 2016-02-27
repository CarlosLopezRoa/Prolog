%working_directory(CWD,'/Users/carlos/Desktop').

%%% Ex1 %%% 

% <command> ::= <instruction>
% 
% <instruction> ::= cal <args1>
% <instruction> ::= cat <args2>  
% <instruction> ::= cp <file> <target> | cp <opt3> <file> <target> | 
% 				  cp <opt3> <file> <file2> <target> | cp <file> <file2> <target> 
% <instruction> ::= grep <expr> | grep -<opt4> <expr> | grep -<opt4e> <expr> | grep -<opt4> -<opt4e> <expr> | grep <expr> <file2> | grep -<opt4> <expr> <file2> | grep -<opt4e> <expr> <file2> | grep -<opt4> -<opt4e> <expr> <file2>
% 
% 
% <args1> ::= <month> | <year> | <month> <year> | " "
% <month>	::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12
% <year> 	::= 1 | 2 | … | 9998 | 9999 
% 
% <args2>	::= -<opt2> <file> | -<opt2> | <file> | " "
% <opt2> 	::= n | b | s | u | v | e | t
% 
% <opt3>  ::= <opt31> | <opt32>* | <opt31> <opt32>*
% <opt31> ::= -r | -R
% <opt32> ::= -f | -i | -p 
% <file2> ::= <file>*
% 
% <opt4>  ::= b | c | i | h | l | n | b | s | y
% <opt4e> ::= e
% 



%%% Ex2 %%%

% Reads a character recursively from the prompt and stops when encounters the new line character. 

read_command([C | L]) :- 
	get0(C),
	C \== 10 ,
	!,
	read_command(L).
read_command([10]).	


%%% Ex3

% The predicate parse/1 calls the previous read_command/1 but also applies pattern matching to the resulting ASCII list .

% It enmascarates the predicate parse/2
parse(C) :-
	read_command(M),
	parse(C,M).

% Pattern matching in the ASCII list.
parse(C,M) :-
	isc1(C,M);
	isc2(C,M);
	isc3(C,M);
	isc4(C,M).

% When the first elements of the list coincide with the ASCII for 'cal', then it converts the ASCII to string, then splits the string into a list of strings and applies the cases.
isc1(E,M) :-
	compare_list([99,97,108],M),
	name(S,M),
	split_string(S,' ','\n',C),
	c1cases(C,E).

%The case when calling 'cal' with both arguments, parses both arguments to numbers in the desired range.
c1cases(["cal",X,Y],calendar(X1,Y1)) :-
	atom_number(X,X1),
	atom_number(Y,Y1),
	integer(X1),
	integer(Y1),
	between(1,12,X1),
	between(1,9999,Y1).

%When calling 'cal' with just one argument, parses the argument into a number in the desired range.
c1cases(["cal",Y],calendar(Y1)) :-
	atom_number(Y,Y1),
	integer(Y1),
	between(1,9999,Y1).
	
%When calling 'cal' with no arguments, it returns the current month and year.
c1cases(["cal"],calendar(X,Y)) :-
	monthyear(X,Y).
	
%When the first elements of the list coincide with the ASCII for 'cat', the it converts the ASCII to string, then splits the string into a list of strings and applies the cases.	
isc2(E,M) :-
	compare_list([99,97,116],M),
	name(S,M),
	split_string(S,' ','\n',C),
	c2cases(C,E).

%When the command 'cat' is called without arguments.	
c2cases(["cat"],concatenate(option_list,file_list)). 		

%When calling 'cat' with options but no file argument, parses the options to a list starting with minus (-) and containing only the desired letters. 
c2cases(["cat",X],concatenate(X,file_list)) :-
	sub_string(X,0,1,_,"-"),
	string(X),
	string_chars(X,L),
	ismembers(L,[-,n, b, s, u, v, e, t]).

%When calling 'cat' with only the file argument. Parses the file argument to a string which do not starts with minus (-), it handles the case when the file argument is a list.	
c2cases(["cat"|T],concatenate(option_list,T)):-
	nth0(0,T,R),
	string_chars(R,S),
	nth0(0,S,S1),
	S1 \== (-).

%When calling 'cat' with both arguments, it parses the option argument to a list which starts with minus (-) and contains only the desired letters. Also it handles file arugment and parses it to a list of strings which do not start with minus(-).
c2cases(["cat"|[T1|T2]],concatenate(T1,T2)) :-
	string_chars(T1,S),
	ismembers(S,[-,n, b, s, u, v, e, t]),
	nth0(0,S,S1),
	S1 == (-),
	nth0(0,T2,R),
	string_chars(R,SS),
	nth0(0,SS,RR),
	RR \== (-).
	
%When the first elements of the ASCII list coincide with the ASCII for 'cp', it converts the list to string, and then splits the string into a list of strings, calling the cases.
isc3(E,M) :-
	compare_list([99,112],M),
	name(S,M),
	split_string(S,' ','\n',C),
	c3cases(C,E).

%When calling 'cp' with the minimum of arguments. It parses both arguments to strings not starting with minus (-).
c3cases(["cp",F,T],copy(option_list, F, T)) :-
	doesnotstartindash(F),
	doesnotstartindash(T).

%When calling 'cp' with arguments for a list of files and the target. It parses the inputs to a list of strings and a string respectively. 
c3cases(["cp"|T],copy(option_list, F, TL)) :-
	nth0(0,T,T0),
	doesnotstartindash(T0),
	last(T,TL),
	doesnotstartindash(TL),
	length(T,LT),
	LT > 2,
	reverse(T,[_|LTT]),
	reverse(LTT,F). 

%When calling 'cp' with option arguments and the file arguments. It parses the option arguments to a list of letters which started with minus (-) and is composed of only of the desired letters, the file arguments are parsed to strings which do not start with minus (-).	
c3cases(["cp"|T],copy(L1, RTB, RTA)) :-
	nth0(0,T,T0),
	startswithdash(T0),
	reverse(T,RT),
	nth0(0,RT,RTA),
	nth0(1,RT,RTB),
	doesnotstartindash(RTB),
	doesnotstartindash(RTA),
	recuargs(T,L1),
	ismembers(L1,["-r","-R","-f","-i","-p"]).
	
%When the ASCII list coincides with the ASCII for 'grep', it converts the list to string and splits the string into a list of strings, the it calls the cases.		
isc4(E,M) :-
	compare_list([103,114,101,112],M),
	name(S,M),
	split_string(S,' ','\n',C),
	c4cases(C,E).

%When calling 'grep' with the minimum arguments, that is the expression argument which is parsed to a string which do not start with minus (-).	
c4cases(["grep",E],search_expr(option_list_1, option_2, E, list_files)) :-
	doesnotstartindash(E).

%When calling 'grep' with extra file argument, it parses the two arguments to strings not starting with minus (-).
c4cases(["grep",E,F],search_expr(option_list_1, option_2, E, F)) :-
	doesnotstartindash(E),
	doesnotstartindash(F).
	
%When calling 'grep' with the first set of options and the expression and file argument. It parses the first set of options to a list of letters which started with the minus (-) and contains only the desired letters. The expression and file arguments are parsed to strings which do not start with minus (-).		
c4cases(["grep"|T],search_expr(TS0, option_2, RTB, RTA)) :-
	nth0(0,T,T0),
	startswithdash(T0),
	nth0(1,T,T1),
	doesnotstartindash(T1),
	reverse(T,RT),
	nth0(0,RT,RTA),
	nth0(1,RT,RTB),
	doesnotstartindash(RTB),
	doesnotstartindash(RTA),
	string_chars(T0,TS0),
	ismembers(TS0,[-,b,c,i,h,l,n,v,s,y]).

%When calling 'grep' with the first set of options and with the extra argument (-e) addittional to the expression argument and the file argument. The first set of options is parsed as before and the extra argument is parsed to a string which started with minus (-), the remaining two arguments are parsed as before.
c4cases(["grep"|T],search_expr(TS0, -e, RTB, RTA)) :-
	nth0(0,T,T0),
	startswithdash(T0),
	nth0(1,T,T1),
	startswithdash(T1),
	string_chars(T1,TS1),
	ismembers(TS1,[-,e]),
	reverse(T,RT),
	nth0(0,RT,RTA),
	nth0(1,RT,RTB),
	doesnotstartindash(RTB),
	doesnotstartindash(RTA),
	string_chars(T0,TS0),
	ismembers(TS0,[-,b,c,i,h,l,n,v,s,y]).

%% Additional predicates %%		

%This predicate compares two lists and is true when the first list is exactly equal to the first part of the same size of the second list.	
compare_list([H1|T1], [L1|L2]) :-
     check_element(H1,L1),
     compare_list(T1, L2).
compare_list([], _).

%This auxiliary predicate compares two elements of a list. 	
check_element(X, Y) :-
	X == Y.
check_element([], _).

%This predicate checks if all the elements of one list are contained in the other. 	
ismembers([H1|T1],S) :-
	member(H1,S),
	ismembers(T1,S).
ismembers([],_).
		
%This predicate is true when M and Y are the current Month and Year respectively.
monthyear(M,Y) :-
  get_time(Stamp),
  stamp_date_time(Stamp, DateTime, local),
  date_time_value(month, DateTime, M),
  date_time_value(year, DateTime, Y).	

%This predicate is true when the string T does not start in the minus character (-).
doesnotstartindash(T):-
	string_chars(T,S),
	nth0(0,S,S1),
	S1 \== (-).

%This predicate is true when the string T does start with the minux character (-).
startswithdash(T) :-
	string_chars(T,S),
	nth0(0,S,S1),
	S1 == (-).

%The predicate looks recursively for arguments starting with minus (-) and concatenates them in a list. 	
recuargs([H|T],[H|L1]) :-
	%length(T,L), L>2,
	startswithdash(H),recuargs(T,L1).
recuargs(_,[]).
	

		
	
	
	
	


	
	
	