% Try Down
try(Row, Column, NextRow, Column) :- NextRow is Row + 1.
% Try Left
try(Row, Column, Row, NextColumn) :- NextColumn is Column + 1.
% Try Right
try(Row, Column, Row, NextColumn) :- NextColumn is Column - 1.
% Try Up
try(Row, Column, NextRow, Column) :- NextRow is Row - 1.

move(A, [], [A]). 
move(X, [A|List], [A|NewList]) :-
	X \== A,
	move(X, List, NewList).
	
validMove(Maze, Row, Column) :-
	mazeSize(Maze, Rows, Columns),
	Row >= 1, 
	Row =< Rows,
	Column >= 1,
	Column =< Columns,
	not(maze(Maze, Row, Column, barrier)).

printCell(Maze, _List, Row, Column) :-
	maze(Maze, Row, Column, barrier),
	write('x').
printCell(_Maze, List, Row, Column) :-
	X=[Row,Column],
	member(X,List),
	write('*'),
	!.
printCell(Maze, _List, Row, Column) :-
	maze(Maze, Row, Column, open),
	write(' ').

printRow(Maze, List, Row) :-
    mazeSize(Maze, _Rows, Columns),
	write('|'),
    forall(between(1, Columns, Column),
		printCell(Maze, List, Row, Column)),
		writeln('|').

printMaze(Maze, List) :-
	writeln(' '),
    mazeSize(Maze, Rows, Columns),
	write('+'),
	forall(between(1, Columns, Column),
		write('-')),
	writeln('+'),
    forall(between(1, Rows, Row),
		printRow(Maze, List, Row)),
	write('+'),
	forall(between(1, Columns, Column),
		write('-')),
		writeln('+').
		   
printList([]).
printList([H|T]) :-
    writeln(H),
    printList(T).

miscRules(Maze, Row, Column, List) :- 
    mazeSize(Maze, Row, Column),
    printList(List),
    printMaze(Maze, List).
miscRules(Maze, Row, Column, List) :- 
    try(Row, Column, NextRow, NextColumn), 
    validMove(Maze, NextRow, NextColumn), 
    move([NextRow,NextColumn], List, NewList), 
    miscRules(Maze, NextRow, NextColumn, NewList).

solve(Maze) :- 
    miscRules(Maze, 0, 1, _List).