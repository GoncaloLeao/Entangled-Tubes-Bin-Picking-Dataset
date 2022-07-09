% Utilitary predicates for working with vectors.

vec_norm(V,N):-
	vec_dot_product(V,V,SN),
	N is sqrt(SN).
	
vec_normaliza(V,VN):-
	vec_norm(V,N),
	N > 0, !,
	vec_normalize_aux(V,N,VN).
vec_normaliza(V,V).
	
vec_normalize_aux([],_,[]).
vec_normalize_aux([X|Xs],N,[XN|XNs]):-
	XN is X / N,
	vec_normalize_aux(Xs,N,XNs).
	
vec_dot_product(V1,V2,P):-
	vec_dot_product_aux(V1,V2,0,P).
	
vec_dot_product_aux([],[],P,P).
vec_dot_product_aux([X1|X1s],[X2|X2s],Acc,P):-
	Acc1 is Acc + X1*X2,
	vec_dot_product_aux(X1s,X2s,Acc1,P).
	
% Reference: https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
vec_2D_cross_product([X1,Y1],[X2,Y2],P):-
	P is X1*Y2 - X2*Y1.
	
vec_3D_cross_product([X1,Y1,Z1],[X2,Y2,Z2],[Px,Py,Pz]):-
	Px is Y1*Z2 - Z1*Y2,
	Py is Z1*X2 - X1*Z2,
	Pz is X1*Y2 - Y1*X2.
	
% yUpRayIntersectsSegments(+Point,+SegmentStartingPoint,+SegmentEndingPoint).
yUpRayIntersectsSegments([Px,Py],[Ax,Ay],[Bx,By]):-
	PAx is Px - Ax,
	PAy is Py - Ay,
	Dx is Bx - Ax,
	Dy is By - Ay,
	vec_2D_cross_product([PAx, PAy], [Dx, Dy], Prod),
	S is Prod / Dx,
	S >= 0.0,
	T is PAx / Dx,
	T >= 0.0,
	T =< 1.0.
	
createPolygonLineSegments(Ps,[[Last,First]|Ls1]):-
	createPolygonLineSegments_aux(Ps,Ls1),
	Ps = [First | _],
	last(Ps, Last).
	
createPolygonLineSegments_aux([],[]).
createPolygonLineSegments_aux([_],[]).
createPolygonLineSegments_aux([P1,P2|Ps],[[P1,P2]|Ls]):-
	createPolygonLineSegments_aux([P2|Ps],Ls).
	
isPointInsidePolygon(P,Poly):-
	createPolygonLineSegments(Poly,Ls),
	isPointInsidePolygon_aux(Ls,P,0,Ct),
	write(Ct), nl,
	Ct mod 2 =:= 1.
	
isPointInsidePolygon_aux([],_,Ct,Ct).
isPointInsidePolygon_aux([[A,B]|Ls],P,Acc,Ct):-
	(yUpRayIntersectsSegments(P,A,B), !, Acc1 is Acc + 1;
	Acc1 = Acc),
	isPointInsidePolygon_aux(Ls,P,Acc1,Ct).
	
% to test
% _Poly = [[0,0],[1,0],[1.5,0.5],[0.5,0.5]], createPolygonLineSegments(_Poly,Ls).
% _Poly = [[0,0],[1,0],[1.5,0.5],[0.5,0.5]], isPointInsidePolygon([0,0],_Poly).
% _Poly = [[0,0],[1,0],[1.5,0.5],[0.5,0.5]], isPointInsidePolygon([0.5,0.25],_Poly).
% _Poly = [[0,0],[1,0],[1.5,0.5],[0.5,0.5]], isPointInsidePolygon([0.5,0.75],_Poly).
	