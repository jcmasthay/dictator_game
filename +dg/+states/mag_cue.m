function state = mag_cue(program, conf)

state = ptb.State();
state.Name = 'mag_cue';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

state.UserData.entry_time = elapsed( program.Value.task );

end

function loop(state, program)

draw_stimuli( program );

end

function exit(state, program)

next( state, program.Value.states('delay_to_decision') );
state.UserData.exit_time = elapsed( program.Value.task );
record_data( state, program );

end

function record_data(state, program)

td = program.Value.trial_data;
cue_data = dg.task.MagCueData();
cue_data.EntryTime = state.UserData.entry_time;
cue_data.ExitTime = state.UserData.exit_time;
td.MagCue = cue_data;

end

function draw_stimuli(program)

stim = program.Value.stimuli;
wins = program.Value.windows;
win_names = fieldnames( wins );
for i = 1:numel(win_names)
  draw( stim.mag_cue, wins.(win_names{i}) );
end

for i = 1:numel(win_names)
  flip( wins.(win_names{i}) );
end

end