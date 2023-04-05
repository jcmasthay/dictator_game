function trials = dg_gen_instrumental_training_trial_set(n)

trials = dg.task.TrialDescriptor();
trials.TrialType = 'train-choice';
trials.Outcomes = { 'self' };
trials.DelayToDecision = 0.0;
trials.DelayToReward = 2;
trials.RewardChannels = { 1 };
trials.ChoiceTargetEccentricities = { 'top-right' };

rem_outcomes = { 'both', 'other', 'bottle' };
rem_channels = {1:2, 2, 3};

first_trial = trials;
for i = 1:numel(rem_outcomes)
  first_trial.Outcomes = rem_outcomes(i);
  first_trial.RewardChannels = rem_channels(i);
  trials(end+1) = first_trial;
end

v = shared_utils.general.get_blocked_condition_indices( n, 4, 4 );
trials = trials(v);

eccen = repmat( {'top-right', 'top-left'}, 1, numel(trials) / 2 );
[trials.ChoiceTargetEccentricities] = deal( eccen{:} );

end