function varagout = bRunCorr_Callback

global handles MolList Meas AtomList

iMolSel = get( handles.ListMol, 'Value' );
iMeasList  = get( handles.ListMeas, 'Value' );

if isempty( MolList( iMolSel ).DataFile ),
   return
end

mNoise = str2double( get( handles.edNoiseMean, 'String' ) );
dNoise = str2double( get( handles.edNoiseDev, 'String' ) );

if isempty( mNoise ),	mNoise = 0; end
if isempty( dNoise ),   dNoise = 1; end

%mData = loadMeasData( [ MolList(iMolSel).DataPath MolList( iMolSel ).DataFile ] );
Meas = funCorr_TM( MolList(iMolSel) );

format = 'y%d.%d = %10.3f ';
cCorr = {};

for k=1:size( Meas( iMeasList ).yTM, 1 ),
    %disp( MolList(iMolSel) )
    %disp( Meas(1) )
    cCorr{end+1} = sprintf( format, Meas( iMeasList ).yTM(k,1), Meas(iMeasList).yTM(k,2), Meas(iMeasList).EstVec( k ) );
end

cCorr{end+1} = '';

set( handles.ListCorr, 'Value', 1);
set( handles.ListCorr, 'String', cCorr );
set( handles.ListCorr, 'Max', length(cCorr) );   

return
