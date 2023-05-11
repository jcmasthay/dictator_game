function state = end_trial(program, ~)

state = ptb.State();
state.Name = 'end_trial';
state.Duration = 0;
state.Entry = @(state) entry(state, program);

end

function entry(state, program)

structfun( @flip, program.Value.windows );

if ( ~finished(program.Value.trial_set) )
  next( state, program.Value.states('new_trial') );
end

program.Value.data(end+1) = program.Value.trial_data;

display_performance( program.Value.data );

end

function display_performance(data)

did_init = false( numel(data), 1 );
did_acquire_outcome_cue = false( numel(data), 1 );
did_make_choice = false( numel(data), 1 );
is_sacc_trial = false( numel(data), 1 );

for i = 1:numel(data)
  did_init(i) = ~isempty( data(i).Fixation ) && data(i).Fixation.FixationState.Acquired;
  did_acquire_outcome_cue(i) = ~isempty( data(i).CueOn ) && ~isempty( data(i).CueOn.FixationState0 ) && data(i).CueOn.FixationState0.Acquired;
  is_sacc_trial(i) = strcmp( data(i).TrialDescriptor.TrialType, 'train-choice' );
  
  if ( ~isempty(data(i).TrainingDecision) )
    td = data(i).TrainingDecision;
    chose_left = td.FixationState0.Acquired;
    chose_right = td.FixationState1.Acquired;
    did_make_choice(i) = chose_left || chose_right;
  end
end

was_correct = (is_sacc_trial & did_make_choice) | (~is_sacc_trial & did_acquire_outcome_cue);

clc;
fprintf( '\n Num trials: %d; Num init: %d; Num correct: %d', numel(did_init), sum(did_init), sum(was_correct) );

end