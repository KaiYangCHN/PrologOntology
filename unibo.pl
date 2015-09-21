:- module( unibo,
	   [
	       go/0
	   ]).
:-use_module(library(semweb/rdf_db)).
:-use_module(get_individual_list).
:-use_module(menuask).
:-rdf_load('unibo.owl').
:-rdf_register_ns(unibo,'http://www.semanticweb.org/young/ontologies/2014/6/unibo#').

% entrace of the programme,the user input a profession which exist
% also the profession of laurea magistrale
go:-
	nl,write('Which profession you studied?'),nl,nl,
	check_lm(ProL),
	nl,write('You can study : '),nl,nl,
	write(ProL),nl,nl,
	write('Courses of this profession are:'),nl,nl,
	retract(loc_list(course,_List)),
	asserta(loc_list(course,[])),
	get_ind_list(course,ProL,CouList),
	write(CouList),nl,nl,
	write('Want to retry(yes or no)?'),nl,nl,
	read(NewInput),
	!,retry(NewInput).

% there isn't a profession of laurea magistrale,then start to ask
% question
go:-
	menuask.





