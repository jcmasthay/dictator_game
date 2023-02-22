trial_set = dg.task.TrialSet();

trials = dg_gen_pav_trial_set();
for i = 1:numel(trials)
  trials(i).FixationStimulusColor = 'fixation';
end
trial_set.Trials = trials;

conf = dg.config.create;

% conf.windows.main.index = 0;
% conf.windows.main.rect = [0, 0, 800, 800];

conf.windows.main.index = 2;
conf.windows.main.rect = [];

conf.time_in.cue_on = 2;
conf.time_in.cue_off = 2;
conf.time_in.fixation = 5;

<<<<<<< HEAD
target_dur = 0.1;
=======
target_dur = 0.25;
>>>>>>> 41bd5d797e8011731f4c71e98119ed6b4647d7d0
conf.targets.matching_stimuli{3}.duration = target_dur;
conf.targets.matching_stimuli{4}.duration = target_dur;

stim_fs = fieldnames( conf.stimuli );
for i = 1:numel(stim_fs)
  % Set x, y size of stimuli here (in pixels).
  conf.stimuli.(stim_fs{i}).scale = [200, 200];
end

<<<<<<< HEAD
conf.serial.disabled = false;

%conf.sources.m1_gaze.type = 'mouse';
conf.sources.m1_gaze.type = 'digital_eyelink';
=======
image_p = fullfile( dg.util.project_root, 'stimuli/images' );

conf.serial.disabled = true;
conf.images.fixation = imread( fullfile(image_p, 'flamingos.jpg') );
>>>>>>> 41bd5d797e8011731f4c71e98119ed6b4647d7d0

data = dg.task.run( conf, trial_set );

if ( 1 )
  save_filename = sprintf( '%s.mat', strrep(datestr(now), ':', '_') );
  save( fullfile(dg.util.data_root, save_filename), 'data', 'trial_set', 'conf' );
end