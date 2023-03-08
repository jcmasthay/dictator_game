function state = cue_on(program, conf)

state = ptb.State();
state.Name = 'cue_on';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

state.UserData.entry_time = elapsed( program.Value.task );
state.UserData.fixation_acquired_state0 = dg.util.FixationStateTracker();

program.Value.stimuli.choice_option0.Position = [0.5, 0.5];

targ0 = program.Value.targets.choice_option0;
reset( targ0 );

end

function loop(state, program)

draw_stimuli( program );
check_targets( state, program );

end

function exit(state, program)

state.UserData.exit_time = elapsed( program.Value.task );

fix_acq_state0 = state.UserData.fixation_acquired_state0;
if ( ~fix_acq_state0.Acquired && fix_acq_state0.Broke )
  next( state, program.Value.states('target_error') );
else
  next( state, program.Value.states('cue_off') );
end

record_data( state, program );

end

function record_data(state, program)

td = program.Value.trial_data;
choice_data = dg.task.TrainingChoiceData();
choice_data.EntryTime = state.UserData.entry_time;
choice_data.ExitTime = state.UserData.exit_time;
choice_data.FixationState0 = state.UserData.fixation_acquired_state0;
td.CueOn = choice_data;

end

function draw_stimuli(program)

stim = program.Value.stimuli;
wins = program.Value.windows;
win_names = fieldnames( wins );
for i = 1:numel(win_names)
  draw( stim.choice_option0, wins.(win_names{i}) );
end

for i = 1:numel(win_names)
  flip( wins.(win_names{i}) );
end

end

function check_targets(state, program)

curr_time = elapsed( program.Value.task );

targ0 = program.Value.targets.choice_option0;
fix_acq_state0 = state.UserData.fixation_acquired_state0;
fix_acq_state0 = target_check( fix_acq_state0, targ0, curr_time );

if ( ~fix_acq_state0.Acquired && fix_acq_state0.Broke )
  escape( state );
end

state.UserData.fixation_acquired_state0 = fix_acq_state0;

end