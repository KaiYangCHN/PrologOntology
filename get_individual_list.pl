:- module(get_individual_list,
	  [
	      get_ind_list/3,   % +Category, +ParentIndividual, ?Result
	      loc_list/2,	% +Category, +List
%	      add_ind/3,
	      init/0
	  ]).
:-use_module(library(semweb/rdf_db)).
:-use_module(extract_ind_name).
:-use_module(wrap_ind_name).
:-dynamic loc_list/2.
:-rdf_register_ns(unibo,'http://www.semanticweb.org/young/ontologies/2014/6/unibo#').

loc_list(campus,[]).
loc_list(school,[]).
loc_list(department,[]).
loc_list(profession,[]).
loc_list(course,[]).

%%----------------------------OWL-----------------------------------%%
% X = unibo#Computer_Architecture
% Y = 'http://www.w3.org/2000/01/rdf-schema#subClassOf',
% Z = unibo#Course
% rdf(X,rdfs:subClassOf,unibo:'Course')

% X = unibo#Computer_Architecture_2014'
% Y = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
% Z = 'http://www.w3.org/2002/07/owl#NamedIndividual'

% X = unibo#Computer_Architecture_2014, Individual
% Y = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
% Z = unibo#Computer_Architecture   Class
% rdf(W,rdf:type,X)

% X = unibo#Computer_Architecture_2014
% Y = unibo#hasType
% Z = unibo#LaureaMagistrale

% X = unibo#Bologna_Campus_2014
% Y = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type
% Z = 'http://www.w3.org/2002/07/owl#NamedIndividual'
%%-------------------------------------------------------------------%%

% according the parent individual get all of the child individuals
% give a school,can get all of the individuals of department,get
% department can get all of the professions.

get_ind_list(Category,CamInd,CamList):-
	Category == campus,
	rdf(CamCls,rdfs:subClassOf,unibo:'Campus'),
	rdf(CamInd,rdf:type,CamCls),
	extract_ind_name(Category,CamInd,Name),
	add_ind(Name,Category,CamList),
	fail.

get_ind_list(Category,CamIndName,SchList):-
	Category == school,
	wrap_ind_name(campus,CamIndName,CamInd),
	rdf(CamInd,unibo:hasPart,SchInd),
	rdf(SchCls,rdfs:subClassOf,unibo:'School'),
	rdf(SchInd,rdf:type,SchCls),
	extract_ind_name(Category,SchInd,Name),
	add_ind(Name,Category,SchList),
	fail.

get_ind_list(Category,SchIndName,DepList):-
	Category == department,
	wrap_ind_name(school,SchIndName,SchInd),
	rdf(SchInd,unibo:hasPart,DepInd),
	rdf(DepCls,rdfs:subClassOf,unibo:'Department'),
	rdf(DepInd,rdf:type,DepCls),
	extract_ind_name(Category,DepInd,Name),
	add_ind(Name,Category,DepList),
	fail.

get_ind_list(Category,DepIndName,ProList):-
	Category == profession,
	wrap_ind_name(department,DepIndName,DepInd),
	rdf(DepInd,unibo:hasPart,ProInd),
	rdf(ProCls,rdfs:subClassOf,unibo:'Profession'),
	rdf(ProInd,rdf:type,ProCls),
	rdf(ProInd,unibo:hasType,unibo:'LaureaMagistrale'),
	extract_ind_name(Category,ProInd,Name),
	add_ind(Name,Category,ProList),
	fail.

get_ind_list(Category,ProIndName,CouList):-
	Category == course,
	wrap_ind_name(profession,ProIndName,ProInd),
	rdf(ProInd,unibo:hasCourse,CouInd),
%	rdf(CouCls,rdfs:subClassOf,unibo:'Course'),
%	rdf(CouInd,rdf:type,CouCls),
	extract_ind_name(Category,CouInd,Name),
	add_ind(Name,Category,CouList),
	fail.

get_ind_list(Category,_,List):-loc_list(Category,List).

%get_ind_list(_,_,_).


add_ind(NewInd,Category,NewList):-
	loc_list(Category,OldList),
	string(NewInd),
	atom_string(NewIndAtom,NewInd),
	append([NewIndAtom],OldList,NewList),
	retract(loc_list(Category,OldList)),
	asserta(loc_list(Category,NewList)).

init:-
	abolish(loc_list/2),
	asserta(loc_list(campus,[])),
	asserta(loc_list(school,[])),
	asserta(loc_list(department,[])),
	asserta(loc_list(profession,[])),
	asserta(loc_list(course,[])).
