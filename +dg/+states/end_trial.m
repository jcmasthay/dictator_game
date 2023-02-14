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

end