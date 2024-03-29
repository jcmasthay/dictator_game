%{

right click on desktop -> display settings -> check for display order: 
[1, 3, 2]

%}

conf = dg.config.create;

conf.reward.key_press = 0.5;
conf.reward.main = 0.7; % seconds

conf.time_in.cue_on = 1; % amount of time coloured square displays on screen
conf.time_in.cue_off = 0.5; % amount of time second fixation (fractal) is on screen
conf.time_in.fixation = 4; % amount of time initial fixation (fractal) is on screen; initiate trial
conf.time_in.iti = 1.5; % inter-trial interval
conf.time_in.target_error = 2; % amount of time fixation error square is displayed
delay_to_reward = 0;

% outcome_cue_target_dur = 0.1;
outcome_cue_target_dur = 0.15; % time to fixate on coloured square
fix_square_target_dur = 0.2; % time to fixate on fixation (fractal) cue

% define types of trials to be run
trial_set = dg.task.TrialSet();

num_blocks = 256;
self_both_only = false;
pav_trials = dg_gen_pav_trial_set( num_blocks, self_both_only );
instrumental_trials = dg_gen_instrumental_training_trial_set( num_blocks );

include_instrumental_trials = true;
only_instrumental_trials = false;

if ( include_instrumental_trials && only_instrumental_trials )
  trials = instrumental_trials;
  
elseif ( include_instrumental_trials )
  trials = [ pav_trials(:)', instrumental_trials(:)' ];
  trials = trials(randperm(numel(trials)));
else
  trials = pav_trials;
end

for i = 1:numel(trials)
  trials(i).FixationStimulusColor = 'fixation';
  trials(i).DelayToReward = delay_to_reward;
  trials(i).PreferOutcomeStimulusImages = true;
  trials(i).OutcomeStimulusScale = 0.75;
  trials(i).ChoiceTargetEccentricityOffset = 0.25; %as number gets bigger, cue gets closer to the center of the screen (0.5 = center)
end
%OutcomeStimulusScale controls size of stimulus images

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
% conf.windows.main.index = 0;
conf.windows.main.rect = [];
% conf.windows.main.rect = [0, 0, 800, 800];

% conf.windows.main.index = 3;
% conf.windows.main.rect = [];

% Can comment these two lines out to disable debug window.
conf.windows.debug.index = 2;
conf.windows.debug.rect = [0, 0, 800, 800];

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
% conf.serial.disabled = true;

session_p = fullfile( dg.util.data_root, 'edf', datestr(now, 'mmddyyyy') );
shared_utils.io.require_dir( session_p );

% conf.sources.m1_gaze.type = 'mouse';
conf.sources.m1_gaze.type = 'digital_eyelink';
conf.sources.m1_gaze.enable_debug_mode = false;
conf.sources.m1_gaze.edf_filename = dg.util.next_edf_filename( session_p );
image_p = fullfile( dg.util.project_root, 'stimuli/images' );

conf.images.fixation = imread( fullfile(image_p, 'F43.jpg') );
% conf.images.outcome_self = imread( fullfile(image_p, 'self.png') );
% conf.images.outcome_both = imread( fullfile(image_p, 'both.png') );
% conf.images.outcome_other = imread( fullfile(image_p, 'other.png') );
% conf.images.outcome_none = imread( fullfile(image_p, 'none.png') );

conf.images.outcome_self = imread( fullfile(image_p, 'matched_pixels/circle.png') );
conf.images.outcome_both = imread( fullfile(image_p, 'matched_pixels/triangle.png') );
conf.images.outcome_other = imread( fullfile(image_p, 'matched_pixels/star.png') );
conf.images.outcome_none = imread( fullfile(image_p, 'matched_pixels/square.png') );

[data, m1_el_sync_times] = dg.task.run( conf, trial_set );

if ( 1 )
  save_filename = sprintf( '%s.mat', strrep(datestr(now), ':', '_') );
  save( fullfile(dg.util.data_root, save_filename), 'data', 'trial_set', 'conf', 'm1_el_sync_times' );
end