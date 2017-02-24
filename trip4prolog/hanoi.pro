
hanoi(N) :- 
    move(N,left,middle,right).

move(1,Src,_,Dst) :- 
    step(Src,Dst), 
    !.

move(N,Src,Tmp,Dst) :- 
    N1 is N-1,
    move(N1,Src,Dst,Tmp),
    step(Src,Dst),
    move(N1,Tmp,Src,Dst).

step(Loc1, Loc2) :-
    nl, 
    write('Move a disk from '-Loc1-' to '-Loc2).