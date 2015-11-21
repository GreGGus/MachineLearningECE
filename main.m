clear all
close all

source "pmc.m";
load "dataInvNormRandDiscri.dat"


h = waitbar(0,'Please wait...');


RES = [];
res_app=[];
res_test=[];


%% Apprentissage boucle pixel par pixel

for i=1:256

	iteration = strcat("Calculs pour ",int2str(i));
	waitbar(i / 256,h,iteration);


	[TEA, TET, pmc]=apprend_pmc(xapp(:,i),Ya,xtest(:,i),Yt,0.01,{10,10});

	ErrorRateApp = test_classif_pmc(xapp(:,i),Ya,pmc);
	ErrorRateTest = test_classif_pmc(xtest(:,i),Yt,pmc);

	res_app=[res_app,ErrorRateApp];
	res_test=[res_test,ErrorRateTest];

%%	res=[res_app,res_test];
%%	RES=[RES;res];


	  RES = [RES; [i,ErrorRateApp, ErrorRateTest]];


end

close(h);


%% Sauvegarde
save dataSetTP1.dat RES  res_app res_test

