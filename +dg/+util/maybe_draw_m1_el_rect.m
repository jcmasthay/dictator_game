function maybe_draw_m1_el_rect(program, rect, color, clr_screen)

if ( nargin < 4 )
  clr_screen = true;
end

if ( isa(rect, 'ptb.XYTarget') )
  if ( isa(rect.Bounds, 'ptb.bounds.Rect') )
    rect = get_bounding_rect( rect.Bounds );
  else
    return
  end
elseif ( ~isa(rect, 'double') )
  return
end

if ( isfield(program.Value.gaze_sources, 'm1_gaze') && ...
     isa(program.Value.gaze_sources.m1_gaze, 'ptb.sources.Eyelink') )
  if ( clr_screen )
    Eyelink( 'Command', 'clear_screen 0' );
  end
  
  if ( isa(program.Value.gaze_sources.m1_gaze, 'ptb.sources.Eyelink') )
    dg.util.el_draw_rect( rect, color );
  end
end

end