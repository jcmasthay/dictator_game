trial_set = dg.task.TrialSet();
% 
% trial0 = dg.task.TrialDescriptor();
% trial0.TrialType = 'train-choice';
% trial0.Outcomes = { 'self', 'bottle' };
% trial0.DelayToDecision = 0.6;
% trial0.DelayToReward = 0.8;
% trial0.RewardChannels = [1, 2];

trial0 = dg.task.TrialDescriptor();
trial0.TrialType = 'train-cued';
trial0.Outcomes = { 'self' };
trial0.DelayToDecision = 0.0;
trial0.DelayToReward = 2;
trial0.RewardChannels = 2;
trial0.ChoiceTargetEccentricities = { 'center' };

trial1 = dg.task.TrialDescriptor();
trial1.TrialType = 'train-choice';
trial1.Outcomes = { 'self' };
trial1.DelayToDecision = 0.0;
trial1.DelayToReward = 2;
trial1.RewardChannels = 2;
trial1.ChoiceTargetEccentricities = { 'top-right' };

trial_set.Trials = [trial0, trial1];

conf = dg.config.create;

conf.windows.main.index = 0;
conf.windows.main.rect = [0, 0, 800, 800];

conf.serial.disabled = false;
data = dg.task.run( conf, trial_set );

%%

%{

define number of trials in a block
decide stimuli for cues and choice targets, in all trial types

%}