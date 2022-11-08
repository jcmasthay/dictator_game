function state = cued_decision(program, conf)

state = ptb.State();
state.Name = 'cued_decision';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

state.UserData.fixation_acquired_state = dg.util.FixationStateTracker();
state.UserData.entry_time = elapsed( program.Value.task );

targ = program.Value.targets.cued_decision;
reset( targ );

end

function loop(state, program)

draw_stimuli( program );
check_target( state, program );

end

function exit(state, program)

state.UserData.exit_time = elapsed( program.Value.task );

next( state, program.Value.states('delay_to_reward') );
record_data( state, program );

end

function record_data(state, program)

td = program.Value.trial_data;
choice_data = dg.task.ChoiceData();
choice_data.EntryTime = state.UserData.entry_time;
choice_data.ExitTime = state.UserData.exit_time;
choice_data.FixationState0 = state.UserData.fixation_acquired_state;
td.CuedDecision = choice_data;

end

function draw_stimuli(program)

stim = program.Value.stimuli;

program.Value.conf.configure_stimulus( stim.cued_decision, program.Value.trial_descriptor, 1 );

wins = program.Value.windows;
win_names = fieldnames( wins );
for i = 1:numel(win_names)
  draw( stim.cued_decision, wins.(win_names{i}) );
end

for i = 1:numel(win_names)
  flip( wins.(win_names{i}) );
end

end

function check_target(state, program)

curr_time = elapsed( program.Value.task );
targ = program.Value.targets.cued_decision;

fix_acq_state = state.UserData.fixation_acquired_state;

fix_acq_state = target_check( fix_acq_state, targ, curr_time );
if ( fix_acq_state.Acquired || fix_acq_state.Broke )
  escape( state );
end

state.UserData.fixation_acquired_state = fix_acq_state;

end