conf = dg.config.create;

conf.time_in.cue_on = 2;
conf.time_in.cue_off = 0.5;
conf.time_in.fixation = 5;
conf.time_in.iti = 3;
conf.time_in.target_error = 2;
delay_to_reward = 0;

% outcome_cue_target_dur = 0.1;
outcome_cue_target_dur = 0.25;
fix_square_target_dur = 0.2;

trial_set = dg.task.TrialSet();

num_blocks = 256;
trials = dg_gen_pav_trial_set( num_blocks );
for i = 1:numel(trials)
  trials(i).FixationStimulusColor = 'fixation';
  trials(i).DelayToReward = delay_to_reward;
end

%use_blocked_order = true;
use_blocked_order = false;

if ( use_blocked_order )
  order = { 'self', 'both', 'other', 'bottle' };  
  outs = { trials.Outcomes };
  outs = cellfun( @(x) x(1), outs );
  ord = zeros( size(outs) );
  off = 0;
  for i = 1:numel(order)
    match_ind = find( strcmp(outs, order{i}) );
    ord((1:numel(match_ind))+off) = match_ind;
    off = off + numel( match_ind );
  end
  trials = trials(ord);
end

trial_set.Trials = trials;

% conf.windows.main.index = 0;
% conf.windows.main.rect = [0, 0, 800, 800];

conf.windows.main.index = 2;
conf.windows.main.rect = [];
% conf.windows.main.rect = [0, 0, 800, 800];

conf.targets.matching_stimuli{1}.duration = fix_square_target_dur;
conf.targets.matching_stimuli{3}.duration = outcome_cue_target_dur;
conf.targets.matching_stimuli{4}.duration = outcome_cue_target_dur;

stim_fs = fieldnames( conf.stimuli );
for i = 1:numel(stim_fs)
  % Set x, y size of stimuli here (in pixels).
  if ( ~strcmp(stim_fs{i}, 'target_error') )
    conf.stimuli.(stim_fs{i}).scale = [200, 200];
  end
end

conf.serial.disabled = false;

conf.sources.m1_gaze.type = 'mouse';
% conf.sources.m1_gaze.type = 'digital_eyelink';
image_p = fullfile( dg.util.project_root, 'stimuli/images' );

conf.images.fixation = imread( fullfile(image_p, 'F43.jpg') );

data = dg.task.run( conf, trial_set );

if ( 1 )
  save_filename = sprintf( '%s.mat', strrep(datestr(now), ':', '_') );
  save( fullfile(dg.util.data_root, save_filename), 'data', 'trial_set', 'conf' );
end