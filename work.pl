%pesquisa(dama,pesquisa_largura).

%new_state(X´s;S;A)

inicial_state(s(0,4),a(6,1)).

final_state(s(0,4),a(0,4)).

list_Xs([(0,2),(1,0),(1,2),(1,6),(3,3),(4,3),(5,3)]).
%-------------------------restriçoes--------------------------

%A só avança 1 casa 
%allowed_moves((0,0),(,),[(0,2),(1,0),(1,2),(1,6),(3,3),(4,3),(5,3)]).
allowed_moves((X,Y),(Z,W)) :- \+ diagonal_move((X,Y),(Z,W)),modDif(X,Z,D1),modDif(Y,W,D2),D2 == 1;D1 == 1.
allowed_moves((X,Y),(Z,W)) :- \+ diagonal_move((X,Y),(Z,W)),modDif(X,Z,D1),modDif(Y,W,D2),D1 == 1;D2 == 1.
allowed_moves((X,Y),(Z,W),L) :- safe_position((Z,W),L),allowed_moves((X,Y),(Z,W)).

%A não pode andar na diagonal
diagonal_move((X,Y),(Z,W)) :- modDif(X,Z,D1),modDif(Y,W,D2),D1 == 1,D2 == 1.

%A não pode estar onde há X´s
%safe_position((0,4),[(0,2),(1,0),(1,2),(1,6),(3,3),(4,3),(5,3)]).
safe_position((X,Y),L) :- perimetro((X,Y)), \+ member((X,Y),L).

%A não pode sair do perimetro da sala
%perimetro((1,0)).
perimetro((X,Y)) :- X >= 0, X =< 6,
                    Y >= 0, Y =< 6.
%move(state(N_Afected,Afected)) :- .

%AUXILIAR
modDif(I,J,D):- I>J, D is I-J.
modDif(I,J,D):- I =< J, D is J-I.

%-------------------------operações--------------------------

%op(Estado_act,operador,Estado_seg,Custo)
op((X,Y),(N,M),(X1,Y1),1) :- list_Xs(L), allowed_moves((X,Y),(N,M),L), X1 is N, Y1 is M.