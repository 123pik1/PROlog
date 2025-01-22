% Sprawdza, czy lista jest posortowana
is_sorted([]). % Pusta lista jest posortowana
is_sorted([_]). % Lista z jednym elementem jest posortowana
is_sorted([X, Y | Tail]) :- 
    X >= Y, % Pierwszy element nie większy niż drugi
    is_sorted([Y | Tail]). % Rekurencyjnie sprawdzaj resztę

% Przestawia elementy w losowej kolejności
shuffle([], []). % Pusta lista przestawiona to pusta lista
shuffle(List, [H|ShuffledTail]) :-
    length(List, Len),
    random_between(1, Len, Index),
    nth1(Index, List, H), % Wybierz element na pozycji Index
    remove_first(H, List, Rest), % Usuń wybrany element
    shuffle(Rest, ShuffledTail). % Przestaw resztę listy

% Usuwa tylko pierwsze wystąpienie elementu z listy
remove_first(_, [], []). % Nic do usunięcia w pustej liście
remove_first(X, [X|Tail], Tail) :- !. % Usuń pierwsze dopasowanie
remove_first(X, [H|Tail], [H|ResultTail]) :- 
    remove_first(X, Tail, ResultTail). % Rekurencyjnie przeszukuj resztę

% Implementacja bogosort
sortuj(List, Sorted) :-
    shuffle(List, Shuffled), % Przestaw elementy losowo
    (is_sorted(Shuffled) -> Sorted = Shuffled ; sortuj(List, Sorted)). % Sprawdź, czy posortowane

% Główna funkcja sprawdzająca, czy lista jest graficzna
czy_graficzny(List, true) :-
    graficzny_helper(List), !.
czy_graficzny(_, false).


% Pomocniczy predykat obsługujący rekurencyjnie listę
graficzny_helper([]).
graficzny_helper([0|Tail]) :- all_zero(Tail). % Wszystkie elementy muszą być zerami
graficzny_helper(List) :-
    sortuj(List, [Max|Rest]), % Posortuj malejąco, wybierz największy element
    length(Rest, Len),
    Max =< Len, % Sprawdź, czy największy element jest <= liczby pozostałych
    reduce_degrees(Rest, Max, Reduced), % Redukuj stopnie pierwszych Max elementów
    no_minus_value(Reduced),
    graficzny_helper(Reduced). % Rekurencyjnie sprawdzaj resztę listy

% Sprawdza, czy wszystkie elementy w liście to zera
all_zero([]).
all_zero([0|Tail]) :- all_zero(Tail).

% Sprawdza, czy w liście jest jakikolwiek element mniejszy niż 0
no_minus_value([]).
no_minus_value([H|Tail]) :- 
    H >= 0, % Sprawdź, czy element jest >= 0
    no_minus_value(Tail). % Sprawdź resztę listy

% Redukuje stopnie (odejmuje 1 od pierwszych N elementów)
reduce_degrees(List, 0, List). % Nic nie redukuj, jeśli Max = 0
reduce_degrees([H|Tail], N, [H1|ReducedTail]) :-
    N > 0,
    H1 is H - 1, % Odejmij 1 od elementu
    N1 is N - 1, % Zmniejsz licznik N
    reduce_degrees(Tail, N1, ReducedTail).



%jeśli jest w liście element o wartosci=0 to graf nie moze byc spójny
no_zero_value([]).
no_zero_value([Head|Tail]) :-
	Head > 0, no_zero_value(Tail).

%policz sume wszystkich elementów listy
sumuj([], 0).
sumuj([Head|Tail], N) :-
		sumuj(Tail, N1),
		N is N1 + Head.

% sprawdza czy suma wszystkich stopni jest większa równa 2 * (n - 1) 
check_sum(L) :-
	sumuj(L, Suma),
	length(L, N),
	Suma >= 2 * (N - 1).


czy_spojny(L) :-
    no_zero_value(L),
	check_sum(L),
	czy_graficzny(L, true).

czy_spojny(L, X) :- czy_spojny(L),!,
    X = "T";
    X = "N".

%czy_graficzny([4, 3, 3, 2, 2, 1],ODP) niegraficzny
%czy_graficzny([3, 3, 2, 2, 2],ODP) graficzny
%czy_graficzny([5, 3, 3, 3, 3, 3],ODP) graficzny
%czy_graficzny([2, 2, 2, 2],ODP) graficzny
%czy_graficzny([3, 3, 2, 1, 1],ODP) graficzny
%czy_graficzny([5, 3, 3, 2, 2],ODP) niegraficzny
%czy_graficzny([4, 4, 3, 2, 1],ODP) niegraficzny
%czy_graficzny([3, 3, 3, 3, 1],ODP) niegraficzny
%czy_graficzny([6, 2, 2, 1],ODP) niegraficzny
%czy_graficzny([3, 3, 2, 1],ODP) niegraficzny

%czy_spojny( [1,0,1], ODP )  graf niespójny
%czy_spojny( [1,1,1], ODP )  ciąg nie graficzny/niespójny
%czy_spojny( [1,1,1,1], ODP ) graf niespójny
%czy_spojny( [1,2,2,1,2], ODP ) graf spójny
%czy_spojny( [3,3,3,0,3], ODP )  graf niespójny

%czy_spojny([4, 3, 3, 2, 2], ODP) graf spójny, 1 wierzcholek łączy się z resztą
%czy_spojny([3, 3, 3, 3, 3], ODP) graf niespójny, 
%czy_spojny([2, 2, 2, 2, 2, 2], ODP) graf spójny, pętla