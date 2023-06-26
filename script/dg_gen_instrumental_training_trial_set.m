function trials = dg_gen_instrumental_training_trial_set(n, is_choice)

if ( nargin < 2 )
  is_choice = false;
end

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

eccen1 = repmat( {'top-right', 'top-left'}, 1, numel(trials) / 2 );
eccen2 = repmat( {'bottom-right', 'bottom-left'}, 1, numel(trials) / 2 );

trials = [ trials, trials ];
eccens = [ eccen1, eccen2 ];
eccens = eccens(randperm(numel(eccens)));
[trials.ChoiceTargetEccentricities] = deal( eccens{:} );

if ( is_choice )  
  top_eccen = @(x) ternary(strcmp(x, 'top-left'), 'bottom-right', 'bottom-left');
  bot_eccen = @(x) ternary(strcmp(x, 'bottom-left'), 'top-right', 'top-left');
  other_eccen = @(x) ternary(contains(x, 'top'), top_eccen(x), bot_eccen(x));
  
  all_channels = [ {1}, rem_channels ];
	all_outs = [ {'self'}, rem_outcomes ];
  
  for i = 1:numel(trials)
    trial = trials(i);
    out = trial.Outcomes;
    
    curr_out = ternary( ismember(out, {'self', 'both'}) ...
      , setdiff({'self', 'both'}, out), setdiff({'other', 'bottle'}, out));
    curr_eccen = other_eccen( trial.ChoiceTargetEccentricities );    
    chan_ind = strcmp( all_outs, curr_out );
    
    trial.Outcomes = [ trial.Outcomes, curr_out ];
    trial.ChoiceTargetEccentricities = [ ...
      trial.ChoiceTargetEccentricities, curr_eccen ];
    trial.RewardChannels = [ trial.RewardChannels, all_channels(chan_ind) ];
    trials(i) = trial;
  end
end

end