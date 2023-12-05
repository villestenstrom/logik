% For SICStus, uncomment line below: (needed for member/2)
%:- use_module(library(lists)).
% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).
% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.
%
% Should evaluate to true iff the sequent below is valid. %
% (T,L), S |- F %U
% To execute: consult('your_file.pl'). verify('input.txt').

% Literals
check(_, L, S, [], F) :-
    % Check whether the current state is labeled with the given formula.
	member([S, Labels], L),
	member(F , Labels).

% Negation
check(T, L, S, [], neg(F)) :-
    % Check whether the negated formula is false.
	\+ check(T, L, S, [], F).
		 
% And
check(T, L, S, [], and(F,G)) :-
    % Check whether both conjuncts are true.
	check(T, L, S, [], F),
	check(T, L, S, [], G).

% Or1
check(T, L, S, [], or(F,_)) :-
    % Check whether the first disjunct is true.
	check(T, L, S, [], F).

% Or2	
check(T, L, S, [], or(_,G)) :-
    % Check whether the second disjunct is true.
	check(T, L, S, [], G).

% AX - "i nasta tillstand"
check(T, L, S, [], ax(F)) :-
    % Check whether the negated EX of the negated formula is true. based on de morgan
	check(T, L, S, [], neg(ex(neg(F)))).

% EX - "i nagot nasta tillstand"
check(T, L, S, [], ex(F)) :-
    % Find the next state by following one of the transitions from the current state.
	member([S, StateTransition], T),
	member(NextState, StateTransition),
    % Check whether the formula is true in the next state.
	check(T, L, NextState, [], F).

% AG - "alltid"
check(T, L, S, U, ag(F)) :-
    % Check whether the negated EF of the negated formula is true. based on de morgan
	check(T, L, S, U, neg(ef(neg(F)))). 

% EG1 - "det finns en vag dar alltid"
% Check whether the current state has been previously visited.
check(_, _, S, U, eg(_)) :-
	member(S,U).

% EG2 - "det finns en vag dar alltid"
% Check whether the formula is true in the current state and there is a transition to a next state.
% Then, check whether the EG of the formula is true in the next state and all previous states.
check(T, L, S, U, eg(F)) :-
	\+ member(S, U),
	check(T, L, S, [], F), % true in the current state?
	member([S, StateTransition], T), % is there a transition to a next state?
	member(NextState, StateTransition), % find the next state
	check(T, L, NextState, [S|U], eg(F)).

% EF1 - "det finns en vag dar sa smaningom"
% Check whether the current state has not been previously visited and the formula is true in the current state.
check(T, L, S, U, ef(F)) :-
	\+ member(S, U), % terminate if we are in a cycle
	check(T, L, S, [], F).

% EF2 - "det finns en vag dar sa smaningom"
% Check whether the current state has not been previously visited and there is a transition to a next state.
% Then, check whether the EF of the formula is true in the next state and all previous states.
check(T, L, S, U, ef(F)) :-
	\+ member(S, U), % terminate if we are in a cycle
	member([S, StateTransition], T),
	member(NextState, StateTransition),
	check(T, L, NextState, [S|U], ef(F)).

% AF - "sa smaningom"
check(T, L, S, U, af(F)) :-
    % Check whether the negated EG of the negated formula is true. based on de morgan
	check(T, L, S, U, neg(eg(neg(F)))).
