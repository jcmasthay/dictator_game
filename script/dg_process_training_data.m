%%  load data

file_paths = shared_utils.io.findmat( fullfile(dg.util.project_root, 'data') );

% Select a specific day or string.
wanted_subset = contains( file_paths, '04-Apr' );

% Alternatively, use all the data
% wanted_subset(:) = true;
file_paths = file_paths(wanted_subset);

file_names = shared_utils.io.filenames( file_paths );

files = cellfun( @load, file_paths, 'un', 0 );
datas = cellfun( @(x) x.data, files, 'un', 0 );

%%  convert to table

data_tbls = generate_cued_data_tables( datas, file_names );

%%  Mean % initiated trials

figure(1);
[I, id, C] = rowsets( 3, data_tbls, {}, {}, 'trial_type' );
did_init = double( data_tbls.acquired_initial_fixation );
axs = plots.simplest_barsets( did_init, I, id, plots.cellstr_join(C) ...
  , 'error_func', @(x) nan );
ylabel( axs(1), '% Initiated trials' );
ylim( axs(1), [0, 1] );

%%  Mean % errors on outcome cue

figure(2);
[I, id, C] = rowsets( 3, data_tbls, {}, 'outcome', 'trial_type' );
had_error = double( ~data_tbls.acquired_outcome_cue );
axs = plots.simplest_barsets( had_error, I, id, plots.cellstr_join(C) ...
  , 'error_func', @(x) nan );
ylabel( axs(1), '% Errors by outcome' );
ylim( axs(1), [0, 1] );

%%

function data_tbls = generate_cued_data_tables(datas, file_names)

assert( numel(datas) == numel(file_names) );

tbls = cell( numel(datas), 1 );
for i = 1:numel(datas)
  tbls{i} = arrayfun( @(x) [...
    to_trial_desc_table(x.TrialDescriptor) ...
    , to_train_cued_data_table(x) ...
    , to_session_table(file_names{i})], datas{i}, 'un', 0 );
  tbls{i} = vertcat( tbls{i}{:} );
end

data_tbls = vertcat( tbls{:} );

end

function tbl = to_session_table(file_name)

tbl = table( cellstr(file_name), 'VariableNames', {'session_file_name'} );

end

function tbl = to_train_cued_data_table(data)

acquired_init_fix = data.Fixation.FixationState.Acquired & ...
  ~data.Fixation.FixationState.Broke;

acquired_outcome_cue = ~isempty(data.CueOn) && data.CueOn.FixationState0.Acquired;
acquired_cue_off_fix = ~isempty(data.CueOff) && data.CueOff.FixationState.Acquired;

tbl = table( acquired_init_fix, acquired_outcome_cue, acquired_cue_off_fix ...
  , 'VariableNames', {'acquired_initial_fixation', 'acquired_outcome_cue', 'acquired_cue_off'} );

end

function tbl = to_trial_desc_table(trial_desc)

tt = cellstr( trial_desc.TrialType );
outcome = cellstr( strjoin(cellstr(trial_desc.Outcomes), ' | ') );
tbl = table( tt, outcome, 'VariableNames', {'trial_type', 'outcome'} );

end