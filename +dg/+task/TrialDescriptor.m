classdef TrialDescriptor
  properties
    TrialType = 'choice'
    Outcomes = { 'self', 'both' };
    DelayToDecision = 0;
    DelayToReward = 0;
    ChoiceTargetEccentricities = { 'top-left', 'top-right' };
    RewardChannels = {1, 1:2};
    DisablePostFixationCue = false;
    FixationStimulusColor = ptb.Color.White();
    PreferOutcomeStimulusImages = false;
    OutcomeStimulusScale = 1;
  end
  
  methods
    function obj = TrialDescriptor()
    end
    
    function obj = set.DelayToDecision(obj, value)
      validateattributes( value, {'double'}, {'scalar'}, mfilename, 'DelayToDecision' );
      obj.DelayToDecision = value;
    end
    
    function obj = set.DelayToReward(obj, value)
      validateattributes( value, {'double'}, {'scalar'}, mfilename, 'DelayToReward' );
      obj.DelayToReward = value;
    end
    
    function obj = set.TrialType(obj, value)
      value = validatestring( value, {'cued', 'choice', 'train-cued', 'train-choice'}, mfilename, 'TrialType' );
      obj.TrialType = value;
    end
    
    function obj = set.ChoiceTargetEccentricities(obj, value)
      value = cellstr( value );
      for i = 1:numel(value)
        value{i} = validatestring( ...
          value{i}, {'center', 'top-left', 'top-right', 'bottom-left', 'bottom-right'} ...
          , mfilename, 'ChoiceTargetEccentricities' );
      end
      obj.ChoiceTargetEccentricities = value;
    end
    
    function obj = set.RewardChannels(obj, v)
      validateattributes( v, {'cell'}, {}, mfilename, 'RewardChannels' );
      for i = 1:numel(v)
        validateattributes( v{i}, {'double'}, {'integer'}, mfilename, 'RewardChannels' );  
      end
      obj.RewardChannels = v;
    end
    
    function obj = set.Outcomes(obj, outs)
      outs = cellstr( outs );
      for i = 1:numel(outs)
        outs{i} = validatestring( ...
          outs{i}, {'self', 'both', 'other', 'bottle'}, mfilename, 'Outcomes' );
      end
      obj.Outcomes = outs;
    end
    
    function obj = set.PreferOutcomeStimulusImages(obj, v)
      validateattributes( v, {'logical'}, {'scalar'} ...
        , mfilename, 'PreferOutcomeStimulusImages' );
      obj.PreferOutcomeStimulusImages = v;
    end
    
    function obj = set.DisablePostFixationCue(obj, v)
      validateattributes( v, {'logical'}, {'scalar'}, mfilename, 'DisablePostFixationCue' );
      obj.DisablePostFixationCue = v;
    end
    
    function obj = set.FixationStimulusColor(obj, color)
      validateattributes( color, {'ptb.Color', 'char'}, {}, mfilename, 'FixationStimulusColor' );
      obj.FixationStimulusColor = color;
    end
    
    function obj = set.OutcomeStimulusScale(obj, scl)
      validateattributes( scl, {'double'}, {'scalar'}, mfilename, 'OutcomeStimulusScale' );
      obj.OutcomeStimulusScale = scl;
    end
  end
end