trial_set = dg.task.TrialSet();

trial_set.Trials = dg_gen_pav_trial_set();

conf = dg.config.create;

conf.windows.main.index = 0;
conf.windows.main.rect = [0, 0, 800, 800];

conf.time_in.cue_on = 2;
conf.time_in.cue_off = 2;
conf.time_in.fixation = 5;

target_dur = 0.5;
conf.targets.matching_stimuli{3}.duration = target_dur;
conf.targets.matching_stimuli{4}.duration = target_dur;

conf.serial.disabled = true;

data = dg.task.run( conf, trial_set );

if ( 1 )
  save_filename = sprintf( '%s.mat', strrep(datestr(now), ':', '_') );
  save( fullfile(dg.util.data_root, save_filename), 'data', 'trial_set', 'conf' );
end