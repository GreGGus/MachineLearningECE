##############################################################
##### Fonctions d'activations et leurs drives
##############################################################

# Fonction d'activation sigmoide
function vec=sigmo(x, alpha, beta)
vec = alpha * tanh(beta * x);
endfunction;

function vec=df_sigmo(x, alpha, beta)
vec = alpha * beta * (1- tanh(beta*x).*tanh(beta*x));
endfunction


# Fonction d'activation linaire
function vec=flin(x)
vec = x;
endfunction

# Fonction d'activation linaire
function vec=dflin(x)
vec = ones(size(x));
endfunction

# Fonction qui calcule l'activation des neurones de la couche cache.
function vec=f_ccs(x)
vec = sigmo(x, 1.7, 0.6);
endfunction

function vec=df_ccs(x)
vec = df_sigmo(x, 1.7, 0.6);
endfunction

# Fonction qui calcule l'activation des neurones de la couche de sortie.
function vec=f_sorties(x)
vec=flin(x);
endfunction

# Fonction qui calcule l'activation des neurones de la couche de sortie.
function vec=df_sorties(x)
vec=dflin(x);
endfunction


##############################################################
##### Fonction d'initialisation
##############################################################

#Fontion d'init d'un pmc
########################

function [pmc] = init_pmc (ni, no, Nccs)
nb_HL = length(Nccs); #nb_couches_cachees === Hidden Layers
couches={};
nbamont = ni;
Etats= zeros(ni,1);
Sorties= zeros(ni,1);
W=zeros(ni,1);
couches{1}={Etats, Sorties, W, "flin", "dflin"};

for h=1:nb_HL
	# Vecteur de poids entre les neurones de la couche entre vers ceux de la couche cache ; initialis alatoirement
	nbaval = Nccs{h};
	Etats = zeros(nbaval,1);
	Sorties = zeros(nbaval,1);
	W = 1/ sqrt(nbamont) *randn(nbaval,nbamont+1);
	couches{h+1}={Etats, Sorties,  W, "f_ccs", "df_ccs"};
	nbamont = nbaval;
	end;
nbaval = no;
Etats = zeros(nbaval,1);
Sorties = zeros(nbaval,1);
W= 1/ sqrt(nbamont) * randn(no,nbamont+1);
couches{nb_HL+2} = {Etats, Sorties, W, "f_sorties", "df_sorties"};
pmc = couches;
end;

##############################################################
##### Fonctions de propagation avant
##############################################################

function [p]=put(pmc, x)
pmc{1}{1}=x;
pmc{1}{2}=x;
p=pmc;
end;

function [y, p] = propage_avant(pmc)
etat = pmc{1}{1};
for h=2:length(pmc)
	etat = [1 ; etat];
	W=pmc{h}{3};
	etat = W * etat;
	pmc{h}{1}=etat;
	f= pmc{h}{4};
	etat = feval(f, etat);
	pmc{h}{2}=etat;
	end;
y = etat;
p=pmc;
end;

##############################################################
##### Fonctions de caclul de performances
##############################################################

function [e]= calcule_perf_exemple(pmc,x,y);	
pmc = put(pmc,x);
[y_pmc, pmc]=propage_avant(pmc);
e = norm (y_pmc - y);
end;


function [E] = calcule_perf(pmc,X,Y)
Es=[];
## Iteration sur la base 	
for k=1:size(X,1);
	Es= [Es, calcule_perf_exemple(pmc,X(k,:)',Y(k,:)')];	
	end; 
E = mean(Es);
end;


function [EA, ET] = calcule_perfs(pmc,Xa,Ya,Xt,Yt)
EA= calcule_perf(pmc,Xa,Ya);
ET= calcule_perf(pmc,Xt,Yt);
end;

##############################################################
##### Fonction pour une itration d'apprentissage
##############################################################

function [p] = retro_propage(pmc, deltas, epsi)
NBC=length(pmc); #couches
ai = pmc{NBC}{1};
df=pmc{NBC}{5};
Deltas = 2* deltas .* feval(df, ai);

for k=NBC:-1:2
	
	W= pmc{k}{3};
	zi = [1 ; pmc{k-1}{2}]; 
	DW = Deltas *  zi';
	pmc{k}{3}=W - epsi*DW;
	
	
	df=pmc{k-1}{5};
	ai = pmc{k-1}{1};
	dai = feval(df, ai);
	dai = [1 ; dai];
	
	
	Deltas = (W' * Deltas) .* dai;
	N=length(pmc{k-1}{1})+1;
	Deltas = Deltas(2:N,:);
	end;
p=pmc;
end;


function [p] = apprend_un_exemple(pmc, x, y, epsi)
pmc = put(pmc,x);
[y_pmc, pmc]=propage_avant(pmc);
deltas=y_pmc-y;
p = retro_propage(pmc, deltas, epsi);
end;


function [p] = apprend_une_ite(pmc, X, Y, epsi)
for k=1:size(X,1);
	pmc=apprend_un_exemple(pmc, X(k,:)', Y(k,:)', epsi);
	end;
p=pmc;
end;


##############################################################
##### Fonction qui implemente le perceptron multi-couche
##############################################################
function [TEA,TET, pmc]= apprend_pmc(Xa,Ya,Xt,Yt,epsi,NB_ccs)

#Initialisation des variables 

NITE_MAX = 20;
Rate_Epsi = 0.99;
TEA = []; 
TET = [];
classe  = [];
classe1 = [];
classe2 = [];
pb = []; #proba a posteriori

nb_inputs= size(Xa)(2);
nb_outputs=size(Ya)(2);

#### INIT du PMC

pmc=init_pmc(nb_inputs, nb_outputs, NB_ccs);
[EA,ET] = calcule_perfs(pmc, Xa, Ya, Xt, Yt);
TEA=[TEA, EA];
TET=[TET, ET];
#### Iterations 
for i=1:NITE_MAX # Nombre d iterations

	pmc = apprend_une_ite(pmc, Xa, Ya, epsi);

	epsi *= Rate_Epsi;
	[EA,ET] = calcule_perfs(pmc, Xa, Ya, Xt, Yt);
	TEA=[TEA, EA];
	TET=[TET, ET];

	if ( abs(TEA(i+1)-TEA(i))/TEA(i) <0.001) break; endif;

	end 
endfunction;


#####################################################################
##### Fonction qui teste le perceptron multi-couche en classification
#####################################################################


function [classe_reconnue] = classifie_pmc(pmc, x)
pmc = put(pmc,x);
[y_pmc, pmc]=propage_avant(pmc);
[score_max, classe_reconnue ] = max(y_pmc');
endfunction;


function [ErrorRate]= test_classif_pmc(X,Y,pmc)

#Initialisation des variables 
NbExemples=size(X)(1);
classe  = [];
classeReelle = [];
pb = []; #proba a posteriori

for i=1:NbExemples
	Classe(i) = classifie_pmc(pmc, X(i,:)');
	[maxi,indice]= max(Y(i,:));
	ClasseReelle(i) = indice; 
	end 
Temp= Classe-ClasseReelle;
ErrorRate= length(find(Temp==0)) / NbExemples;
endfunction;


#####################################################################
##### Fonction qui change l'indice des classes
#####################################################################

function [Y] = change_Y_discri(Yold)
nbclasses = max(Yold);
Y=zeros(length(Yold), nbclasses);
for i=1:nbclasses
	indis=find(Yold==i);
	Y(indis, i)=1;
	end;
end;

function [X,Y] = randomize_data(X,Y,n)
for i=1:n
  id = ceil(rand*size(Y,1));
  id2 = ceil(rand*size(Y,1));
  temp = X(id,:);
  X(id,:) = X(id2,:);
  X(id2,:) = temp;
  temp = Y(id,:);
  Y(id,:) = Y(id2,:);
  Y(id2,:) = temp;
end
end;
