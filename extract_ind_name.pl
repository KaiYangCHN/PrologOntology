:- module( extract_ind_name,
	  [
	       extract_ind_name/3  % +Category, +Individual, ?Name
	  ]).

% eliminate prefix
% 'http://www.semanticweb.org/young/ontologies/2014/6/unibo#Campus_of_'
elm_prefix(Category,String,Sub):-
	Category == campus,
	string_length('http://www.semanticweb.org/young/ontologies/2014/6/unibo#Campus_of_',Length), %Length == 67
	sub_string(String,Length,_,0,Sub),!.

% eliminate prefix
% 'http://www.semanticweb.org/young/ontologies/2014/6/unibo#School_of_'
elm_prefix(Category,String,Sub):-
	Category == school,
	string_length('http://www.semanticweb.org/young/ontologies/2014/6/unibo#School_of_',Length),
	sub_string(String,Length,_,0,Sub),!.

% eliminate prefix
% 'http://www.semanticweb.org/young/ontologies/2014/6/unibo#Department_of_'
elm_prefix(Category,String,Sub):-
	Category == department,
	string_length('http://www.semanticweb.org/young/ontologies/2014/6/unibo#Department_of_',Length),
	sub_string(String,Length,_,0,Sub),!.

% eliminate prefix
% 'http://www.semanticweb.org/young/ontologies/2014/6/unibo#'
elm_prefix(Category,String,Sub):-
	Category == profession,
	string_length('http://www.semanticweb.org/young/ontologies/2014/6/unibo#',Length),
	sub_string(String,Length,_,0,Sub),!.

% eliminate prefix
% 'http://www.semanticweb.org/young/ontologies/2014/6/unibo#'
elm_prefix(Category,String,Sub):-
	Category == course,
	string_length('http://www.semanticweb.org/young/ontologies/2014/6/unibo#',Length),
	sub_string(String,Length,_,0,Sub),!.


% elimate postfix '_2014'
elm_postfix(String,Sub):-
	sub_string(String,0,_,5,Sub).

extract_ind_name(Category,PreIndPost,Name):-
	elm_prefix(Category,PreIndPost,Temp),
	elm_postfix(Temp,Name).
