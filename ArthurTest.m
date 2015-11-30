clear all
close all

source "pmc.m";
load "dataTest2.dat"

res=sortrows(RES, -3);

RES=[];

pix=res([1:120], 1);

val_app=xapp(:, pix);
val_test=xtest(:, pix);

for i=0.01:0.001:0.04

	[TEA, TET, pmc]=apprend_pmc(val_app,Ya,val_test,Yt,i,{10, 10});

	ErrorRateApp = test_classif_pmc(val_app,Ya,pmc);
	ErrorRateTest = test_classif_pmc(val_test,Yt,pmc);


	RES = [RES; [i, ErrorRateApp, ErrorRateTest]];

	save Find_pas_0-01_0-001_0-06.dat RES

endfor