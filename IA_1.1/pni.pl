:-dynamic(fechado/1).

pesquisa(Problema, Alg):- consult(Problema),
                          estado_inicial(S0),
                          pesquisa(Alg, [no(S0, [], [], 0, 0)], Solucao),
                          retractall(fechado(_)),
                          escreve_seq_solucao(Solucao).


pesquisa(it, Ln, Sol):- pesquisa_it(Ln, Sol, 1).
pesquisa(largura, Ln, Sol):- pesquisa_largura(Ln, Sol).
pesquisa(profundidade, Ln, Sol):- pesquisa_profundidade(Ln, Sol).


pesquisa_it(Ln, Sol, P):- pesquisa_pLim(Ln, Sol, P).

pesquisa_it(Ln, Sol, P):- P1 is P+1,
                          pesquisa_it(Ln, Sol, P1).


pesquisa_largura([no(E, Pai, Op, C, P)|_], no(E, Pai, Op, C, P)):- estado_final(E).

pesquisa_largura([E|R], Sol):- expande(E, Lseg),
                               E = no(Ei, _Pai, _Op, _C, _P),
                               assertz(fechado(Ei)),
                               insere_fim(Lseg, R, Resto),
                               pesquisa_largura(Resto, Sol).


pesquisa_profundidade([no(E, Pai, Op, C, P)|_],no(E, Pai, Op, C, P)):- estado_final(E).

pesquisa_profundidade([E|R], Sol):- expande(E, Lseg), 
                                    E = no(Ei, _Pai, _Op, _C, _P),
                                    assertz(fechado(Ei)),
                                    insere_fim(R, Lseg, Resto),
                                    pesquisa_profundidade(Resto, Sol).


expande(no(E, Pai, Op, C, P), L):- findall(no(En, no(E, Pai, Op, C, P), Opn, Cnn, P1),
                                          (op(E, Opn, En, Cn),
                                              P1 is P+1,
                                              h(En, H),
                                              Cnn is Cn+C,
                                              \+fechado(En)),
                                          L).


expandePl(no(E, Pai, Op, C, P), [], Pl):- Pl =< P, !.

expandePl(no(E, Pai, Op, C, P), L, _):- findall(no(En, no(E, Pai, Op, C, P), Opn, Cnn, P1),
                                               (op(E, Opn, En, Cn),
                                                    P1 is P+1,
                                                    h(En, H),
                                                    Cnn is Cn+C),
                                               L).


insere_fim([], L, L).

insere_fim(L, [], L).

insere_fim(R, [A|S], [A|L]):- insere_fim(R, S, L).


pesquisa_pLim([no(E, Pai, Op, C, P)|_], no(E, Pai, Op, C, P), _):- estado_final(E).

pesquisa_pLim([E|R], Sol, Pl):- expandePl(E, Lseg, Pl),
                                insere_fim(R, Lseg, Resto),
                                pesquisa_pLim(Resto, Sol, Pl).


escreve_seq_solucao(no(E, Pai, Op, Custo, Prof)):- write(custo(Custo)),
                                                   nl,
                                                   write(profundidade(Prof)),
                                                   nl,
                                                   escreve_seq_accoes(no(E, Pai, Op, _, _)).


escreve_seq_accoes([]).

escreve_seq_accoes(no(E, Pai, Op, _, _)):- escreve_seq_accoes(Pai),
                                           write(e(Op, E)),
                                           nl.


esc(A):- write(A), nl.

