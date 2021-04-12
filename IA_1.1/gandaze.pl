  :- dynamic(fechado/1).
  :- dynamic(expandido/1).

  %Descricao do problema:

  %estado_inicial(Estado)
  %estado_final(Estado)

  %representacao dos operadores
  %op(Eact,OP,Eseg,Custo)

  % representacao dos nos
  %no(Estado,no_pai,OperadorCusto,Profundidade)

  :- dynamic(maxNL/1).
  :- dynamic(nos/1).

  maxNL(0).
  nos(0).

  inc:- retract(nos(N)), N1 is N+1, asserta(nos(N1)).

  actmax(N):- maxNL(N1), N1 >= N,!.
  actmax(N):- retract(maxNL(_N1)), asserta(maxNL(N)).


  pesquisa(Problema,Alg):-
    consult(Problema),
    estado_inicial(S0),
    pesquisa(Alg,[no(S0,[],[],0,0)],Solucao),
    escreve_seq_solucao(Solucao),
    retract(nos(Ns)),retract(maxNL(NL)),retractall(fechado(_)), retractall(expandido(_)),
    asserta(nos(0)),asserta(maxNL(0)),
    write(nos(visitados(Ns),lista(NL))).

  
  
  
  pesquisa_it(Ln,Sol,P):- pesquisa_pLim(Ln,Sol,P).
  pesquisa_it(Ln,Sol,P):- P1 is P+1, pesquisa_it(Ln,Sol,P1).

  pesquisa(it,Ln,Sol):- pesquisa_it(Ln,Sol,1).
  pesquisa(largura,Ln,Sol):- pesquisa_largura(Ln,Sol).
  pesquisa(profundidade,Ln,Sol):- pesquisa_profundidade(Ln,Sol).


  pesquisa_profundidade([no(E,Pai,Op,C,P)|_],no(E,Pai,Op,C,P)):- estado_final(E), inc.
  
  % Para evitar ciclos infinitos, usamos o assert e o fechado
  % pesquisa_profundidade([no(E,Pai,Op,C,P)|R], Sol):- fechado(E),!, pesquisa_profundidade(R,Sol).

  % pesquisa_profundidade([E|R],Sol):- expande(E,Lseg), E = no(E1,Pai,Op,C,P), assertz(fechado(E1)), %esc(E),
  %                                    insere_inicio(Lseg,R,Resto),
  %                                    pesquisa_profundidade(Resto,Sol).

  pesquisa_profundidade([E|R],Sol):- inc, expande(E,Lseg),%esc(E),
                                     insere_inicio(Lseg,R,Resto),
                                     length(Resto,N), actmax(N),
                                     pesquisa_profundidade(Resto,Sol).

  %pesquisa_largura([],_):- !,fail.
  pesquisa_largura([no(E,Pai,Op,C,P)|_],no(E,Pai,Op,C,P)):- estado_final(E), inc.
  
  pesquisa_largura([E|R],Sol):- inc, expande(E,Lseg), %esc(E),
                                insere_fim(Lseg,R,Resto),
                                length(Resto,N), actmax(N),
                                pesquisa_largura(Resto,Sol).


  
  % Para evitar ciclos infinitos, usamos o assert e o fechado
  expande(no(E,_,_,_,_),[]):- fechado(E), !.
  
  expande(no(E,Pai,Op,C,P),L):- assertz(fechado(E)), 
                                findall(no(En,no(E,Pai,Op,C,P),Opn,Cnn,P1),
                                (op(E,Opn,En,Cn), assertz(expandido(En)) ,P1 is P+1, Cnn is Cn+C),
                                L).
                          
  
  % expande(no(E,Pai,Op,C,P),L):- findall(no(En,no(E,Pai,Op,C,P),Opn,Cnn,P1),
  %                                (op(E,Opn,En,Cn),P1 is P+1, Cnn is Cn+C),
  %                                L).


  
  expandePl(no(_,_,_,_,P),[],Pl):- Pl =< P, ! .
  expandePl(no(E,Pai,Op,C,P),L,_):- findall(no(En,no(E,Pai,Op,C,P),Opn,Cnn,P1),
                                      (op(E,Opn,En,Cn),P1 is P+1, Cnn is Cn+C),
                                      L).


  insere_fim([],L,L).
  insere_fim(L,[],L).
  insere_fim(R,[A|S],[A|L]):- insere_fim(R,S,L).

  insere_inicio(A,B,L):- insere_fim(B,A,L).

  
  pesquisa_pLim([no(E,Pai,Op,C,P)|_],no(E,Pai,Op,C,P),_):- estado_final(E), inc. %incrementar depois de estado_final
  
  pesquisa_pLim([E|R],Sol,Pl):- inc, expandePl(E,Lseg,Pl), %esc(E), %incrementar antes do expandePl
                                insere_fim(R,Lseg,Resto),
                                length(Resto,N), actmax(N), % calcular o tamanho de resto e actualizar maximo
                                pesquisa_pLim(Resto,Sol,Pl).
  
  
  escreve_seq_solucao(no(E,Pai,Op,Custo,Prof)):- write(custo(Custo)),nl,
                                            write(profundidade(Prof)),nl,
                                            escreve_seq_accoes(no(E,Pai,Op,_,_)).
  
  
  escreve_seq_accoes([]).
  escreve_seq_accoes(no(E,Pai,Op,_,_)):- escreve_seq_accoes(Pai),
                                                write(e(Op,E)),nl.
  
  esc(A):- write(A), nl.