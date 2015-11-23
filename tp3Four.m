clear all
close all

source "pmc.m";
load "dataSetTP1.dat"
load "dataInvNormRandDiscri.dat"


resSort=sortrows(RES,-3);

RES = [];
res_app=[];
res_test=[];

for k=1:2
	for l=1:2
		for m=1:2
			for o=1:2



	bestPix=resSort(1:100);

	%% On recupere toutes la lignes des 30 meilleurs colonnes - pixel
	vall_app=xapp(:,bestPix);
	vall_test=xtest(:,bestPix);


	%% Base log -> Dichotomie

	%%  [TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{10,10});
	 	[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{k,l,m,o});



	ErrorRateApp = test_classif_pmc(vall_app,Ya,pmc);
	ErrorRateTest = test_classif_pmc(vall_test,Yt,pmc);

	res_app=[res_app,ErrorRateApp];
	res_test=[res_test,ErrorRateTest];

	RES = [RES;[k,l,m ,ErrorRateApp, ErrorRateTest]];

end
end
end
end


save dataSetTP3Four.dat RES res_app res_test

%% Feature selection
%% Courbe / Principe, comment vous avez fait vos choix ?
%% Utiliser des thermes maths.
%% Algo determiné le nombre de couche.
%% 3 Pages.
%% Note qui la écrit.
%% 