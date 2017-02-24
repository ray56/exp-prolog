:- module(hanoi,[hanoi/1]).

hanoi(Disk) :- 
    move(u('L',Disk),b('L',[]),b('M',[]),b('R',[])).

move( u(S,[X]), b(S, SB), b(T, TB), b(D,DB) ) :-
    nl,
    write(S-D-X-b(S,SB)-b(T,TB)-b(D,[X|DB])).
    
move( u(S,SU), b(S, SB), b(T, TB), b(D,DB) ) :- 
    last(SU,SUt), append(SUH,[SUt],SU),
    append( SUH, TB, TB_ ),
    move( u(S,SUH),   b(S,[SUt|SB]), b(D,DB),  b(T,TB) ),   
    move( u(S,[SUt]), b(S,SB),       b(T,TB_), b(D,DB) ),
    move( u(T,SUH),   b(T,TB),       b(S,SB),  b(D,[SUt|DB]) ).
    