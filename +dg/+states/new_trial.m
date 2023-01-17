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

set_choice_target_positions( program, program.Value.trial_descriptor );

next( state, program.Value.states('fixation') );

end

function desc = next_trial_descriptor(program)

[program.Value.trial_set, desc] = next( program.Value.trial_set );
validate_trial_desc( program, desc );

end

function set_choice_target_positions(program, desc)

stims = { ...
    program.Value.stimuli.choice_option0 ...
  , program.Value.stimuli.choice_option1 ...
};

offset = 0.125;

for i = 1:numel(desc.ChoiceTargetEccentricities)
  switch ( desc.ChoiceTargetEccentricities{i} )
    case 'top-left'
      stims{i}.Position = [offset, offset];
    case 'top-right'
      stims{i}.Position = [1 - offset, offset];
    case 'bottom-left'
      stims{i}.Position = [offset, 1 - offset];
    case 'bottom-right'
      stims{i}.Position = [1 - offset, 1 - offset];
  end
end

end

function validate_trial_desc(~, desc)

assert( numel(desc.ChoiceTargetEccentricities) <= 2 ...
  , 'Expected at most 2 choice target eccentricity specifiers.' );

assert( numel(desc.ChoiceTargetEccentricities) == numel(desc.Outcomes) ...
  , 'Expected 1 choice target eccentricity specifier for each outcome.' );

end