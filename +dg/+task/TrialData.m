classdef TrialData < handle
  properties
    TrialDescriptor;
    Fixation;
    MagCue;
    DelayToDecision;
    CuedDecision;
    TrueDecision;
  end
  methods
    function obj = TrialData()
    end
    
    function set.TrialDescriptor(obj, data)
      validateattributes( data, {'dg.task.TrialDescriptor'}, {}, mfilename, 'TrialDescriptor' );
      obj.TrialDescriptor = data;
    end
    
    function set.Fixation(obj, data)
      validateattributes( data, {'dg.task.FixationData'}, {}, mfilename, 'Fixation' );
      obj.Fixation = data;
    end
    
    function set.MagCue(obj, data)
      validateattributes( data, {'dg.task.MagCueData'}, {}, mfilename, 'MagCue' );
      obj.MagCue = data;
    end
    
    function set.DelayToDecision(obj, data)
      validateattributes( data, {'dg.task.FixationData'}, {}, mfilename, 'DelayToDecision' );
      obj.DelayToDecision = data;
    end
    
    function set.CuedDecision(obj, data)
      validateattributes( data, {'dg.task.ChoiceData'}, {}, mfilename, 'CuedDecision' );
      obj.CuedDecision = data;
    end
    
    function set.TrueDecision(obj, data)
      validateattributes( data, {'dg.task.ChoiceData'}, {}, mfilename, 'TrueDecision' );
      obj.TrueDecision = data;
    end
  end
end