function suc_flag = generate_wraper (model_name,wraper_name,data_filepath,lock_params,free_params,obj_fn,savepath)
%
% Autogenerates a wraper function for a passed model function, data, locked parameters,
% free parameters, and an objective function, saving the .m file in the workdir
%
% Inputs:
% - model_name (String) : name of the model function
% - wrapper_name (String) : the name of the .m file that is created
% - data_filepath (String) : the path to the data being modeled
% - locked_params (Structs) : contains the fixed parameters to the model
% - free_params (Structs) : contains the fixed parameters to the model
% - obj_fn (String) : name of the objective function that the wraper outputs.
%
% NOTE: The structs must be in the same format accepted by the model
%
%
% Author: Christopher D. Whitney at Northern Arizona University, June 3rd, 2017

    % If a wraper witht the same name already exist delete it
    if exist([wraper_name '.m'],'file')
      delete([wraper_name '.m']);
    end

    % Empty string for the body of the function
    %body = ['data = load( " ' data_filepath  ' "  );'];
    body = strcat('load("', data_filepath,  '");');
    % Gets all the files in the free and locked params
    if ~isempty(lock_params)
      locked_fields = fieldnames(lock_params);

      % Loops through each locked parameter and assigns that to its value in a
      % string that will be appended to the body.
      for i=1:numel(locked_fields)
        line = strcat('params.', locked_fields{i},  '=' , num2str(lock_params.(locked_fields{i})), ';');
        % Append to the body
        body = strcat(body,line);
      end
    end

    if ~isempty(free_params)
      free_fields = fieldnames(free_params);

      % Loops through each free field and creates a line where that field is
      % assigned to the InitVar which the finished function will be passed.
      for i=1:numel(free_fields)
        line = ['params.' free_fields{i} '= InitVar (' num2str(i) ');'];
        % Appends the new line to the body of the function
        body = strcat(body,line);
      end
    end

    % Line to call model
    line = ['stim = ' model_name '( data, params);'];
    body = strcat(body,line);

    % Specific to WFM
    line = ['error_value =  ' obj_fn '(transpose(stim.forces.Fm(1000:length(stim.forces.Fm))),transpose(data.force(1000:length(data.force))));'];
    body = strcat(body,line);
    
    line = strcat('disp(["', obj_fn,  ' "  num2str(error_value)]);');
    body = strcat(body,line);
    
    % Final function string
    func_string = ['function [error_value] = ' wraper_name ' ( InitVar ); ' body ' end'];
    
    filename = strcat(savepath,wraper_name, '.m');
    disp (filename);
    fid = fopen(filename,'wt');
    fprintf(fid, func_string);
    fclose(fid);
    
end %generate_wraper
