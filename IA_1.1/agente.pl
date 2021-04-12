%pesquisa(work,largura).

%new_state(X´s;S;A)

estado_inicial((6,1)).

estado_final((0,4)).

list_Xs([(0,2),(1,0),(1,2),(1,6),(3,3),(4,3),(5,3)]).
%-------------------------restriçoes--------------------------

%safe_position((0,4),[(0,2),(1,0),(1,2),(1,6),(3,3),(4,3),(5,3)]).
safe_position((X,Y)) :- list_Xs(L), perimetro((X,Y)), \+ member((X,Y),L).

%A não pode sair do perimetro da sala
%perimetro((1,0)).
perimetro((X,Y)) :- X >= 0, X =< 6,
                    Y >= 0, Y =< 6.

%-------------------------operações--------------------------

%op(Estado_act,operador,Estado_seg,Custo)
op((X,Y),esq,(X,Z),1) :- Z is Y-1, safe_position((X,Z)).
            
op((X,Y),dir,(X,Z),1) :-  Z is Y+1, safe_position((X,Z)).
                                 
op((X,Y),sobe,(Z,Y),1) :- Z is X-1, safe_position((Z,Y)). 
                          
op((X,Y),desce,(Z,Y),1) :-  Z is X+1,safe_position((Z,Y)). 

%-------------------------heuristicas--------------------------

%h((X,Y),Val):- estado_final((Xf,Yf)), modDif(X, Xf, Vi), modDif(Y, Yf, Vj), Val is (Vi+Vj).

h((X,Y),Val):- estado_final((Xf,Yf)),  modDif(X, Xf, Vi), modDif(Y, Yf, Vj),  max(V,Vi,Vj), Val is V.

%--------------------------AUXILIAR--------------------------
modDif(I,J,D):- I>J, D is I-J.
modDif(I,J,D):- I =< J, D is J-I.

max(Vi,Vi,Vj):-Vi>Vj,!.
max(Vj,_,Vj).


% a)
% b)
% ci) prof-9;larg-
%
% f) a*-51/25 ;gready-9/1
%    (visitados,lista)
%
%
%
%
%
%
%
%