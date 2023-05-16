function tbl = to_data_table(data)

acquired_init_fix = data.Fixation.FixationState.Acquired & ...
  ~data.Fixation.FixationState.Broke;

acquired_outcome_cue = ~isempty(data.CueOn) && data.CueOn.FixationState0.Acquired;
acquired_cue_off_fix = ~isempty(data.CueOff) && data.CueOff.FixationState.Acquired;

is_choice = strcmp( data.TrialDescriptor.TrialType, 'train-choice' );
choice_index = nan;
rt = nan;
if ( is_choice )
  td = data.TrainingDecision;
  if ( ~isempty(td) )
    if ( td.FixationState0.Acquired )
      choice_index = 1;
      rt = td.FixationState0.EntryTimes(end) - td.EntryTime;
    elseif ( td.FixationState1.Acquired )
      choice_index = 2;
      rt = td.FixationState1.EntryTimes(end) - td.EntryTime;
    end
  end
  successful_trial = ~isnan( choice_index );
else
  successful_trial = acquired_outcome_cue;
end

tbl = table( acquired_init_fix, acquired_outcome_cue, acquired_cue_off_fix ...
  , choice_index, successful_trial, rt ...
  , 'VariableNames', {'acquired_initial_fixation', 'acquired_outcome_cue', 'acquired_cue_off', 'choice_index', 'succesful_trial', 'rt'} );

end