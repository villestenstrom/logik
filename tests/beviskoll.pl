% Del 1: BEVIS


verify(InputFileName) :-
	see(InputFileName),
	read(Prems), read(Goal), read(Proof),
	seen,
	giltigtBevis(Prems, Goal, Proof).
 
 
 % Kommer att vara tom för första raden
 giltigtBevis(Prems, Goal, Proof) :-
	giltigtBevis(Prems, Goal, Proof, []).
 
 
 % om inga rader är o-validerade och sista validerade raden är Goal är vi klara
 giltigtBevis(_Prems, Goal, [], [[_Rad, Goal, _Regel]|_Validate]).
 
 
 % ett antagande i början av raden innebär att vi är i en box
 giltigtBevis(Prems, Goal, [[[Rad, Result, assumption]|BoxT]|ProofT], Giltig) :-
	kontrolleraBox(Prems, Goal, BoxT, [[Rad, Result, assumption]|Giltig]),
	giltigtBevis(Prems, Goal, ProofT, [[[Rad, Result, assumption]|BoxT]|Giltig]).
 
 
 % validera raden och lägg till den i listan med validerade rader och gå vidare
 giltigtBevis(Prems, Goal, [H|ProofT], Giltig) :-
	kontrolleraRegel(Prems, H, Giltig),
	giltigtBevis(Prems, Goal, ProofT, [H|Giltig]).
 
 
 
 
 % Del 2: REGLER
 % Format: kontrolleraRegel(Prems, [Radnummer, Uttryck, Regel], TidigareSannaRader)
 % innehåller alla reglappliceringar från A.2 i uppgiftsbeskrivningen
 
 
 % premiss
 kontrolleraRegel(Prems, [_Rad, Result, premise], _Giltig) :-
	member(Result, Prems).
 
 
 % copy(X)
 kontrolleraRegel(_Prems, [_Rad, Result, copy(X)], Giltig) :-
	member([X, Result, _], Giltig).
 
 
 % andint(X,Y)
 kontrolleraRegel(_Prems, [_Rad, and(And1, And2), andint(X,Y)], Giltig) :-
	member([X, And1, _], Giltig),
	member([Y, And2, _], Giltig).
 
 
 % andel1(X)
 kontrolleraRegel(_Prems, [_Rad, Result, andel1(X)], Giltig) :-
	member([X, and(Result, _), _], Giltig).
 
 
 % andel2(X)
 kontrolleraRegel(_Prems, [_Rad, Result, andel2(X)], Giltig) :-
	member([X, and(_, Result), _], Giltig).
 
 
 % orint1(X)
 kontrolleraRegel(_Prems, [_Rad, or(Result, _Other), orint1(X)], Giltig) :-
	member([X, Result, _], Giltig).
 
 
 % orint2(X)
 kontrolleraRegel(_Prems, [_Rad, or(_Other, Result), orint2(X)], Giltig) :-
	member([X, Result, _], Giltig).
 
 
 % orel(X,Y,U,V,W)
 kontrolleraRegel(_Prems, [_Rad, Result, orel(X,Y,U,V,W)], Giltig) :-
	hittaBox(Y, Giltig, ForstaBoxen),
	hittaBox(V, Giltig, AndraBoxen),
	member([X, or(First, Second), _], Giltig),
	member([Y, First, _], ForstaBoxen),
	member([U, Result, _], ForstaBoxen),
	member([V, Second, _], AndraBoxen),
	member([W, Result, _], AndraBoxen).
 
 
 % impint(X,Y)
 kontrolleraRegel(_Prems, [_Rad, imp(Impprem, Result), impint(X, Y)], Giltig) :-
	hittaBox(X, Giltig, Box),
	member([X, Impprem, assumption], Box),
	sist(Box, [Y, Result, _]).
 
 
 % impel(X,Y)
 kontrolleraRegel(_Prems, [_Rad, Result, impel(X,Y)], Giltig) :-
	member([X, Impprem, _], Giltig),
	member([Y, imp(Impprem, Result), _], Giltig).
 
 
 % negint(X,Y)
 kontrolleraRegel(_Prems, [_Rad, neg(Result), negint(X,Y)], Giltig) :-
	hittaBox(X, Giltig, Prevbox),
	member([X, Result, assumption], Prevbox),
	member([Y, cont, _], Prevbox).
 
 
 % negel(X,Y)
 kontrolleraRegel(_Prems, [_Rad, cont, negel(X,Y)], Giltig) :-
	member([X, Cont, _], Giltig),
	member([Y, neg(Cont), _], Giltig).
 
 
 % contel(X)
 kontrolleraRegel(_Prems, [_Rad, _Resultat, contel(X)], Giltig) :-
	member([X, cont, _], Giltig).
 
 
 % negnegint(X)
 kontrolleraRegel(_Prems, [_Rad, neg(neg(Result)), negnegint(X)], Giltig) :-
	member([X, Result, _], Giltig).
 
 
 % negnegel(X)
 kontrolleraRegel(_Prems, [_Rad, Result, negnegel(X)], Giltig) :-
	member([X, neg(neg(Result)), _], Giltig).
 
 
 % mt(X,Y)
 kontrolleraRegel(_Prems, [_Rad, neg(Result), mt(X,Y)], Giltig) :-
	member([X, imp(Result, Second), _], Giltig),
	member([Y, neg(Second), _], Giltig).
 
 
 % pbc(X,Y)
 kontrolleraRegel(_Prems, [_Rad, Result, pbc(X,Y)], Giltig) :-
	hittaBox(X, Giltig, Prevbox),
	member([X, neg(Result), assumption], Prevbox),
	member([Y, cont, _], Prevbox).
 
 
 % lem
 kontrolleraRegel(_Prems, [_Rad, or(X, neg(X)), lem], _Giltig).
 
 % sist(List, Element), hjälpklass till impint
 sist([Element], Element).
	sist([_|Rest], Element) :- sist(Rest, Element).
 
 
 % Del 3: LÅDOR
 
 
 % Om svansen är tom har vi nått slutet av lådan
 kontrolleraBox(_Prems, _Goal, [], _Giltig).
 
 
 % Om en låda är inuti en annan låda så måste vi kontrollera den inre lådan först
 kontrolleraBox(Prems, Goal, [[[Rad, Result, assumption]|BoxT]|ProofT], Giltig) :-
	kontrolleraBox(Prems, Goal, BoxT, [[Rad, Result, assumption]|Giltig]),
	kontrolleraBox(Prems, Goal, ProofT, [[[Rad, Result, assumption]|BoxT]|Giltig]).
 
 
 % Låda som nytt bevis
 kontrolleraBox(Prems, Goal, [H|ProofT], Giltig) :-
	kontrolleraRegel(Prems, H, Giltig),
	kontrolleraBox(Prems, Goal, ProofT, [H|Giltig]).
 
 
 % Sant om nuvarande raden är en låda
 hittaBox(LetaEfter, [H|_Giltig], H) :-
	member([LetaEfter, _, _], H).
 
 
 % Om nuvarande raden inte är en låda så går vi ner en rad och kollar igen
 hittaBox(LetaEfter, [_|Giltig], Box) :-
	hittaBox(LetaEfter, Giltig, Box).
 