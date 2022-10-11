classdef TrialDescriptor
  properties
    TrialType = 'choice'
    Outcomes = { 'self', 'both' };
    DelayToDecision = 0;
    DelayToReward = 0;
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
      value = validatestring( value, {'cued', 'choice'}, mfilename, 'TrialType' );
      obj.TrialType = value;
    end
    
    function obj = set.Outcomes(obj, outs)
      outs = cellstr( outs );
      for i = 1:numel(outs)
        outs{i} = validatestring( ...
          outs{i}, {'self', 'both', 'other', 'bottle'}, mfilename, 'Outcomes' );
      end
      obj.Outcomes = outs;
    end
  end
end