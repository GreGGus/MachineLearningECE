clear all
close all

source "pmc.m";
%load "dataInvNormRandDiscri.dat"

load "usps_napp10.dat"




%% Inversion des données

[xapp,yapp,xtest,ytest]=invert(xapp,yapp,xtest,ytest);



%% Random data

[xapp, yapp]=randomize_data(xapp,yapp,4000);
[xtest,ytest]=randomize_data(xtest,ytest,4000);

%% Normalisation des data


%%(division par la valeur max(max(xapp,xtest))

[xapp]=normalizeData(xapp);
[xtest]=normalizeData(xtest);




Ya=change_Y_discri(yapp);
Yt=change_Y_discri(ytest);



h = waitbar(0,'Please wait...');




RES = [];



%% Apprentissage boucle pixel par pixel

for i=1:size(xapp,2)
	%for i=1:2


	iteration = strcat("Calculs pour ",int2str(i));
	waitbar(i / 256,h,iteration);


	[TEA, TET, pmc]=apprend_pmc(xapp(:,i),Ya,xtest(:,i),Yt,0.01,{10,10});

	ErrorRateApp = test_classif_pmc(xapp(:,i),Ya,pmc);
	ErrorRateTest = test_classif_pmc(xtest(:,i),Yt,pmc);


%%	res=[res_app,res_test];
%%	RES=[RES;res];


	  RES = [RES; [i,ErrorRateApp, ErrorRateTest]];


end

close(h);


%% Sauvegarde
save dataTest3.dat RES xapp xtest Ya Yt

