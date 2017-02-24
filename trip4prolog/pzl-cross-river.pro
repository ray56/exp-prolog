%% 过河
%%
%% 有三个牧师和三个野人过河，只有一条能装下两个人的船，在河的任何一方或者船上，如果野人的人数大于牧师的人数，那么牧师就会有危险。你能不能找出一种安全的渡河方法呢？
%%
%% 这个问题还可以扩展为五个牧师和五个野人，而船一次可以装下三个人的情况。如果人数再增加，船在增大，问题就失去了其趣味性了，这一点在我们使用Prolog解决上面的问题以后，再来讨论。
%%
%%
%
:- use_module(library(dif)).		% Sound inequality
:- use_module(library(clpfd)).		% Finite domain constraints
:- use_module(library(clpb)).		% Boolean constraints
:- use_module(library(chr)).		% Constraint Handling Rules
:- use_module(library(when)).		% Coroutining



safe( [], []).
safe( [], [H|T]).
safe( [H|T], [] ).
safe( [_], [_] ).
safe( [MH1,MH2|MT], [SH|ST] ) :- safe( [MH2|MT], ST).
safe( 0,S).
safe( M,S) :- \+ is_list(M), M >= S.

allsafe( (SM,SS),(BM,BS),(DM, DS)) :-
    is_list(SM),
    safe(SM,SS),
    safe(BM,BS),
    safe(DM,DS),
    append(SM,BM,SMBM),append(SS,BS,SSBS), safe(SMBM,SSBS),
    append(DM,BM,DMBM),append(DS,BS,DSBS), safe(DMBM,DSBS).
allsafe( (SM,SS),(BM,BS),(DM, DS)) :-
    \+ is_list(SM),
    safe(SM,SS),
    safe(BM,BS),
    safe(DM,DS),
    SMBM is SM + BM , SSBS is SS + BS , safe(SMBM,SSBS),
    DMBM is DM + BM , DSBS is DS + BS , safe(DMBM,DSBS).

swap((SM1,BM1,SS1,BS1),(SM2,BM2,SS2,BS2)) :-
    is_list(SM1),
    append( SM1,BM1,M), append(SM2,BM2,M),
    append( SS1,BS1,S), append(SS2,BS2,S),
    (SM1,BM1,SS1,BS1) \= (SM2,BM2,SS2,BS2).
swap((SM1,BM1,SS1,BS1),(SM2,BM2,SS2,BS2)) :-
    \+ is_list(SM1),
    M is SM1 + BM1, between(0,2,BM2),plus( SM2, BM2, M),
    S is SS1 + BS1, between(0,2,BS2),plus( SS2, BS2, S),
    %SM1 + BM1 #= SM2 + BM2 ,
    %SS1 + BS1 #= SS2 + BS2 ,
    (SM1 =\= SM2 ; SS1 =\= SS2),
    %(SM1,BM1,SS1,BS1) \= (SM2,BM2,SS2,BS2),
    SM2 >= 0 , BM2 >= 0 , SS2 >= 0 , BS2 >= 0 .

test :- swap((3,0,3,0),S2).

% swap(([m,m,m],[],[s,s,s],[]),S2).

boatable( [], [] ).
boatable( [], [_] ).
boatable( [_], [] ).
boatable( [_], [_] ).
boatable( [_,_], [] ).
boatable( [], [_,_] ).
boatable( BM, BS ) :- \+ is_list(BM), BM + BS =< 2 , BM >= 0, BS >= 0.

drivable(BM, BS) :- is_list(BM), (BM,BS) \= ([],[]).
drivable(BM, BS) :- \+ is_list(BM), BM + BS > 0 .

% 上下船，作为一步。
move( state( (S,SM1,SS1),(S,BM1,BS1),(D,DM,DS) ), state( (S,SM2,SS2),(S,BM2,BS2),(D,DM,DS) ) ) :-
    swap( (SM1, BM1,SS1,BS1), (SM2, BM2,SS2, BS2)), boatable(BM2,BS2), allsafe( (SM2,SS2),(BM2,BS2),(DM, DS)).
move( state( (D,DM,DS),(S,BM1,BS1),(S,SM1,SS1) ), state( (D,DM,DS),(S,BM2,BS2),(S,SM2,SS2) ) ) :-
    swap( (SM1, BM1,SS1,BS1), (SM2, BM2,SS2, BS2)), boatable(BM2,BS2), allsafe( (SM2,SS2),(BM2,BS2),(DM, DS)).
% 移动船，作为一步。
move( state( (S,SM,SS),(S,BM,BS),(D,DM,DS) ), state( (S,SM,SS),(D,BM,BS),(D,DM,DS) ) ) :- drivable(BM, BS).
move( state( (S,SM,SS),(D,BM,BS),(D,DM,DS) ), state( (S,SM,SS),(S,BM,BS),(D,DM,DS) ) ) :- drivable(BM, BS).

test :- move( state(('<',3,3),('<',0,0), ('>',0,0)),S2).


resolve( S, S, [],History ) :- write("OK").
resolve( S, F, [M|Movies],History ) :-
    move(S,M),\+ member(M,History),
    resolve(M,F,Movies,[S|History]).

resolve(S,F,Moves) :- resolve(S,F,Moves,[S]).



resolvable(S,S,H) :- write("OK"),nl,reverse(H,Steps), print(Steps).
resolvable(S,F,H) :- move(S,M), \+ member(M,H), resolvable(M,F,[M|H]).
resolvable(S,F) :- resolvable(S,F,[S]).

print([]) :- nl.
print([H|T]) :- write(H), nl,print(T).


%% 列表 ok
main-1 :-
	resolve( state(('<',[m,m,m],[s,s,s]),('<',[],[]), ('>',[],[])), state(('<',[],[]),('>',[],[]),('>',[m,m,m],[s,s,s])), Moves).
%% 数字 ng
main-2 :-
	resolve( state(('<',3,3),('<',0,0), ('>',0,0)), state(('<',0,0),('>',0,0),('>',3,3)), Moves).
