:-use_module(library(aleph)).
:- if(current_predicate(use_rendering/1)).
:- use_rendering(prolog).
:- endif.
:- aleph.

:- set_random(seed(111)).

:- aleph_set(noise,4).
:- aleph_set(clauselength,6).

:- aleph_set(i,10).
:- aleph_set(depth,2000).
:- aleph_set(nodes,100000).
:- aleph_set(language,1).
:- aleph_set(minpos,5).
%:- aleph_set(gsamplesize,20).
%:- aleph_set(verbose,1).
:- aleph_set(refine,user).
%:- aleph_set(check_useless,true).
:- aleph_set(evalfn,coverage). % Do not use posonly

:- include(helpers).


% Mode declarations
:- modeh(*,join(+example_id,+node_id,-node_id)).

:- modeb(1,get_all_node_ids(+example_id,+node_id,-node_id_list)).
:- modeb(*,precond_cylinder_len_leq(+example_id,+node_id,#params_list)).
:- modeb(*,precond_cylinder_len_gt(+example_id,+node_id,#params_list)).
:- modeb(*,precond_avg_angle_leq(+example_id,+node_id,#params_list)).
:- modeb(*,precond_avg_angle_gt(+example_id,+node_id,#params_list)).
:- modeb(*,filter_faraway_points(+node_id_list,+example_id,+node_id,#params_list,-node_id_list)).
:- modeb(*,filter_angular_distance(+node_id_list,+example_id,+node_id,#params_list,-node_id_list)).
:- modeb(*,filter_long_cylinders(+node_id_list,+example_id,+node_id,#params_list,-node_id_list)).
:- modeb(*,select_closest_node(+node_id_list,+example_id,+node_id,#params_list,-node_id)).

:- determination(join/3,get_all_node_ids/3).
:- determination(join/3,precond_cylinder_len_leq/3).
:- determination(join/3,precond_cylinder_len_gt/3).
:- determination(join/3,precond_avg_angle_leq/3).
:- determination(join/3,precond_avg_angle_gt/3).
:- determination(join/3,filter_faraway_points/5).
:- determination(join/3,filter_angular_distance/5).
:- determination(join/3,filter_long_cylinders/5).
:- determination(join/3,select_closest_node/5).

:- begin_bg.

% Types

example_id(ID):-
	atom(ID).
	
params_list([]).
params_list([P|Ps]):-
	atom(P),
	params_list(Ps).

node_id(ID):-
	integer(ID).

node_id_list([]).
node_id_list([H|T]):-
	node_id(H),
	node_id_list(T).

node(ID-X-Y-Z):-
	node_id(ID),
	float(X),
	float(Y),
	float(Z).

node_list([]).
node_list([H|T]):-
	node(H),
	node_list(T).
	
edge_list([]).
edge_list([NdID1-NdID2|T]):-
	node_id(NdID1),
	node_id(NdID2),
	edge_list(T).
	
dist_max(D):-
	float(D).

% Background knowledge

% Custom refinement operator

refine(aleph_false,
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), select_closest_node(IDs,ExampleID,Node1ID,_,Node2ID))
).

% For clause length 3.
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), P, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	precond_order(PrecondName,_),
	P =.. [PrecondName,ExampleID,Node1ID,_].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), F, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	filter_order(FilterName,_),
	F =.. [FilterName,IDs,ExampleID,Node1ID,_,FilteredIDs].

% For clause length 4.
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), P1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), P1, P2, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P1 =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	precond_order(PrecondName2,Order2),
	Order1 < Order2,
	P2 =.. [PrecondName2,ExampleID,Node1ID,_].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), P, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), P, F, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	filter_order(FilterName,Order2),
	Order1 < Order2,
	F =.. [FilterName,IDs,ExampleID,Node1ID,_,FilteredIDs].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), F1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), F11, F2, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	F1 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,_],
	filter_order(FilterName1,Order1),
	filter_order(FilterName2,Order2),
	Order1 < Order2,
	F11 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,IDs2],
	F2 =.. [FilterName2,IDs2,ExampleID,Node1ID,_,FilteredIDs].	

% For clause length 5.
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A, P1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A, P1, P2, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P1 =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	precond_order(PrecondName2,Order2),
	Order1 < Order2,
	P2 =.. [PrecondName2,ExampleID,Node1ID,_].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A, P, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A, P, F, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	filter_order(FilterName,Order2),
	Order1 < Order2,
	F =.. [FilterName,IDs,ExampleID,Node1ID,_,FilteredIDs].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A, F1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A, F11, F2, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	F1 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,_],
	filter_order(FilterName1,Order1),
	filter_order(FilterName2,Order2),
	Order1 < Order2,
	F11 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,IDs2],
	F2 =.. [FilterName2,IDs2,ExampleID,Node1ID,_,FilteredIDs].	

% For clause length 6.
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, P1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, P1, P2, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P1 =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	precond_order(PrecondName2,Order2),
	Order1 < Order2,
	P2 =.. [PrecondName2,ExampleID,Node1ID,_].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, P, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, P, F, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	filter_order(FilterName,Order2),
	Order1 < Order2,
	F =.. [FilterName,IDs,ExampleID,Node1ID,_,FilteredIDs].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, F1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, F11, F2, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	F1 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,_],
	filter_order(FilterName1,Order1),
	filter_order(FilterName2,Order2),
	Order1 < Order2,
	F11 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,IDs2],
	F2 =.. [FilterName2,IDs2,ExampleID,Node1ID,_,FilteredIDs].	

% For clause length 7.
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, P1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, P1, P2, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P1 =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	precond_order(PrecondName2,Order2),
	Order1 < Order2,
	P2 =.. [PrecondName2,ExampleID,Node1ID,_].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, P, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, P, F, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	filter_order(FilterName,Order2),
	Order1 < Order2,
	F =.. [FilterName,IDs,ExampleID,Node1ID,_,FilteredIDs].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, F1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, F11, F2, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	F1 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,_],
	filter_order(FilterName1,Order1),
	filter_order(FilterName2,Order2),
	Order1 < Order2,
	F11 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,IDs2],
	F2 =.. [FilterName2,IDs2,ExampleID,Node1ID,_,FilteredIDs].

% For clause length 8.
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, A4, P1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, A4, P1, P2, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P1 =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	precond_order(PrecondName2,Order2),
	Order1 < Order2,
	P2 =.. [PrecondName2,ExampleID,Node1ID,_].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, A4, P, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, A4, P, F, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	P =.. [PrecondName1,ExampleID,Node1ID,_],
	precond_order(PrecondName1,Order1),
	filter_order(FilterName,Order2),
	Order1 < Order2,
	F =.. [FilterName,IDs,ExampleID,Node1ID,_,FilteredIDs].
refine((join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, A4, F1, select_closest_node(IDs,ExampleID,Node1ID,SelectParams,Node2ID)),
	(join(ExampleID,Node1ID,Node2ID):-get_all_node_ids(ExampleID,Node1ID,IDs), A1, A2, A3, A4, F11, F2, select_closest_node(FilteredIDs,ExampleID,Node1ID,SelectParams,Node2ID))
):-
	F1 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,_],
	filter_order(FilterName1,Order1),
	filter_order(FilterName2,Order2),
	Order1 < Order2,
	F11 =.. [FilterName1,IDs1,ExampleID,Node1ID,Params,IDs2],
	F2 =.. [FilterName2,IDs2,ExampleID,Node1ID,_,FilteredIDs].

precond_order(precond_cylinder_len_leq,1).
precond_order(precond_cylinder_len_gt,1).
precond_order(precond_avg_angle_leq,2).
precond_order(precond_avg_angle_gt,2).

filter_order(filter_faraway_points,11).
filter_order(filter_angular_distance,12).
filter_order(filter_long_cylinders,13).


% Predicate catalog

% get_all_node_ids(+ExampleID,+NodeID1,-IDs).
get_all_node_ids(ExampleID,NodeID1,IDs):-
	findall(ID,(tube_node(ExampleID,ID,_,_,_),ID \= NodeID1),IDs).

% Preconditions

precond_cylinder_len_leq(ExampleID,NodeID1,[MaxLength]):-
	generate_cylinder_length(MaxLength),
	cylinder_length(ExampleID,NodeID1,Length),
	Length =< MaxLength.
	
precond_cylinder_len_gt(ExampleID,NodeID1,[MaxLength]):-
	generate_cylinder_length(MaxLength),
	cylinder_length(ExampleID,NodeID1,Length),
	Length > MaxLength.

precond_avg_angle_leq(ExampleID,_,[MaxAngle]):-
	generate_angle(MaxAngle),
	avg_angle(ExampleID,Angle),
	Angle =< MaxAngle.
	
precond_avg_angle_gt(ExampleID,_,[MaxAngle]):-
	generate_angle(MaxAngle),
	avg_angle(ExampleID,Angle),
	Angle > MaxAngle.
	
% Filters

% filter_faraway_points(+IDs,+ExampleID,+NodeID1,-Params,-FilteredIDs).
filter_faraway_points(IDs,ExampleID,NodeID1,[DistMax],FilteredIDs):-
	generate_euclid_dist_max(DistMax),
	filter_faraway_points_aux(IDs,ExampleID,NodeID1,DistMax,FilteredIDs).

% filter_faraway_points_aux(+IDs,+ExampleID,+NodeID1,+DistMax,-FilteredIDs).
filter_faraway_points_aux([],_,_,_,[]):- !.
filter_faraway_points_aux([ID|IDs],ExampleID,NodeID1,DistMax,[ID|FilteredIDs]):-
	endpoint_euclid_dist(ExampleID,ID,NodeID1,Dist),
	Dist =< DistMax, !,
	filter_faraway_points_aux(IDs,ExampleID,NodeID1,DistMax,FilteredIDs).
filter_faraway_points_aux([_|IDs],ExampleID,NodeID1,DistMax,FilteredIDs):-
	filter_faraway_points_aux(IDs,ExampleID,NodeID1,DistMax,FilteredIDs).

% filter_angular_distance(+IDs,+ExampleID,+NodeID1,-Params,-FilteredIDs).
filter_angular_distance(IDs,ExampleID,NodeID1,[DistMax],FilteredIDs):-
	generate_angular_dist_max(DistMax),
	filter_angular_distance_aux(IDs,ExampleID,NodeID1,DistMax,FilteredIDs).


% filter_angular_distance_aux(+IDs,+ExampleID,+NodeID1,+DistMax,-FilteredIDs).
filter_angular_distance_aux([],_,_,_,[]):- !.
filter_angular_distance_aux([ID|IDs],ExampleID,NodeID1,DistMax,[ID|FilteredIDs]):-
	endpoint_angular_dist(ExampleID,ID,NodeID1,Dist),
	Dist =< DistMax, !,
	filter_angular_distance_aux(IDs,ExampleID,NodeID1,DistMax,FilteredIDs).
filter_angular_distance_aux([_|IDs],ExampleID,NodeID1,DistMax,FilteredIDs):-
	filter_angular_distance_aux(IDs,ExampleID,NodeID1,DistMax,FilteredIDs).
	
% filter_long_cylinders(+IDs,+ExampleID,+NodeID1,-Params,-FilteredIDs).
filter_long_cylinders(IDs,ExampleID,NodeID1,[LenMax],FilteredIDs):-
	generate_cylinder_length_for_filter(LenMax),
	filter_long_cylinders_aux(IDs,ExampleID,NodeID1,LenMax,FilteredIDs).
	
filter_long_cylinders_aux([],_,_,_,[]):- !.
filter_long_cylinders_aux([ID|IDs],ExampleID,NodeID1,LenMax,[ID|FilteredIDs]):-
	cylinder_length(ExampleID,ID,Len),
	Len =< LenMax, !,
	filter_long_cylinders_aux(IDs,ExampleID,NodeID1,LenMax,FilteredIDs).
filter_long_cylinders_aux([_|IDs],ExampleID,NodeID1,LenMax,FilteredIDs):-
	filter_long_cylinders_aux(IDs,ExampleID,NodeID1,LenMax,FilteredIDs).

% Selectors

% select_closest_node(+IDs,+ExampleID,+NodeID1,-Params,-BestID).
select_closest_node(IDs,ExampleID,NodeID1,[W],BestID):-
	generate_angular_distance_weight(W),
	length(IDs,Len),
	Len > 0,
	select_closest_node_aux(IDs,ExampleID,NodeID1,W,1000000-_,_-BestID).
	
select_closest_node_aux([],_,_,_,D-ID,D-ID).
select_closest_node_aux([ID|IDs],ExampleID,NodeID1,W,AccDist-AccID,BestDist-BestID):-
	dist(ExampleID,ID,NodeID1,W,D),
	(D < AccDist, AccDist1 = D, AccID1 = ID;
	D >= AccDist, AccDist1 = AccDist, AccID1 = AccID),
	select_closest_node_aux(IDs,ExampleID,NodeID1,W,AccDist1-AccID1,BestDist-BestID).


% Generators

% generate_cylinder_length(-Length).	
%generate_cylinder_length(Length):-
	%between(0,1,C),
	%Length is 0.025*C.

generate_cylinder_length(0.05).

%generate_angle(Angle):-
	%between(20,20,Angle).
	%Angle = 20.

generate_angle(20.0).

% generate_euclid_dist_max(-DistMax).
%generate_euclid_dist_max(Dm):-
	%between(1,1,C),
	%Dm is 0.05*C.

% For filters

generate_euclid_dist_max(0.03).

% generate_angular_dist_max(-DistMax).
%generate_angular_dist_max(Dm):-
	%between(0,1,C),
	%Dm is 10 + 20*C.

generate_angular_dist_max(30.0).

% generate_cylinder_length_for_filter(-Length).	
%generate_cylinder_length_for_filter(Length):-
	%between(1,2,C),
	%Length is 0.1*C.

generate_cylinder_length_for_filter(0.1).

%generate_angular_distance_weight(-DistMax).
%generate_angular_distance_weight(W):-
%	between(0,1,C),
%	W is 0.002*C.
	
generate_angular_distance_weight(0.002).