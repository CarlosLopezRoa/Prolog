

parent(X,Y) :- father(X,Y).
parent(X,Y) :- mother(X,Y).
parent(X,Y,Z) :- father(X,Z), mother(Y,Z). 
grandfather(X,Y) :- father(X,Z),parent(Z,Y).
%brotherorsister()

father(pepin,charlemagne).
mother(berthe,charlemagne).
father(charlemagne,charles).
father(charlemagne,pepin_theother).
father(charlemagne,coloman).
father(coloman,louis).

