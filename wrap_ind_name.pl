:- module(wrap_ind_name,
	  [
	      wrap_ind_name/3   % +Category, +String, ?Result
	  ]).

% add prefix

add_prefix(Category,Value,PreValue):-
	Category == campus,
	string_concat('http://www.semanticweb.org/young/ontologies/2014/6/unibo#Campus_of_',Value,PreValue),!.

add_prefix(Category,Value,PreValue):-
	Category == school,
	string_concat('http://www.semanticweb.org/young/ontologies/2014/6/unibo#School_of_',Value,PreValue),!.

add_prefix(Category,Value,PreValue):-
	Category == department,
	string_concat('http://www.semanticweb.org/young/ontologies/2014/6/unibo#Department_of_',Value,PreValue),!.

add_prefix(Category,Value,PreValue):-
	Category == profession,
	string_concat('http://www.semanticweb.org/young/ontologies/2014/6/unibo#',Value,PreValue),!.

add_prefix(Category,Value,PreValue):-
	Category == course,
	string_concat('http://www.semanticweb.org/young/ontologies/2014/6/unibo#',Value,PreValue),!.


% add postfix '_2014'
add_postfix(PreValue,PreValuePostAtom):-
	string_concat(PreValue,'_2014',PreValuePost),
	atom_string(PreValuePostAtom,PreValuePost).

wrap_ind_name(Category,Value,Result):-
	add_prefix(Category,Value,PreValue),
	add_postfix(PreValue,Result).

