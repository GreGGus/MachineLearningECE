clear all
close all

source "pmc.m"
load "dataset-sorted-30.dat"

%ress=[[1:150] ;res_test];
figure();
plot([1:150],res_test(1,:))
%plot(ress(1,:),res_test(1,:))


