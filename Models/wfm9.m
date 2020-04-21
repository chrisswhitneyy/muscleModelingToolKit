%% WFM_v9 Integral Method
% Jeremy Petak & Christopher D. Whitney

%% Function talks in a data set and a set of parameters. Parameters can either be a array or
%% structure. Data includes an activation signal and muscle length. Model outputs an simulation 
%% structure which includes predicted force Fm and other properties of the model over time.

function [simulated] = wfm9(data,params)

Length = data.length;
Size = length(data.length);
Act = data.act * params.act_factor;
delta_t = data.time(2) - data.time(1);

if (isstruct(params))
    kss = params.kss;
    kts = params.kts;
    M = params.M;
    Cce_L = params.Cce_L;
    Cce_S = params.Cce_S;
    Cts = params.Cts;
    Po = params.Po;
    Lo = params.Lo;
    R = Lo/2;
    J = 0.5*params.M*R^2;
    T_act = params.T_act;
elseif (isvector(params))
    kss = params(1);
    kts = params(2);
    Cce_L = params(3);
    Cce_S = params(4);
    Cts = params(5);
    M = params(6);
    Po = params(7);
    Lo = params(8);
    T_act = params(9);
    R = Lo/2;
    J = 0.5*M*R^2;
else
    error('Params must be defined in either a vector or structure');
end

%% Matrix length presizing
Xm = zeros(Size,1);
Xp = zeros(Size,1);
Xdotp = zeros(Size,1);
Xdotm = zeros(Size,1);
Xts = zeros(Size,1);
Xdotts = zeros(Size,1);
Xddotp = zeros(Size,1);
Xce = zeros(Size,1);
Xdotce = zeros(Size,1);
Xss = zeros(Size,1);
Thetap = zeros(Size,1);
Thetadotp = zeros(Size,1);
Thetaddotp = zeros(Size,1);
Fce = zeros(Size,1);
Fm = zeros(Size,1);
Clutch = ones(Size,1);
Fm = zeros(Size,1);
Fts = zeros(Size,1);
Ftd = zeros(Size,1);
Fcd = zeros(Size,1);
Fv = zeros(Size,1);
Active_FL = zeros(Size,1);
Passive_Fl = zeros(Size,1);

%Lengths
Xp(1) = 0;
Xts(1) =  0;
Xce(1) = 0;
Xm(1:T_act) = data.length(1:T_act);
Thetap(1) = 0;

%Velocities
Xdotm(1) = 0;
Xdotp(1) = 0;
Xdotts(1) = 0;
Xdotce(1) = 0;
Xddotp(1) = 0;
Thetadotp(1) = 0;

%Forces
Fce(1) = 0;
Fm(1) = 0;

%% Force Calculation Loop
for i= T_act:Size

  %%X_m (muscle length) and Xdot_m (muscle velocity)
  Xm(i) = Length(i);
  Xdotm(i) = (Length(i)-Length(i-1))/delta_t; %changed to i and i-1 4/28/15
  %fl(i) = (-878.25 * ( (Length(i)/Lo)  * 1.253)^2 + 2200.4 * ((Length(i)/Lo)*1.254) - 1192) / 186.24;

  % Force of the contractile element
  Fce(i) = Po*Act(i-(T_act-1));

  if Xdotce(i-1) > 0
      Cce = Cce_S;
  else
      Cce = Cce_L;
  end

  % Pulleys linear accleration, velocity and position
  Xddotp(i) = (kss*(Xm(i-1) - Xp(i-1)) - (Fce(i-1)+ Cce*Xdotce(i-1) + kts*Xts(i-1) + Cts*Xdotts(i-1)))/M;
  Xdotp(i) = Xddotp(i)*delta_t + Xdotp(i-1);
  Xp(i) =  (Xddotp(i)/2)*delta_t^2 + Xdotp(i-1)*delta_t + Xp(i-1);

  % Pulleys rotation accleration, velocity and position
  Thetaddotp(i) = ( (R*Fce(i-1) + R*Cce*Xdotce(i-1)) - (R*kts*Xts(i-1) + R*Cts*Xdotts(i-1)) )/J;
  Thetadotp(i) = Thetaddotp(i)*delta_t + Thetadotp(i-1);
  Thetap(i) = (Thetaddotp(i)/2)*delta_t^2 + Thetadotp(i-1)*delta_t + Thetap(i-1);

  % Titin position and velcotiy
  Xts(i) = Xp(i) + R*Thetap(i);
  Xdotts(i) = Xdotp(i) + R*Thetadotp(i);

  % Concraticle element position and velcotiy
  Xce(i) = Xp(i) - R*Thetap(i);
  Xdotce(i) = Xdotp(i) - R*Thetadotp(i);

  Xss(i) = Xm(i)-Xp(i);

  % Stops the pulley position from going negative
  if Xm(i)-Xp(i) < 0
      Xp(i) = Xm(i);
  end

  %Property of series springs, series spring forces are eqaul to the
  %forces of the contractile element and titin spring
  Fm(i) = kss*Xss(i); % Without passive
  Fts(i) = kts*Xts(i);
  Ftd(i) = Cts*Xdotts(i);
  Fcd(i) = Cce*Xdotce(i);

end %End of for loop

% Adjust forces with penation_angle
Fm = Fm ./ cos(params.penation_angle);

%% Assign output vectors to simulated struc
% Displacement
simulated.positions.Xm = Xm;
simulated.positions.Xp = Xp;
simulated.positions.Xts = Xts;
simulated.positions.Thetap = Thetap;
simulated.positions.Xce = Xce;
simulated.positions.Xss = Xss;
% Velcocitys
simulated.velocitys.Xdotm = Xdotm;
simulated.velocitys.Xdotce = Xdotce;
simulated.velocitys.Xdotts = Xdotts;
simulated.velocitys.Xdotp = Xdotp;
simulated.velocitys.Thetadotp = Thetadotp;
% Accelerations
simulated.accelerations.Xddotp = Xddotp;
simulated.accelerations.Thetaddotp = Thetaddotp;
% Forces
simulated.forces.Fm = Fm;
simulated.forces.Fts = Fts;
simulated.forces.Ftd = Ftd;
simulated.forces.Fce = Fce;
simulated.forces.Fcd = Fcd;
% Relations
%simulated.relations.Fv = Fv;
%simulated.relations.Active_Fl = Active_Fl;
%simulated.relations.Passive_Fl = Passive_Fl;

end
