function tbl = to_train_cued_data_table(data)

acquired_init_fix = data.Fixation.FixationState.Acquired & ...
  ~data.Fixation.FixationState.Broke;

acquired_outcome_cue = ~isempty(data.CueOn) && data.CueOn.FixationState0.Acquired;
acquired_cue_off_fix = ~isempty(data.CueOff) && data.CueOff.FixationState.Acquired;

tbl = table( acquired_init_fix, acquired_outcome_cue, acquired_cue_off_fix ...
  , 'VariableNames', {'acquired_initial_fixation', 'acquired_outcome_cue', 'acquired_cue_off'} );

end