:- include(tubes).

:- include(test_set_c).

join(A,B,C) :-
   get_all_node_ids(A,B,D), filter_angular_distance(D,A,B,[30.0],E), select_closest_node(E,A,B,[0.002],C), !.

join(A,B,C) :-
   get_all_node_ids(A,B,D), precond_cylinder_len_gt(A,B,[0.05]), precond_avg_angle_gt(A,B,[20.0]), select_closest_node(D,A,B,[0.002],C), !.

join(A,B,C) :-
   get_all_node_ids(A,B,D), filter_faraway_points(D,A,B,[0.03],E), select_closest_node(E,A,B,[0.0],C), !.

join(A,B,C) :-
   get_all_node_ids(A,B,D), precond_cylinder_len_leq(A,B,[0.05]), select_closest_node(D,A,B,[0.002],C), !.

test:-
	findall(ExampleID-Node1ID,join_positive(ExampleID,Node1ID,_),AllPositives),
	findall(ExampleID-Node1ID,(join_positive(ExampleID,Node1ID,Node2ID),join(ExampleID,Node1ID,Node2ID)),TruePositives),
	
	findall(ExampleID-Node1ID,join_negative(ExampleID,Node1ID,_),AllNegatives),
	findall(ExampleID-Node1ID,(join_negative(ExampleID,Node1ID,Node2ID),join(ExampleID,Node1ID,Node2ID)),FalsePositives),
	
	length(AllPositives,NPositives),
	length(TruePositives,TP),
	FN is NPositives - TP,
	
	length(AllNegatives,NNegatives),
	length(FalsePositives,FP),
	TN is NNegatives - FP,
	
	PredictedP is TP + FP,
	PredictedN is FN + TN,
	
	Accuracy is (TP + TN) / (TP + FP + FN + TN),
	Sensitivity is TP / (TP + FN),
	Specitivity is TN / (TN + FP),
	Precision is TP / (TP + FP),
	F1Score is (2*TP) / (2*TP + FP + FN),
	
	write('     +   '), write('-'), nl,
	write('+   '), write(TP), write('   '), write(FP), write('   '), write(PredictedP), nl,
	write('-   '), write(FN), write('   '), write(TN), write('   '), write(PredictedN), nl,
	write('    ' ), write(NPositives), write('   '), write(NNegatives), nl,
	
	nl,
	write('Accuracy = '), write(Accuracy), nl,
	write('Sensitivity = '), write(Sensitivity), nl,
	write('Specitivity = '), write(Specitivity), nl,
	write('Precision = '), write(Precision), nl,
	write('F1Score = '), write(F1Score), nl.