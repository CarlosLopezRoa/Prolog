study(X) :- serious(X).
homework(X) :- conscientious(X).
homework(bob).
pass(X) :- study(X).
serious(X) :- homework(X).

conscientious(zoe).
conscientious(pascal).
