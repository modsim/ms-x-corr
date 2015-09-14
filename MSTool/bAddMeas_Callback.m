% --------------------------------------------------------------------
function varargout = bAddMeas_Callback

global MolList handles

nMass = str2num( get( handles.edMMeas, 'String' ) );
nVal  = str2num( get( handles.edValMeas, 'String' ) );

if ~isempty( nMass ) & ~isempty( nVal )
    ListMeas = get( handles.ListMeas, 'String' );
    ListMeas{end+1} = sprintf( 'M-%3f: %11.4f', nMass, nVal );
    set( handles.ListMeas, 'String', ListMeas );
end
