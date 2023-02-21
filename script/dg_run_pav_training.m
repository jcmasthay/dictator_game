trial_set = dg.task.TrialSet();

trials = dg_gen_pav_trial_set();
for i = 1:numel(trials)
  trials(i).FixationStimulusColor = 'fixation';
end
trial_set.Trials = trials;

conf = dg.config.create;

% conf.windows.main.index = 0;
% conf.windows.main.rect = [0, 0, 800, 800];

conf.windows.main.index = 0;
conf.windows.main.rect = [];

conf.time_in.cue_on = 2;
conf.time_in.cue_off = 2;
conf.time_in.fixation = 5;

target_dur = 0.25;
conf.targets.matching_stimuli{3}.duration = target_dur;
conf.targets.matching_stimuli{4}.duration = target_dur;

stim_fs = fieldnames( conf.stimuli );
for i = 1:numel(stim_fs)
  % Set x, y size of stimuli here (in pixels).
  conf.stimuli.(stim_fs{i}).scale = [200, 200];
end

image_p = fullfile( dg.util.project_root, 'stimuli/images' );

conf.serial.disabled = true;
conf.images.fixation = imread( fullfile(image_p, 'flamingos.jpg') );

data = dg.task.run( conf, trial_set );

if ( 1 )
  save_filename = sprintf( '%s.mat', strrep(datestr(now), ':', '_') );
  save( fullfile(dg.util.data_root, save_filename), 'data', 'trial_set', 'conf' );
end