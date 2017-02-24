%% father_child(a,b).表示a是b的父亲。
%% mother_child(a,b).表示a是b的母亲。
%% hazb_wife(a,b). 表示a,b是夫妻关系。
%% male(b).表示b是男性。
%% female(d).表示d是女性。



father_child(a,b).
father_child(a,d).
father_child(a,t).
father_child(b,c).
hazb_wife(aw,a).
hazb_wife(bw,b).
male(t).
male(c).
female(d).
% 兄弟关系
sibling(X, Y)      :- father_child(Z, X), father_child(Z, Y).
sibling(X, Y)      :- mother_child(Z, X), mother_child(Z, Y).
% 双亲关系
parent_child(X, Y) :- father_child(X, Y).
parent_child(X, Y) :- mother_child(X, Y).
%%
hi(_) :- write("hi").


command_loop:-
  repeat,
  write('Enter command (end to exit): '),
  read(X),
  write(X), nl,
  X = end.