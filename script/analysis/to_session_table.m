function tbl = to_session_table(file_name)

sesh = datestr( file_name(1:11) );
tbl = table( cellstr(file_name), cellstr(sesh), 'VariableNames', {'session_file_name', 'session'} );

end