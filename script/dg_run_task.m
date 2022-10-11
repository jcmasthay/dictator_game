trial_set = dg.task.TrialSet();

trial0 = dg.task.TrialDescriptor();
trial0.TrialType = 'cued';
trial0.Outcomes = { 'self' };

trial1 = dg.task.TrialDescriptor();
trial1.TrialType = 'choice';
trial1.DelayToDecision = 3;
trial_set.Trials = [trial1, trial1, trial0];

data = dg.task.run( dg.config.create, trial_set );
% data = dg.task.run( dg.config.create, trial_set );