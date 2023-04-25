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
program.Value.reward_channel_index = 1;

set_choice_target_style( program, program.Value.trial_descriptor );
set_fixation_square_style( program, program.Value.trial_descriptor );

next( state, program.Value.states('fixation') );

end

function desc = next_trial_descriptor(program)

[program.Value.trial_set, desc] = next( program.Value.trial_set );
validate_trial_desc( program, desc );

end

function set_choice_target_style(program, desc)

stim = program.Value.stimuli;
program.Value.conf.configure_stimulus( program, stim.choice_option0, desc, 1 );

if ( numel(desc.Outcomes) > 1 )
  program.Value.conf.configure_stimulus( program, stim.choice_option1, desc, 2 );
end

end

function set_fixation_square_style(prog, desc)

color = desc.FixationStimulusColor;
stim = prog.Value.stimuli.fix_square;
if ( isa(color, 'ptb.Color') )
  %
elseif ( isa(color, 'char') )
  ims = prog.Value.images;
  im = ims.(color);
  if ( ~isa(im, 'ptb.Image') )
    im = ptb.Image( prog.Value.windows.main, im );
    prog.Value.images.(color) = im;    
  end  
  color = im;
else
  error( 'Expected fixation square style to be a color or char image name.' );
end

stim.FaceColor = color;

end

function validate_trial_desc(~, desc)

assert( numel(desc.ChoiceTargetEccentricities) <= 2 ...
  , 'Expected at most 2 choice target eccentricity specifiers.' );

assert( numel(desc.ChoiceTargetEccentricities) == numel(desc.Outcomes) ...
  , 'Expected 1 choice target eccentricity specifier for each outcome.' );

assert( numel(desc.RewardChannels) <= 2 ...
  , 'Expected at most 2 reward channels.' );

assert( numel(desc.RewardChannels) == numel(desc.Outcomes) ...
  , 'Expected 1 rewarch channel for each outcome.' );

end