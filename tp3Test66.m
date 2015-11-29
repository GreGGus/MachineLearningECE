clear all
close all

source "pmc.m";
load "dataSetTP1.dat"
load "dataInvNormRandDiscri.dat"


resSort=sortrows(RES,-3);

h = waitbar(0,'Please wait...');


RES = [];
res_app=[];
res_test=[];

	bestPix=resSort(1:160);

	%% On recupere toutes la lignes des 30 meilleurs colonnes - pixel
	vall_app=xapp(:,bestPix);
	vall_test=xtest(:,bestPix);

	for l=1:160
	

	iteration = strcat("Calculs pour ",int2str(l));
	waitbar(l/ 160,h,iteration);


	%% Base log -> Dichotomie

	%%  [TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{10,10});
	 	[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{l,60,10});



	ErrorRateApp = test_classif_pmc(vall_app,Ya,pmc);
	ErrorRateTest = test_classif_pmc(vall_test,Yt,pmc);

	res_app=[res_app,ErrorRateApp];
	res_test=[res_test,ErrorRateTest];

	RES = [RES;[l,60,10 ,ErrorRateApp, ErrorRateTest]];

end


save dataSetTP3FixedFirstAndLast653.dat RES res_app res_test

%% Feature selection
%% Courbe / Principe, comment vous avez fait vos choix ?
%% Utiliser des thermes maths.
%% Algo determiné le nombre de couche.
%% 3 Pages.
%% Note qui la écrit.
%% 