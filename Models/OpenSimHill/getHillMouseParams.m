%%Hill Mouse Params %%
%{

Inputs: 1    Type: A file name string

Outputs: 1   Type: A struct containing scalar parameter values for the Hill (thelen) model 

This functions uses strrfind to evaluate the filename and generate 
parameters taken from experimentally recorded values particular to each
animal. 

Written by Dan Rivera

%}

%%
function hillMouseParams = getHillMouseParams(fileName)

    hillMouseParams = {};

        if strfind(fileName,'551')
       
            hillMouseParams.Fm0 = .217;     
            hillMouseParams.MTUlength0 = 12.0809;
       
        elseif strfind(fileName,'ttn413')
        
            hillMouseParams.Fm0 = .1;       
            hillMouseParams.MTUlength0 = 10.07;
       
        elseif strfind(fileName,'ttn39')
        
            hillMouseParams.Fm0 = .104;        
            hillMouseParams.MTUlength0 = 9.29;
      
        elseif strfind(fileName,'356B_tet')
        
            hillMouseParams.Fm0 = .127;      
            hillMouseParams.MTUlength0 = 10.4251;    
       
        elseif strfind(fileName,'355AL_Tetanus_')
        
            hillMouseParams.Fm0 = 0.1414;        
            hillMouseParams.MTUlength0 = 14.552;
       
        elseif strfind(fileName,'369B_tet_')
        
            hillMouseParams.Fm0 = 0.151715;        
            hillMouseParams.MTUlength0 = 11.545;
       
        elseif strfind(fileName,'366_exp')
        
            hillMouseParams.Fm0 = 0.18;        
            hillMouseParams.MTUlength0 = 14.755;
       
        elseif strfind(fileName, '415_exp')
        
            hillMouseParams.Fm0 = 0.129135;        
            hillMouseParams.MTUlength0 = 12.35;
       
        elseif strfind(fileName, '434_exp')
        
            hillMouseParams.Fm0 = 0.1595;      
            hillMouseParams.MTUlength0 = 12.37;
       
        elseif strfind(fileName, 'ttn706')
        
            hillMouseParams.Fm0 = 0.065373;      
            hillMouseParams.MTUlength0 = 8.4478;
      
        elseif strfind(fileName, 'ttn575')
       
            hillMouseParams.Fm0 = 0.190794;      
            hillMouseParams.MTUlength0 = 14.22622331;
       
        elseif strfind(fileName, 'ttn676')
        
            hillMouseParams.Fm0 = 0.09403;     
            hillMouseParams.MTUlength0 = 10.42814958;
      
        elseif strfind(fileName, 'ttn683')
        
            hillMouseParams.Fm0 = 0.126277;       
            hillMouseParams.MTUlength0 = 11.30046; 

        end
        
        
        
   %% Define parameters as outlined by Chand T. John instructions.
     %Fm0 is already defined from experimental data.
    hillMouseParams.Lm0 = 0.90*hillMouseParams.MTUlength0/1000; %Length muscle nought
    hillMouseParams.Lts = 0.1*hillMouseParams.MTUlength0/1000; %Length tendon slack
    hillMouseParams.alpha0 = 0; %pennation angle
    hillMouseParams.MTUlength0 = hillMouseParams.MTUlength0/1000;
    
  %% Define constants that exist across all muscles
  
    hillMouseParams.Em0 = 0.6; %passive muscle strain due to Fm0
    hillMouseParams.KtToe = 3; %exponential shape factor
    hillMouseParams.Et0 = 0.033; %tendon strain due to Fm0
    hillMouseParams.Klin = 1.712/hillMouseParams.Et0; %linear shape factor
    hillMouseParams.EtToe = 0.609*hillMouseParams.Et0; %tendon strain above lin force/strain relationship.
    hillMouseParams.FBarTToe = .333333; %normalized tendon force above linear force/strain relationship.
    hillMouseParams.Kpe = 4; %exponential shape factor for passive fl relationship
    hillMouseParams.gamma = 0.5; %shape factor for Gaussian active fl relationship
    hillMouseParams.af = 0.3; %shape factor for fv relationship
    hillMouseParams.FBarMLen = 1.8; %max normalized muscle force
    
    
    
    

end