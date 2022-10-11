classdef TrialSet
  properties
    Trials;
    TrialIndex = 0;
  end
  
  methods
    function obj = TrialSet()
    end
    
    function obj = set.Trials(obj, trials)
      validateattributes( trials ...
        , {'dg.task.TrialDescriptor'}, {}, mfilename, 'Trials' );
      obj.Trials = trials;
    end
    
    function tf = finished(obj)
      tf = obj.TrialIndex >= numel( obj.Trials );
    end
    
    function [obj, trial] = next(obj)
      ti = min( obj.TrialIndex + 1, numel(obj.Trials) );
      trial = obj.Trials(ti);
      obj.TrialIndex = ti;
    end
  end
end