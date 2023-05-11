function res = next_edf_filename(data_p)

edfs = shared_utils.io.find( data_p, '.edf' );
res = sprintf( 'f%d.edf', numel(edfs)+1 );

end