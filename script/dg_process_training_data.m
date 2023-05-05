%%  load data

file_paths = shared_utils.io.findmat( fullfile(dg.util.project_root, 'data') );

% Select a specific day or string.
wanted_subset = contains( file_paths, '28-Apr' );

% Alternatively, use all the data
% wanted_subset(:) = true;
file_paths = file_paths(wanted_subset);

file_names = shared_utils.io.filenames( file_paths );

files = cellfun( @load, file_paths, 'un', 0 );
datas = cellfun( @(x) x.data, files, 'un', 0 );

%%  convert to table

data_tbls = generate_cued_data_tables( datas, file_names );

%%  Mean # initiated trials

figure(1); clf;
[I, id, C] = rowsets( 3, data_tbls, {}, {}, 'trial_type' );
did_init = double( data_tbls.acquired_initial_fixation );
axs = plots.simplest_barsets( did_init, I, id, plots.cellstr_join(C) ...
  , 'error_func', @std, 'summary_func', @sum );
ylabel( axs(1), '# Initiated trials' );
% ylim( axs(1), [0, 1] );

%%  Mean % initiated trials

figure(1); clf;
[I, id, C] = rowsets( 3, data_tbls, {}, {}, 'trial_type' );
did_init = double( data_tbls.acquired_initial_fixation );
axs = plots.simplest_barsets( did_init, I, id, plots.cellstr_join(C) ...
  , 'error_func', @(x) nan );
ylabel( axs(1), '% Initiated trials' );
ylim( axs(1), [0, 1] );

%%  Mean % errors on outcome cue

figure(2); clf;
[I, id, C] = rowsets( 3, data_tbls, {}, 'outcome', 'trial_type' );
had_error = double( ~data_tbls.acquired_outcome_cue );
axs = plots.simplest_barsets( had_error, I, id, plots.cellstr_join(C) ...
  , 'error_func', @(x) nan );
ylabel( axs(1), '% Errors by outcome' );
ylim( axs(1), [0, 1] );

%%  trial timecourse

use_corr = true;
use_perc = false;
trial_bin_size = 10;

[I, C] = findeach( data_tbls, 'session_file_name' );
bi = bin_trials( I, trial_bin_size );
was_correct = double( data_tbls.acquired_outcome_cue );
did_init = double( double(data_tbls.acquired_initial_fixation) );

metric_symbol = ternary( use_perc, '%', '#' );
if ( use_corr )
  metric = was_correct;
  metric_name = sprintf( '%s correct', metric_symbol );
else
  metric = did_init;
  metric_name = sprintf( '%s initiated', metric_symbol );
end

bin_means = cell( size(bi) );
max_n = 0;
for i = 1:numel(bi)
  if ( use_perc )
    s_func = @(x) 100 * pnz(x);
  else
    s_func = @sum;
  end
  
  bin_means{i} = cellfun( @(x) s_func(metric(I{i}(x))), bi{i} );
  max_n = max( max_n, numel(bin_means{i}) );
end

bin_traces = nan( numel(bi), max_n );
for i = 1:numel(bi)
  bin_traces(i, 1:numel(bin_means{i})) = bin_means{i};
end

leg_labels = arrayfun( @(x) strrep(plots.cellstr_join({C(x, :)}), '_', ' '), 1:size(C, 1) );

figure(1); clf;
h = plot( bin_traces' );
legend( h, leg_labels );
xlabel( 'Trial bin' );
ylabel( metric_name );
