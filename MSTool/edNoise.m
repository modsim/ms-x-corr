function edNoise
global MolList handles

% change in noise parameters
% make it specific for a set of measurements

iSel = get( handles.ListMol, 'Value' );

bias = str2num( get( handles.edNoiseMean, 'String' ) );
stddev = str2num( get( handles.edNoiseDev, 'String' ) );

if isempty( bias ),	bias = 0; end
if isempty( stddev ),   stddev = 1; end

MolList.DeriList( iSel ).Bias = bias;
MolList.DeriList( iSel ).StdDev = stddev;