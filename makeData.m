clear all
close all

source "pmc.m";
load "usps_napp10.dat"




%% Inversion des données


tmpX = xapp;
tmpY = yapp;
xapp=xtest;
yapp=ytest;
xtest=tmpX;
ytest=tmpY;

%% Normalisation des data


%%(division par la valeur max(max(xapp,xtest))

xapp=xapp/max(max(xapp));
xtest=xtest/max(max(xtest));


%% Random data

[xapp, yapp]=randomize_data(xapp,yapp,1000);
[xtest, ytest]=randomize_data(xtest,ytest,1000);


Ya=change_Y_discri(yapp);
Yt=change_Y_discri(ytest);

save dataInvNormRandDiscri.dat xapp xtest yapp ytest Ya Yt