function state = iti(program, conf)

state = ptb.State();
state.Name = 'iti';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(state, program)

structfun( @flip, program.Value.windows );

end

function exit(state, program)

next( state, program.Value.states('end_trial') );

end