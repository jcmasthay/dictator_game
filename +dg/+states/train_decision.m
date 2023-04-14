function state = train_decision(program, conf)

state = ptb.State();
state.Name = 'train_decision';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

state.UserData.entry_time = elapsed( program.Value.task );
state.UserData.fixation_acquired_state0 = dg.util.FixationStateTracker();
state.UserData.fixation_acquired_state1 = dg.util.FixationStateTracker();
state.UserData.choice_index = [];

stim = program.Value.stimuli;

dg.util.set_choice_target_positions( program, program.Value.trial_descriptor );

% if ( strcmp(program.Value.trial_descriptor.TrialType, 'train-choice') )
%   stim.choice_option0.FaceColor = [127, 127, 127];
% end

end

function loop(state, program)

draw_stimuli( program );
check_targets( state, program );

end

function exit(state, program)

state.UserData.exit_time = elapsed( program.Value.task );

if ( isempty(state.UserData.choice_index) )
  next( state, program.Value.states('target_error'))
else
  if ( strcmp(program.Value.trial_descriptor.TrialType, 'train-cued') )
    next( state, program.Value.states('cue_off') );
  else
    next( state, program.Value.states('reward') );
  end
end
  
record_data( state, program );

end

function record_data(state, program)

td = program.Value.trial_data;
choice_data = dg.task.TrainingChoiceData();
choice_data.EntryTime = state.UserData.entry_time;
choice_data.ExitTime = state.UserData.exit_time;
choice_data.FixationState0 = state.UserData.fixation_acquired_state0;
choice_data.FixationState1 = state.UserData.fixation_acquired_state1;
td.TrainingDecision = choice_data;

program.Value.reward_channel_index = state.UserData.choice_index;

end

function draw_stimuli(program)

stim = program.Value.stimuli;
wins = program.Value.windows;
win_names = fieldnames( wins );
for i = 1:numel(win_names)
  draw( stim.choice_option0, wins.(win_names{i}) );
  if ( second_target_enabled(program) )
    draw( stim.choice_option1, wins.(win_names{i}) );
  end
end

for i = 1:numel(win_names)
  flip( wins.(win_names{i}) );
end

end

function tf = second_target_enabled(program)

tf = numel( program.Value.trial_descriptor.Outcomes ) >= 2;

end

function check_targets(state, program)

curr_time = elapsed( program.Value.task );

targ0 = program.Value.targets.choice_option0;
targ1 = program.Value.targets.choice_option1;

fix_acq_state0 = state.UserData.fixation_acquired_state0;
fix_acq_state1 = state.UserData.fixation_acquired_state1;

fix_acq_state0 = target_check( fix_acq_state0, targ0, curr_time );
fix_acq_state1 = target_check( fix_acq_state1, targ1, curr_time );

if ( isempty(state.UserData.choice_index) )
  if ( fix_acq_state0.Acquired )
    state.UserData.choice_index = 1;
  elseif ( second_target_enabled(program) && fix_acq_state1.Acquired )
    state.UserData.choice_index = 2;
  end
end

if ( fix_acq_state0.Acquired || fix_acq_state0.Broke ) 
  escape( state );
end

if ( second_target_enabled(program) )
  if ( fix_acq_state1.Acquired || fix_acq_state1.Broke ) 
    escape( state );
  end
end

state.UserData.fixation_acquired_state0 = fix_acq_state0;
state.UserData.fixation_acquired_state1 = fix_acq_state1;

end