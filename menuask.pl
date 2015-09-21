:- module( menuask,
	  [
	       menuask/0,
	       check_lm/1,
	       retry/1
	  ]).
:-use_module(library(semweb/rdf_db)).
:-use_module(wrap_ind_name).
:-use_module(get_individual_list).

% check if user has studied a course that has also the
% programme in LM
check_lm(ProL):-
	read(ProL),
	wrap_ind_name(profession,ProL,Result),
	rdf(Result,unibo:hasType,unibo:'LaureaMagistrale').

% ask which category,direction ecc the user want to study
menuask:-
	init,
	ask(campus,CamSltd),
	ask(school,CamSltd,SchSltd),
	ask(department,SchSltd,DepSltd),
	ask(profession,DepSltd,Re),
	retry(Re).

% retry the whole programme
retry(yes):-
	go,!.
retry(_):-
	fail.

ask(Category,Input):-
	Category == campus,
	nl,write('Which city you want to study in?'),nl,nl,
	menu(Category,Input),!.

ask(Category,Input,Re):-
	Category == profession,
	nl,write('You can study:'),nl,nl,
	get_ind_list(Category,Input,ProList),
	write(ProList),nl,
	consult_course(course,ProList),
	nl,write('Want to retry(yes or no)?'),nl,nl,
	read(Re).

ask(Category,Input,NewInput):-
	Category == school,
	nl,write('Which category you want to study?'),nl,nl,
	menu(Category,Input,NewInput),!.

ask(Category,Input,NewInput):-
	Category == department,
	nl,write('Which direction you want to study?'),nl,nl,
	menu(Category,Input,NewInput),!.

% get all courses of a selected profession
consult_course(course,List):-
	nl,write('Choose one of the profession,can visit the courses.'),nl,nl,
%	read(ProSlt),
%	check_val(ProSlt,List),
	menu_cou(course,ProSlt,List),
	get_ind_list(course,ProSlt,CouList),
	nl,write('The courses are:'),nl,nl,
	write(CouList),nl,nl,
	write('Visit courses of other profession(yes or no)?'),nl,nl,
	read(ReVisit),
	re_consult(ReVisit,List),!.

% receive the ProSlt as a profession sleected,and check if this
% input is legal
menu_cou(course,ProSlt,List):-
	repeat,
	read(ProSlt),
	check_val(ProSlt,List),
	member(ProSlt,List).

% reconsult the courses of other profession
re_consult(yes,List):-
	% delete the data created last query
	retract(loc_list(course,_List)),
	asserta(loc_list(course,[])),
	consult_course(_,List),!.

re_consult(_,_).

% when category is [campus],list all its schools,
% school selected is Input
menu(Category,Input):-
	get_ind_list(Category,_,CamList),
	write(CamList),nl,nl,
	repeat,
	read(Input),
	check_val(Input,CamList),
	member(Input,CamList),!.

% Input can be one of [school]/[department],according
% to Input,list all schools/departments,term
% selected is NewInput
menu(Category,Input,NewInput):-
	get_ind_list(Category,Input,List),
	write(List),nl,nl,
	repeat,
	read(NewInput),
	check_val(NewInput,List),
	member(NewInput,List),!.

% check if the input is a legal value
check_val(X,MenuList):-
	member(X,MenuList), !.

check_val(X,_):-
	nl,write(X),write(' is not a legal value, try again.'), nl,nl.
