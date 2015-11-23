clear all
close all

source "pmc.m"
load "dataSetTP2.dat"

%ress=[[1:256] ;res_test];
figure();
plot([1:256],res_test(1,:),[1:256],res_app(1,:))
%plot(ress(1,:),res_test(1,:))


