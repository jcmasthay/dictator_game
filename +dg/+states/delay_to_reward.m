function state = delay_to_reward(program, conf)

state = ptb.State();
state.Name = 'delay_to_reward';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

state.Duration = program.Value.trial_descriptor.DelayToReward;
state.UserData.fixation_acquired_state = dg.util.FixationStateTracker();
state.UserData.entry_time = elapsed( program.Value.task );

reset( program.Value.targets.fix_square );
structfun( @flip, program.Value.windows );

end

function loop(state, program)

% draw_stimuli( program );
% check_target( state, program );

end

function exit(state, program)

% @TODO: Check for broken fixation
state.UserData.exit_time = elapsed( program.Value.task );

next( state, program.Value.states('reward') );
record_data( state, program );

end

function record_data(state, program)

td = program.Value.trial_data;
fix_data = dg.task.FixationData();
fix_data.EntryTime = state.UserData.entry_time;
fix_data.ExitTime = state.UserData.exit_time;
fix_data.FixationState = state.UserData.fixation_acquired_state;
td.DelayToReward = fix_data;

end

function draw_stimuli(program)

stim = program.Value.stimuli;
wins = program.Value.windows;
win_names = fieldnames( wins );
for i = 1:numel(win_names)
  draw( stim.fix_square, wins.(win_names{i}) );
end

for i = 1:numel(win_names)
  flip( wins.(win_names{i}) );
end

end

function check_target(state, program)

curr_time = elapsed( program.Value.task );
fix_target = program.Value.targets.fix_square;
fix_acq_state = state.UserData.fixation_acquired_state;

fix_acq_state = target_check( fix_acq_state, fix_target, curr_time );
if ( fix_acq_state.Broke )
  escape( state );
end

state.UserData.fixation_acquired_state = fix_acq_state;

end