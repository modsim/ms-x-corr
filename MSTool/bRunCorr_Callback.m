function varagout = bRunCorr_Callback

global handles MolList Meas

iSel = get( handles.ListMol, 'Value' );
sSel = get( handles.ListSamples, 'Value' );

if isempty( MolList(1).DeriList( iSel ).MeasData ),
   return
end

nIso    = MolList( 1 ).DeriList( iSel ).iC + 1;
m0      = MolList( 1 ).DeriList( iSel ).m0;

mNoise = str2num( get( handles.edNoiseMean, 'String' ) );
dNoise = str2num( get( handles.edNoiseDev, 'String' ) );

if isempty( mNoise ),	mNoise = 0; end
if isempty( dNoise ),   dNoise = 1; end

nMore = [0,0];
if ~isempty( MolList( 1 ).DeriList(iSel).nBack ),   nMore(1) = MolList(1).DeriList(iSel).nBack; end
if ~isempty( MolList( 1 ).DeriList(iSel).nForw ),   nMore(2) = MolList(1).DeriList(iSel).nForw; end

tmp = MolList(1).DeriList(iSel).MeasData(1,:)';

Pos = find( tmp >= m0 & tmp < m0+1 );

nM 	= nIso+nMore(1)+nMore(2);
MeasVec = [ MolList(1).DeriList(iSel).MeasData(      1, Pos-nMore(1):Pos+nIso+nMore(2)-1 )' ...
            MolList(1).DeriList(iSel).MeasData( sSel+1, Pos-nMore(1):Pos+nIso+nMore(2)-1 )' ];

MeasVec = MeasVec(:,2) - repmat( mNoise, nM, 1 );

bFrac = get( handles.cbFracVal, 'Value' );

Meas.nMP = nM;
Meas.Vec = MeasVec;
Meas.nShift = nMore;
Meas.DevNoise = dNoise;
Meas.MeanNoise = mNoise;
Meas.nIso = nIso;
Meas.bFrac = bFrac;
Meas.bEstMeas = get( handles.cbAutoStat, 'Value' ) == 1;

Meas = funCorr( MolList(1).DeriList(iSel), Meas, Meas.bEstMeas );

if bFrac == 1, 
   format = 'm+%g: %6.4f ±%5.4f';
else
   format = 'm+%g: %8.0f ±%5.4f';
end

for k=1:nIso
   cCorr{k} = sprintf( format, k-1, Meas.EstVec(k)/Meas.one, Meas.EstDev(k)/Meas.one );
end

cCorr{end+1} = '';

if Meas.bEstMeas == 1,   
   cCorr{end+1} = '------------------';
   cCorr{end+1} = sprintf( 'N. mean= %9.2f', Meas.EstMeanNoise );
   cCorr{end+1} = sprintf( 'N. dev.= %9.2f', Meas.EstDevNoise );
end

load( ['chi2mat.mat'], '-mat' );

cCorr{end+1} = '------------------';
cCorr{end+1} = sprintf( 'Chi-Sq= %10.4f', Meas.ChiSq );
cCorr{end+1} = sprintf( 'Chi-Sq (%g,%g dgF)', 0.9, Meas.dgF );
cCorr{end+1} = sprintf( ' = %10.5f', chi2mat( Meas.dgF+1, 1 ) );

set( handles.ListCorr, 'Value', 1);
set( handles.ListCorr, 'String', cCorr );
set( handles.ListCorr, 'Max', length(cCorr) );   