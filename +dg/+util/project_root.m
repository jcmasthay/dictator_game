function p = project_root()

p = fileparts( fileparts(fileparts(which('dg.util.project_root'))) );

end