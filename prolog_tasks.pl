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
graficzny_helper([]). % Pusta lista jest graficzna
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
    %H1 >= 0, % Upewnij się, że element nie jest ujemny
    N1 is N - 1, % Zmniejsz licznik N
    reduce_degrees(Tail, N1, ReducedTail).
%reduce_degrees(List, _, List). % Zwróć resztę, jeśli N przekroczy długość listy
%czy_graficzny([5, 3, 3, 2, 2],Odp)  czy_graficzny([4, 4, 3, 2, 1],Odp)