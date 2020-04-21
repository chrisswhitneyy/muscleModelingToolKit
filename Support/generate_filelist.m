function [ flag ] = generate_filelist( fpath, fwname )
% function: writes the name of the file contained in fpath to a text file named fwname

FILES = dir (fpath);
filelist = {FILES.name}.';

fid = fopen (fwname,"w");

for i = 1:numel(filelist)
  if ( strcmp(filelist{i},'.') || strcmp(filelist{i},'..') || strcmp(filelist{i},fwname) || strcmp(filelist{i},' ')  )
      continue;
  end
  
  filename = strsplit(filelist{i},'.');
  
  fprintf (fid, '%s\n',filename{1} );
  
end

fclose (fid);

end  % function
