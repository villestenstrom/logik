append([],L,L).
append([H|T],L,[H|R]) :- 
    append(T,L,R).

appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]) :-
           appendEl(X, T, Y).

length([],0).
length([_|T],N) :- length(T,N1), N is N1+1.

nth(N,L,E) :- nth(1,N,L,E).
nth(N,N,[H|_],H).
nth(K,N,[_|T],H) :- K1 is K+1, nth(K1,N,T,H).

subset([], []).
subset([H|T], [H|R]) :- subset(T, R).
subset([_|T], R) :- subset(T, R).

select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- select(X,T,R).

member(X,L) :- select(X,L,_).

memberchk(X,L) :- select(X,L,_), !.

%1
?- T=f(a,Y,Z), T=f(X,X,b).
T = f(a, a, b),
Y = X, X = a,
Z = b.

% Förklaring: 
% I "T=f(a,Y,Z)" så binder T till f(a,Y,Z)
% Eftersom T redan är bunden till f(a,Y,Z) måste T=f(X,X,b)
% binda X till a, Y till X (som nu är a) och Z till b.
% Detta ger alltså svaret:
% T = f(a,a,b)
% X = a
% Y = a
% Z = b

%2
remove_duplicates(BaseList, OutList) :-
    remove_duplicates(BaseList, OutList, []).

remove_duplicates([], [], _). %basecase
remove_duplicates([Head|Tail], R, Used) :- %remove_duplicates([1,2,3,2,4,1,3,4], E).
    % check Head is member of Used array, --> then
    % if Head member of Used -> R=S, UsedC=Used, else, add head to R and add head to Used values
    (member(Head, Used) -> 
    (R = X, UsedC = Used); 
    (R = [Head|X], UsedC = [Head|Used])),
    remove_duplicates(Tail, X, UsedC).

%3

%same as sublist
substring([], []).
% first value does not matter
substring([_|T], R) :-
    substring(T, R).
% same first value, 
substring([H|T], [H|R]) :-
    cons_substring(T, R).

% input list does not matter (will always be = or longer)
cons_substring(_, []).
cons_substring([H|T], [H|R]) :-
    cons_substring(T, R).

partstring([], 0, []).
partstring(BaseList, L, F) :- 
    substring(BaseList, F), 
    length(F, L).


%4
edge(a,b).
edge(a,c).
edge(b,d).
edge(c,l).
edge(a,l).
edge(l,d).
edge(l,e).
edge(d,e).
edge(b,a).

% convert call with 2 params to 3 params
reverse_list(Q, Path) :-
    reverse_list(Q, [], Path).

% base case list empty, return X (reversed list)
reverse_list([], X, X).

% split list in head/tail. X is empty, Path
reverse_list([H|T], X, Path):-
    % append head to X in every iteration
    reverse_list(T, [H|X], Path).

% take starting node, endnode and variable path
path(Start,End,Path) :-
    %
    walk(Start,End,[Start],Q),
    reverse_list(Q, Path).

% base case, start and end are the same
walk(Start,Start,P,P) :-
    P=[Start].

% current node is next to end node
walk(Start,End,P,[End|P]) :-
    edge(Start,End).

% We have to traverse atleast more than one node
walk(Start,End,Used,Path) :-
    %get all nodes from startnode
    edge(Start,C),
    %where c is not visited
    \+memberchk(C,Used),
    %repeat
    walk(C,End,[C|Used],Path).
