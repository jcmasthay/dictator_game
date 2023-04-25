function state = target_error(program, conf)

state = ptb.State();
state.Name = 'target_error';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Loop = @(state) loop(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

structfun( @flip, program.Value.windows );

end

function loop(state, program)

draw_stimuli( program );

end

function draw_stimuli(program)

stim = program.Value.stimuli;
wins = program.Value.windows;
win_names = fieldnames( wins );
for i = 1:numel(win_names)
  draw( stim.target_error, wins.(win_names{i}) );
end

for i = 1:numel(win_names)
  flip( wins.(win_names{i}) );
end

end

function exit(state, program)

next( state, program.Value.states('end_trial') );

end