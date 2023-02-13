function dr = data_root()

dr = fullfile( fileparts(fileparts(fileparts(which('dg.util.data_root')))), 'data' );

end