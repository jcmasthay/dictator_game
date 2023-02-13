classdef TrialData < handle
  properties
    TrialDescriptor;
    Fixation;
    CueOn;
    CueOff;
    MagCue;
    DelayToDecision;
    CuedDecision;
    TrueDecision;
    TrainingDecision;
    DelayToReward;
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
    
    function set.DelayToReward(obj, data)
      validateattributes( data, {'dg.task.FixationData'}, {}, mfilename, 'DelayToReward' );
      obj.DelayToReward = data;
    end
    
    function set.CueOn(obj, data)
      validateattributes( data, {'dg.task.TrainingChoiceData'}, {}, mfilename, 'CueOn' );
      obj.CueOn = data;
    end
    
    function set.CueOff(obj, data)
      validateattributes( data, {'dg.task.FixationData'}, {}, mfilename, 'CueOff' );
      obj.CueOff = data;
    end
    
    function set.CuedDecision(obj, data)
      validateattributes( data, {'dg.task.ChoiceData'}, {}, mfilename, 'CuedDecision' );
      obj.CuedDecision = data;
    end
    
    function set.TrueDecision(obj, data)
      validateattributes( data, {'dg.task.ChoiceData'}, {}, mfilename, 'TrueDecision' );
      obj.TrueDecision = data;
    end
    
    function set.TrainingDecision(obj, data)
      validateattributes( data, {'dg.task.TrainingChoiceData'}, {}, mfilename, 'TrainDecision' );
      obj.TrainingDecision = data;
    end
  end
end