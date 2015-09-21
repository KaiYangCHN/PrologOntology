:- module(get_all_class,
	  [ add_pre_post_fix/3   % +Category, +String, ?Result
	  ]).

:-use_module(get_individual_list).

all_dep_ind(SchList):-
	rdf(CamCls,rdfs:subClassOf,unibo:'School'), %get class of Campus
	rdf(CamInd,rdf:type,CamCls),
	rdf(CamInd,unibo:hasPart,SchInd),
	rdf(SchCls,rdfs:subClassOf,unibo:'Department'),
	rdf(SchInd,rdf:type,SchCls),
	get_ind_name(department,SchInd,Sub),
	add_ind(Sub,department,SchList),
	write(SchList),nl,fail.

all_school_ind(SchList):-
	rdf(CamCls,rdfs:subClassOf,unibo:'Campus'), %get class of Campus
	rdf(CamInd,rdf:type,CamCls),
	rdf(CamInd,unibo:hasPart,SchInd),
	rdf(SchCls,rdfs:subClassOf,unibo:'School'),
	rdf(SchInd,rdf:type,SchCls),
	get_ind_name(school,SchInd,Sub),
	add_ind(Sub,school,SchList),
	write(SchList),nl,fail.
