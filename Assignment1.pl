arc([H|T],Node,Cost,KB) :- member([H|B],KB), append(B,T,Node),
    length(B,L), Cost is 1+ L/(L+1).

heuristic(Node,H) :- length(Node,H).

goal([]).

astar(Node, Path, Cost, KB) :-
    search([[Node, [], 0]],Path, Cost, KB).

search([[Node, Path, Cost]|_], [Node|Path], Cost, _) :- goal(Node).

search([[Node, PathSoFar, CostSoFar]|More],TotalPath, TotalCost, KB) :-
    findall([X, [Node|PathSoFar], NewCost], 
    (arc(Node,X, Cost, KB),NewCost is CostSoFar + Cost),Children),
    add2frontier(Children,More,New),
    search(New, TotalPath, TotalCost, KB).

add2frontier(Children, Frontier, NewFrontier) :- append(Children, Frontier, NewFrontier).

minSort([Head|Tail], Result) :- sort(Head, [], Tail, Result).

sort(Head, S, [], [Head|S]).
sort(C, S, [Head|Tail], Result) :- lessthan(C, Head), !,
                                   sort(C, [Head|S], Tail, Result);
                                   sort(Head, [C|S], Tail, Result).
 

lessthan([Node1,_,Cost1|_],[Node2,_,Cost2|_]) :- heuristic(Node1,Hvalue1),
                                                  heuristic(Node2,Hvalue2),
                                                  F1 is Cost1+Hvalue1, 
                                                  F2 is Cost2+Hvalue2,
                                                  F1 =< F2.