function state = reward(program, conf)

state = ptb.State();
state.Name = 'reward';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(~, program)

structfun( @flip, program.Value.windows );

reward_info = program.Value.conf.reward;
dg.util.deliver_reward( program, reward_info.channel, reward_info.main );

end

function exit(state, program)

next( state, program.Value.states('iti') );

end