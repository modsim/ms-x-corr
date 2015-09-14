function varagout = bViewRes_Callback( varagin )

global handles MolList Meas

if isempty( Meas.EstVec ),
   return
end

gFig = findobj( 'Tag', 'DisplRes' );

if ~isempty( gFig ),
    figure( gFig );
else
   gFig = figure( 'Position', [100 100 600 550], 'Tag', 'DisplRes' );
end

clf reset

xLabel = {};

for i=-Meas.nShift(1):Meas.nIso+Meas.nShift(2)
   xLabel{end+1} = sprintf('m%g',i);
end

ax1 = axes( 'Position', [0.1 0.1 0.85 0.85], ...
            'XLim', [ -Meas.nShift(1)-0.2 Meas.nIso+Meas.nShift(2)-0.8 ], ...
            'Box', 'On', ...
            'XTick', -Meas.nShift(1):Meas.nIso+Meas.nShift(2)-1, 'XTickLabel', xLabel, ...
            'YGrid', 'On', ...
            'FontSize', 8, ...
            'TickLength', [0 0] );

set( gFig, 'CurrentAxes', ax1 );

mMass = -Meas.nShift(1):Meas.nIso+Meas.nShift(2)-1;
cMass = 0:Meas.nIso-1;

hold on

plot( [ -0.2-Meas.nShift(1), Meas.nIso+Meas.nShift(2)-0.9 ], [ 0 0 ], '-k' );

h = stem( mMass, Meas.Vec - Meas.ModVec, 'xr' );
set( h, 'LineWidth', 1.0, 'MarkerSize', 6 );

if Meas.nShift(2) > 0,
   h = stem( mMass( end-Meas.nShift(2)+1:end), Meas.Vec( end-Meas.nShift(2)+1:end) - Meas.ModVec( end-Meas.nShift(2)+1:end ), 'xb' );
   set( h, 'LineWidth', 0.5, 'MarkerSize', 4 );
end

if Meas.nShift(1) > 0,
	h = stem( mMass( 1:Meas.nShift(1) ), Meas.Vec( 1:Meas.nShift(1) ) - Meas.ModVec( 1:Meas.nShift(1) ), 'xb' );
   set( h, 'LineWidth', 0.5, 'MarkerSize', 4 );
end

hold off

return