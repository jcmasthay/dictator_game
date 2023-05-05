function tbl = to_trial_desc_table(trial_desc)

tt = cellstr( trial_desc.TrialType );
outcome = cellstr( strjoin(cellstr(trial_desc.Outcomes), ' | ') );
tbl = table( tt, outcome, 'VariableNames', {'trial_type', 'outcome'} );

end