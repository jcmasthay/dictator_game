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
    case 'center'
      stims{i}.Position = [0.5, 0.5];
  end
end

end