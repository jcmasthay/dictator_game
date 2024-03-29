function trials = dg_gen_pav_trial_set(n, self_both_only)

if ( nargin < 2 )
  self_both_only = false;
end

trials = dg.task.TrialDescriptor();
trials.TrialType = 'train-cued';
trials.Outcomes = { 'self' };
trials.DelayToDecision = 0.0;
trials.DelayToReward = 2;
trials.RewardChannels = { 1 };
trials.ChoiceTargetEccentricities = { 'center' };

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

if ( self_both_only )
  is_sb = arrayfun( @(x) any(ismember({'self', 'both'}, x.Outcomes)), trials );
  trials = trials(is_sb);
end

end