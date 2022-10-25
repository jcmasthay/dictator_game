function state = reward(program, conf)

state = ptb.State();
state.Name = 'reward';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(~, program)

structfun( @flip, program.Value.windows );
dg.util.deliver_reward( program, 1, 0.3 );

end

function exit(state, program)

next( state, program.Value.states('iti') );

end