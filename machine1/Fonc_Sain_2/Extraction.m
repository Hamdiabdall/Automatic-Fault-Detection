clc
NOM=ls('acc_*.csv');
INDICATEUR=[];
for i=10:70
    i
    Numero_fichier=i;
    X= importdata(NOM(Numero_fichier,:));      % importation de contenu du fichier acc_0001
    N=25600;
    Vibh = X(:,2);                      % extraction du signal vibratoire horizontal
    %% Extraction des parametres (indicateurs) de degradation
    %% Energie du signal vibratoire E
    E=sum(Vibh.^2);
    %% Puissance du signal vibratoire)
    P=(1/N)* sum(Vibh.^2);
    %% Amplitude crete
    VibhA=abs(Vibh);
    POS=find(abs(Vibh)==max(abs(Vibh)));
    SCRETE = VibhA(POS(1));
    %% Valeur moyenne
    Moyenne = mean(Vibh);
    %% Valeur efficace
    SEFF = sqrt( (1/N)* sum((Vibh- mean(Vibh)).^2));
    %% Kurtosis
    KURT =( (1/N)* sum((Vibh- mean(Vibh)).^4))/ (sqrt((1/N)*(Vibh- mean(Vibh))'*(Vibh- mean(Vibh))))^4;
    %% Facteur de crete
    FCRETE = SCRETE / SEFF;
    %% Facteur K
    FK = SCRETE * SEFF;
      
    INDICATEUR(1,i)=E;
    INDICATEUR(2,i)=P;
    INDICATEUR(3,i)=SCRETE;
    INDICATEUR(4,i)=Moyenne;
    INDICATEUR(5,i)=SEFF;
    INDICATEUR(6,i)=KURT;
    INDICATEUR(7,i)=FCRETE;
    INDICATEUR(8,i)=FK;
end
MATRICE_DONNEE {4}=INDICATEUR';
