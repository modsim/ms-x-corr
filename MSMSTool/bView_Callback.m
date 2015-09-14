function varagout = bView_Callback( varagin )

global handles MolList Meas

if isempty( Meas.EstVec ),
   return
end

gFig = findobj( 'Tag', 'DisplMeas' );

if ~isempty( gFig ),
    figure( gFig );
else
   gFig = figure( 'Position', [100 100 600 550], 'Tag', 'DisplMeas' );
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

h = errorbar( cMass + repmat( 0.05, 1, length(cMass)), Meas.EstVec/Meas.one, Meas.EstDev/Meas.one );
set( h, 'LineStyle', '-', 'Color', 'r' );

plot( cMass + repmat( 0.05, 1, length(cMass)), Meas.EstVec/Meas.one, '-w' );

h = stem( cMass, Meas.EstVec / Meas.one, '.k-' );
set( h, 'LineWidth', 1.0, 'MarkerSize', 6 );

h = stem( mMass - repmat( 0.1, 1, length(mMass) ), Meas.Vec / Meas.one, 'b-o' );
set( h, 'LineWidth', 0.5, 'MarkerSize', 3 );

hold off

return