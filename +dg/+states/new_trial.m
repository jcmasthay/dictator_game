function state = new_trial(program, ~)

state = ptb.State();
state.Name = 'new_trial';
state.Duration = 0;
state.Entry = @(state) entry(state, program);

end

function entry(state, program)

program.Value.trial_descriptor = next_trial_descriptor( program );
program.Value.trial_data = dg.task.TrialData();
program.Value.trial_data.TrialDescriptor = program.Value.trial_descriptor;

next( state, program.Value.states('fixation') );

end

function desc = next_trial_descriptor(program)

[program.Value.trial_set, desc] = next( program.Value.trial_set );

end