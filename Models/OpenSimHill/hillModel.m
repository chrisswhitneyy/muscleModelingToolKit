%{
This function will simulated mouse data ala a Hill model (see Thelen2003)
This function was adopted from the complete description of the Thelen 2003
provided by Chand T. John.

Written by Dan Rivera 6/18/2018

%}

function simulatedHill = hillModel(data,params)
%% Define simulatedHill struct and length of simulation.
simulatedHill = {};
simLength = length(data.length);

%% Pre-alocate force, velocity and position struct fields.

simulatedHill.Fm = zeros(simLength,1); %muscle force - aka the force in the tendon
simulatedHill.Fa = zeros(simLength,1); %active fiber force.
simulatedHill.Fp = zeros(simLength,1); %passive fiber force component.
simulatedHill.Fce = zeros(simLength,1); %contractile element force
simulatedHill.Act = zeros(simLength,1); %activation
simulatedHill.lMTU = zeros(simLength,1); %muscle tendon unit length
simulatedHill.FbarT = zeros(simLength,1); %normalized tendon force
simulatedHill.fv0 = zeros(simLength,1); %for FvInv
simulatedHill.fv1 = zeros(simLength,1); %for FvInv
simulatedHill.FvFlag = zeros(simLength,1);
simulatedHill.FvInv1 = zeros(simLength,1);
simulatedHill.FvInv2 = zeros(simLength,1);
simulatedHill.FvInv3 = zeros(simLength,1);
simulatedHill.FvInv4 = zeros(simLength,1);

simulatedHill.Ldotm = zeros(simLength,1); %muscle speed
simulatedHill.Lm = zeros(simLength,1); %muscle length
simulatedHill.Lt = zeros(simLength,1); %tendon length
simulatedHill.LtStrain = zeros(simLength,1); %tendon strain, used for Fm (aka Ft).
simulatedHill.Vmax = zeros(simLength,1); %max contractile velocity as a function of activation

simulatedHill.FvInv = zeros(simLength,1); %inverted FV used to get Lbardotm
simulatedHill.ActiveFl = zeros(simLength,1); %gaussian AFL relationship
simulatedHill.PassiveFl = zeros(simLength,1); %exponential PFL relationship


%% define model displacements based on zero force condition (no tendon strain)
simulatedHill.Lm(1) = data.length(1) - params.Lts;
%% define initial activation.
%{
testTime = find(data.time <= 0.035);
testTime = testTime(end);
normVelocity = (data.length(testTime) - data.length(1))/(data.time(testTime)*params.Lm0);

if normVelocity > 2
data.act(1:testTime) = .5;
end
%}
%% Define constants used throughout simulation.
dt = data.time(2); % assuming that time vector contains constant increments.
%% Begin simulation.

for iHill = 1:simLength
    %% update current inputs.

    %make sure Activation is at reasonable level for model not to fail -
    Act = data.act(iHill);
    if Act < 0.05
        Act = 0.05;
    end
    lMTU = data.length(iHill);
    Lm = simulatedHill.Lm(iHill);

    %% get length of tendon
    Lt = lMTU - Lm; %MTU - muscle length = length of the tendon.

    %% get the tendon strain.
    LtStrain = (Lt - params.Lts)/params.Lts; %regular strain calc.

    %% get the force in the tendon as a function of tendon strain.

    strainFactor = .001*(1 + LtStrain);

    if LtStrain > params.EtToe %tendon strain

        FbarT = strainFactor + params.Klin*(LtStrain - params.EtToe) + params.FBarTToe;

    elseif (LtStrain <= params.EtToe && LtStrain > 0)

        FbarTNumerator = params.FBarTToe*  (exp ( (params.KtToe*LtStrain)/params.EtToe) - 1 );
        FbarTDenominator = exp(params.KtToe) - 1;

        FbarT = strainFactor + FbarTNumerator/FbarTDenominator;

    elseif LtStrain <= 0
        FbarT = strainFactor;
    else
        FbarT = 0;
    end %if statement tendon strain

    Fm = params.Fm0*FbarT; %aka the force in the tendon

    %% get the F-L relationships (active, passive)

    LbarM = Lm/params.Lm0; %normalized length relationship for FL's

    ActiveFl = exp( -(LbarM - 1)^2/(params.gamma) );

    if LbarM > (1 + params.Em0) %passiveFl

        PassiveFl = 1 + (params.Kpe/params.Em0)*(LbarM - (1+params.Em0) );

    elseif LbarM <= (1 + params.Em0)

        PassiveFlNumerator = exp(  params.Kpe*(LbarM - 1)/params.Em0) ;

        PassiveFlDenominator = exp(params.Kpe);

        PassiveFl = PassiveFlNumerator/PassiveFlDenominator;

    end %passiveFl if statement

   %% calculate the active and passive fiber force components

   Fa = Act*ActiveFl*params.Fm0; %Active

   Fp = PassiveFl*params.Fm0; %Passive

   %% Get the contractile element force

   Fce = Fm - Fp; %assumes constant pennation angle.

   %% calculate fv0 for FV relationship

   fv0Numerator = (0.95*Fa*params.FBarMLen - Fa);

   fv0Denominator = ( (2 + 2/params.af)*0.05*Fa*params.FBarMLen )/...
                   (params.FBarMLen -1) ;

   fv0 = fv0Numerator/(fv0Denominator + 0.05);

   %% calculate fv1 for FV relationship

   fv1Numerator = (0.95 + 10^-6)*Fa*params.FBarMLen - Fa;
   fv1Denominator = ( (2 + 2/params.af)*(0.05 - (10^-6))*Fa*params.FBarMLen )/ ...
                   ( params.FBarMLen -1) ;

   fv1 = fv1Numerator/(fv1Denominator + 0.05);

   %% calculate the inverted FV to find normalized muscle velocity

   %First case
        FvInvOne1= (Fce /(10^-6)) ;
        FvInvTwo1 =  ( (10^-6) - Fa)/(Fa + (10^-6)/params.af + 0.05);
        FvInvThree1 =  Fa/(Fa + 0.05)  ;
        FvInvFour1 =  Fa/(Fa + 0.05) ;

        FvInv1 = FvInvOne1*(FvInvTwo1 + FvInvThree1) - FvInvFour1;

   % 2nd Case

        FvInvNumerator2 = (Fce - Fa);
        FvInvDenominator2 = (Fa + Fce/params.af + 0.05);

        FvInv2 = FvInvNumerator2/FvInvDenominator2;

  % Third Case
        FvInvNumerator3 =  (Fce - Fa);
        FvInvDenominator3 = ( (2 + 2/params.af)*(Fa*params.FBarMLen - Fce) )/ ...
                   ( params.FBarMLen - 1 ) ;

        FvInv3 = FvInvNumerator3/(FvInvDenominator3 + 0.05);

  %Fourth Case

        FvInvOne4 = fv0;
        FvInvTwo4 = Fce - 0.95*Fa*params.FBarMLen;
        FvInvThree4 = (10^-6)*Fa*params.FBarMLen;
        FvInvFour4 = (fv1-fv0);

        FvInv4 = FvInvOne4 + (FvInvTwo4/FvInvThree4)*FvInvFour4;

    if Fce < 0 %inverted FV

        FvInv = FvInv1;

        FvFlag = .25;

    elseif Fce >= 0 && Fce < Fa

        FvInv = FvInv2;
        FvFlag = .5;

    elseif Fce >= 1*Fa && Fce < .95*Fa*params.FBarMLen

        FvInv = FvInv3;
        FvFlag = .75;

    elseif Fce >= .95*Fa*params.FBarMLen

        FvInv = FvInv4;
        FvFlag = 1;

    end%if inverted FV.


    %% calculate vmax and get true muscle velocity

    vMax = (5 + 5*Act)*params.Lm0;

    LdotM = FvInv*vMax;

   % if isnan(LdotM)
    %    newLm = Lm;
    %else
    newLm = Lm + LdotM*dt; %This is the next Lm used for this calculation.
   % end

    %% Update quantities in simulatedHill struct.

    simulatedHill.Fm(iHill) = Fm; %muscle force - aka the force in the tendon
    simulatedHill.Fa(iHill) = Fa; %active fiber force.
    simulatedHill.Fp(iHill) = Fp; %passive fiber force component.
    simulatedHill.Fce(iHill) = Fce; %contractile element force
    simulatedHill.Act(iHill) = Act; %activation
    simulatedHill.lMTU(iHill) = lMTU; %muscle tendon unit length
    simulatedHill.FbarT(iHill) = FbarT; %normalized tendon force

    simulatedHill.Ldotm(iHill) = LdotM; %muscle speed
    simulatedHill.Lm(iHill+1) = newLm; %next muscle length;
    simulatedHill.Lt(iHill) = Lt; %tendon length
    simulatedHill.LtStrain(iHill) = LtStrain; %tendon strain, used for Fm (aka Ft).
    simulatedHill.Vmax(iHill) = vMax; %max contractile velocity as a function of activation
    simulatedHill.fv0(iHill) = fv0; %for FvInv
    simulatedHill.fv1(iHill) = fv1; %for FvInv
    simulatedHill.FvFlag(iHill) = FvFlag;
    simulatedHill.FvInv1(iHill) = FvInv1;
    simulatedHill.FvInv2(iHill) = FvInv2;
    simulatedHill.FvInv3(iHill) = FvInv3;
    simulatedHill.FvInv4(iHill) = FvInv4;

    simulatedHill.FvInv(iHill) = FvInv; %inverted FV used to get Lbardotm
    simulatedHill.ActiveFl(iHill) = ActiveFl; %gaussian AFL relationship
    simulatedHill.PassiveFl(iHill) = PassiveFl; %exponential PFL relationship

end % for loop iHill

end %function
