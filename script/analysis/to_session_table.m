function tbl = to_session_table(file_name)

tbl = table( cellstr(file_name), 'VariableNames', {'session_file_name'} );

end