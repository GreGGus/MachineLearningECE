clear all
close all

source "pmc.m";
load "dataSetTP1.dat"
load "dataInvNormRandDiscri.dat"


resSort=sortrows(RES,-3);

RES = [];
res_app=[];
res_test=[];

r=0;
x=1;
min1=1;
min2=1;
min3=1;
max1=50;
max2=50;
max3=50;
a=0;
b=0;


bestPix=resSort(1:120);

	%% On recupere toutes la lignes des 30 meilleurs colonnes - pixel
	vall_app=xapp(:,bestPix);
	vall_test=xtest(:,bestPix);

	while (max1 >= min1 + x )


	[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,min2,min3});
	a = test_classif_pmc(vall_test,Yt,pmc);

	[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,min2,min3});
	b = test_classif_pmc(vall_test,Yt,pmc);

	if(a>b)
		max1=max1-(max1-min1)/2;

		[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,min2,min3});
		a = test_classif_pmc(vall_test,Yt,pmc);

		[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,max2,min3});
		b = test_classif_pmc(vall_test,Yt,pmc);

		if(a>b)

			max2=max2-(max2-min2)/2;
			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,min2,min3});
			a = test_classif_pmc(vall_test,Yt,pmc);

			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,min2,max3});
			b = test_classif_pmc(vall_test,Yt,pmc);

			if(a>b && a>r)
				max3=max3-(max3-min3)/2;
				r=a;
				printf(" %d %d %d %f", min1,min2,min3,r)
				RES = [RES; r ,min1,min2,min3];


			elseif( a<b && b>r)
				min3=min3 + (max3-min3)/2;
				r=b;
				printf(" %d %d %d %f", min1,min2,max3,r)
				RES = [RES; r ,min1,min2,max3];


			endif
		
		elseif(a<b) 

			min2=min2+(max2-min2)/2;
			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,max2,min3});
			a = test_classif_pmc(vall_test,Yt,pmc);

			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{min1,max2,max3});
			b = test_classif_pmc(vall_test,Yt,pmc);

			if(a>b )
				max3=max3 -(max3-min3)/2;
				r=a;
				printf(" %d %d %d %f", min1,max2,min3,r)
				RES = [RES; r ,min1,max2,min3];

			else
				min3=min3+(max3-min3)/2;
				r=b;
				printf(" %d %d %d %f", min1,max2,max3,r)
				RES = [RES; r ,min1,max2,max3];


			endif

		endif


	elseif(b>a) 	
	min1=min1 + (max1-min1)/2;

		[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,min2,min3});
		a = test_classif_pmc(vall_test,Yt,pmc);

		[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,max2,min3});
		b = test_classif_pmc(vall_test,Yt,pmc);

		if(a>b)

			max2=max2-(max2-min2)/2;
			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,min2,min3});
			a = test_classif_pmc(vall_test,Yt,pmc);

			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,min2,max3});
			b = test_classif_pmc(vall_test,Yt,pmc);

			if(a>b )
				max3=max3-(max3-min3)/2;
				r=a;
				printf(" %d %d %d %f", max1,min2,min3,r)
				RES = [RES; r ,max1,min2,min3];
			else
				min3=min3 + (max3-min3)/2;
				r=b;
				printf(" %d %d %d %f", max1,min2,max3,r)
				RES = [RES; r ,max1,min2,max3];


			endif
		elseif(a<b)
			min2=min2+(max2-min2)/2;
			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,max2,min3});
			a = test_classif_pmc(vall_test,Yt,pmc);

			[TEA, TET, pmc]=apprend_pmc(vall_app,Ya,vall_test,Yt,0.01,{max1,max2,max3});
			b = test_classif_pmc(vall_test,Yt,pmc);

			if(a>b && a>r)
				max3 = max3 - (max3-min3)/2;
				r=a;
				printf(" %d %d %d %f", max1,max2,min3,r)
				RES = [RES; r ,max1,max2,min3];

			elseif (a<b && b>r)
				min3=min3+(max3-min3)/2;
				r=b;
				printf(" %d %d %d %f", max1,max2,max3,r)
				RES = [RES; r ,max1,max2,max3];


			endif

		endif
	endif



		%%		ErrorRateApp = test_classif_pmc(vall_app,Ya,pmc);
		%%		ErrorRateTest = test_classif_pmc(vall_test,Yt,pmc);

				%res_app=[res_app,r];
				%res_test=[res_test,ErrorRateTest];

			

	endwhile



save dataSetTP3ThreeAlgoTest6.dat RES res_app res_test

%% Feature selection
%% Courbe / Principe, comment vous avez fait vos choix ?
%% Utiliser des thermes maths.
%% Algo determiné le nombre de couche.
%% 3 Pages.
%% Note qui la écrit.
%%

