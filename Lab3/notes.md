Uppgift: make a model checker

Lista U anvands for att registrera vilka tillstand som redan har utvarderats.

first, the upper most check predicate is called...
"\ +" Operator

- the "not provable" operator, will succeed if it's argument is not provable.
- is used as negation in practice?
  Prolog thinks that is a goal cannot be proven, then it's false. This is called the close world assumption.

The built-in Prolog extra-logical predicate once takes a single argument, which must be a "callable term" - one that makes sense as a goal - e.g. happy(X) makes sense as a goal, but 23 does not - and calls the term in such a way as to produces just one solution. It is defined as:

once(P) :- P, !.

M = {T, L, U}
T: transitions
L: labels
S: current state
U: recorded states
F: CTL formula

skalar av F steg for steg.

does every file pattern match with the literal predicate?

LITERALS
is the given literal/atom true in the current state?
member call 1: Checks if [s0, Whatever] is in L
member call 2: Checks if r is in Whatever
Whatever is the list with the true values at state s0.

NEGATION
for neg(F) to be valid, F should be invalid. So we just check if F is valid, and negate the answer.

AND
Just check if both conjuncts are true.

OR1
Check if the first disjunct is true.
OR2
Check if the second disjunct is true.

AX
De Morgan, uses the ex/1 and neg/1.

EX
"i nagot nasta tillstand"
search the list of transitions from the current state.
member(NextState, Transition) essentially asks: what's the next state? and initalizes NextState to it.
then check if the formula (with ex shaved of) is true in the next state.

AG
De Morgan, uses ef/1 and neg/1

EG: "det finns en vag dar alltid"
EG1
check if we are in a cycle. if yes, then terminate with true.
EG2
we are in state x for the first time. verifieras genom negation av member(S, U).
not really sure why we are checking previous states. prob because the current road includes the previous states?
Unclear if the "\+ member(S, U)" line is needed.

EF: "det finns en vag dar sa smaningom"
EF1:

### Questions

(a) Vad skiljer labbens version av CTL fran bokens version? Hur kan
man utoka modellprovaren sa att den hanterar bokens CTL?
: Vi har inte boken, sa vet tyvarr inte.

(b) Hur hanterade ni variabelt antal premisser (som i AX-regeln)?
: vi använde ändå de-morgans i alla A-regler

(c) Hur stora modeller och formler gar det att verifiera med er modellprovare?
: space complexity = O(n) (anvander en lista som vaxer linjart)
: time complexity = high exponential or factorial
