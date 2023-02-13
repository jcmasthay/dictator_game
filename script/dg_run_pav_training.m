trial_set = dg.task.TrialSet();

trial_set.Trials = dg_gen_pav_trial_set();

conf = dg.config.create;

conf.windows.main.index = 0;
conf.windows.main.rect = [0, 0, 800, 800];

conf.serial.disabled = true;

data = dg.task.run( conf, trial_set );