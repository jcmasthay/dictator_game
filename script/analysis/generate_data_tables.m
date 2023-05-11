function data_tbls = generate_data_tables(datas, file_names)

assert( numel(datas) == numel(file_names) );

tbls = cell( numel(datas), 1 );
for i = 1:numel(datas)
  tbls{i} = arrayfun( @(x) [...
    to_trial_desc_table(x.TrialDescriptor) ...
    , to_data_table(x) ...
    , to_session_table(file_names{i})], datas{i}, 'un', 0 );
  tbls{i} = vertcat( tbls{i}{:} );
end

data_tbls = vertcat( tbls{:} );

end