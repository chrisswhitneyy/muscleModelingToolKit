function [ filenames ] = get_mat_dir( dirpath )
% get_mat_dir: returns a list of all the mat file names in a passed dir
filenames = {};
FILES = dir (dirpath);
filelist = {FILES.name}.';

for i = 1:numel(filelist)
  filename = filelist{i};
  disp(filename);
  filename_spl = strsplit( filename , ".");
  
  % skip special files . and ..
  if ( strcmp (filename,'.')  || strcmp (filename,'..'))
    continue;
  % assigns that have the .mat extension
  elseif ( strcmp(filename_spl(2), "mat") )
    filenames{end+1} = filelist{i};
  end
  
end

end  % get_mat_dir
