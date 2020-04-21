function [ result ]  = is_constraint ( varargin )
% function: The purpose of this function is to take in a stim struct and
% determine wither or not the stim is valid based on the passed constraints.
% The constraints struc specifices which model elements to test for, this model
% function must be in the search path. The function returns a result struc which
% contains the the pass or fail flag and other information if the model did not
% pass.
%
% Arguments:
% constraints.<property>.<component name>.<bound>
% Example:
% (i.e. constraints.forces.Fm.lb = 0 )
% (     constraints.forces.Fm.ub = 1,000 )
% (     constraints.poistion.Thetap.lb = 0 )
% (     constraints.poistion.Thetap.ub = 200 )
%
% Author: Christopher D. Whitney at Northern Arizona University
%
  if nargin < 2
    error('Not enough arugments.');
  endif

  stim = varargin{1};
  constraints = varargin{2};

  % Get all the fields of the constraint struc (e.g the properties)
  properties  = fieldnames(constraints);
  flag = true; % intilized flag
  result.elements = {};

  for i = 1:numel(properties) % loop through the properties
    % Get all the fields of the properties constraint struc (e.g the components)
    components = fieldnames( constraints.(properties{i}) );

    for j = 1:numel(components) % loop through the components
      % Get all the fields of the components constraint struc (e.g the bounds)
      bounds = fieldnames( constraints.(properties{i}).(components{j}) );

      for k = 1:numel(bounds) % loop through the bounds

        % Get bound (i.e lb or ub) and value
        bound = bounds{k};
        value = constraints.(properties{i}).(components{j}).(bound);
        observed = stim.(properties{i}).(components{j});

        if strcmp( bound , 'lb') % Check which type of bound
          % Check if any of the elements in the matrix are less than the lower bound
          b = any( observed < value  );

        elseif strcmp( bound, 'ub')
          % Check if any of the elements in the matrix are greater that the upper bound
          b = any( observed > value );

        else
          error(['Error: Bound can not be ' bound '. Must be a lb or ub']);
        end %if for check which typ of bound

        % Check the return value b for the call to any
        if b == 1 % Stim fails the constraints
          flag = false;
          if strcmp(bound, 'lb')
            result.elements{end + 1} = {[ properties{i} '.' components{j} '.' bound ],[num2str(value)],[num2str(min(observed))]};
          elseif strcmp(bound, 'ub')
            result.elements{end + 1} = {[ properties{i} '.' components{j} '.' bound ], [num2str(value)],[num2str(max(observed))]};
          endif

        elseif b == 0 % Stim passes the constraints
          continue;
        else
          % Something went wrong with assigning b, error out
          error ('Error: Sometime went wrong check matrix.');
        end % end if for check the any function return value

      end % end of loop for bounds
    end % end of loop for components
  end % end of loop for properties

  result.flag = flag;

  if nargin == 3 && strcmp(varargin{3}, 'display')
    if result.flag == false
      disp('[is_constraint] Following constraints where not meet:');
      str = list_in_columns({'component','bound value', 'observed'});
      printf(str);
      for i = 1:numel(result.elements)
        str = list_in_columns(result.elements{i});
        printf(str);
      endfor

    elseif result.flag == true
      disp('[is_constraint] Stim passes constraint test.');
    endif
  endif

end  % end of function

%!test
%!
%! stim1.displacement.Xp = [1; 0.004; 0.003; 0.004;];
%! cons1.displacement.Xp.ub = 0.005;
%! cons1.displacement.Xp.lb = 0;
%!
%! stim2.displacement.Xp = [0.004; 0.004; 0.003; 0.004;];
%! cons2.displacement.Xp.ub = 0.005;
%! cons2.displacement.Xp.lb = 0;
%! stim2.displacement.ThetaP = [1000; 0.004; 0.003; 0.004;];
%! cons2.displacement.ThetaP.ub = 300;
%! cons2.displacement.ThetaP.lb = 0;
%!
%! stim3.displacement.Xp = [0.004; 0.004; 0.003; 0.004;];
%! cons3.displacement.Xp.ub = 0.005;
%! cons3.displacement.Xp.lb = 0;
%! stim3.displacement.ThetaP = [290; 0.004; 0.003; 0.004;];
%! cons3.displacement.ThetaP.ub = 300;
%! cons3.displacement.ThetaP.lb = 0;
%!
%! stims = [stim1 stim2 stim3];
%! consts = [cons1 cons2 cons3];
%! expected = [false;false;true];
%! for i = 1:3
%!    result = is_constraint(stims(i), consts(i));
%!    assert(result.flag, expected(i,:));
%! endfor

%!test
%!
%! stim1.displacement.Xp = [0.005; 0.004; 0.003; 0.004;];
%! cons1.displacement.Xp.ub = 0.005;
%! cons1.displacement.Xp.lb = 0;
%!
%! stim2.displacement.Xp = [0.004; 0.004; 0.003; 0.004;];
%! cons2.displacement.Xp.ub = 0.005;
%! cons2.displacement.Xp.lb = 0;
%! stim2.displacement.ThetaP = [300; 0.004; 0.003; 0.004;];
%! cons2.displacement.ThetaP.ub = 300;
%! cons2.displacement.ThetaP.lb = 0;
%!
%! stim3.displacement.Xp = [0.004; 0.004; 0.003; 0.004;];
%! cons3.displacement.Xp.ub = 0.005;
%! cons3.displacement.Xp.lb = 0;
%! stim3.displacement.ThetaP = [290; 0.004; 0.003; 0.004;];
%! cons3.displacement.ThetaP.ub = 300;
%! cons3.displacement.ThetaP.lb = 0;
%!
%! stims = [stim1 stim2 stim3];
%! consts = [cons1 cons2 cons3];
%! expected = [true;true;true];
%! for i = 1:3
%!    result = is_constraint(stims(i), consts(i));
%!    assert(result.flag, expected(i,:));
%! endfor
