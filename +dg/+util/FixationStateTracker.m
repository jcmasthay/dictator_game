classdef FixationStateTracker
  properties
    Entered;
    Acquired;
    Broke;
    InBounds;
    EntryTimes;
    ExitTimes;
    AcquiredTime;
  end
  
  methods
    function obj = FixationStateTracker()
      obj.Entered = false;
      obj.Acquired = false;
      obj.Broke = false;
      obj.InBounds = false;
      obj.EntryTimes = [];
      obj.ExitTimes = [];
      obj.AcquiredTime = [];
    end
    
    function obj = target_check(obj, target, current_time)
      if ( ~target.IsInBounds )
        if ( obj.InBounds )
          obj.ExitTimes(end+1) = current_time;
          obj.Broke = true;
        end
        obj.InBounds = false;
      else
        obj.Entered = true;
        if ( ~obj.InBounds )
          obj.EntryTimes(end+1) = current_time;
        end
        obj.InBounds = true;
      end
      if ( target.IsDurationMet && ~obj.Acquired )
        obj.Acquired = true;
        obj.AcquiredTime = current_time;
      end
    end
  end
end