trial_set = dg.task.TrialSet();

trial0 = dg.task.TrialDescriptor();
trial0.TrialType = 'cued';
trial0.Outcomes = { 'bottle' };
trial0.DelayToDecision = 0.6;
trial0.DelayToReward = 0.8;

trial1 = dg.task.TrialDescriptor();
trial1.TrialType = 'choice';
trial1.Outcomes = { 'self', 'both' };
trial1.DelayToDecision = 0.6;
trial1.DelayToReward = 0.8;

trial2 = trial1;
trial2.Outcomes = fliplr( trial2.Outcomes );

trial3 = trial1;
trial3.Outcomes = { 'other', 'bottle' };

trial4 = trial3;
trial4.Outcomes = fliplr( trial4.Outcomes );

trial_set.Trials = [trial0, trial3, trial4, trial1, trial0, trial2];

conf = dg.config.create;
conf.serial.disabled = true;
data = dg.task.run( conf, trial_set );
% data = dg.task.run( dg.config.create, trial_set );