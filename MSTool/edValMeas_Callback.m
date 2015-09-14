% --------------------------------------------------------------------
function varargout = edValMeas_Callback

global MolList handles

iMax     = get( handles.ListMeas, 'Max' );
nMass		= str2num( get( handles.edMMeas, 'String' ) );
nVal		= str2num( get( handles.edValMeas, 'String' ) );
MeasList = get( handles.ListMeas, 'String' );

if isempty( nMass )
   return
end

Pos = strmatch( sprintf( 'M-%6.2f', nMass ), MeasList);

if ~isempty( Pos ),
	 MeasList{Pos} = sprintf( 'M-%6.2f:%11.1f', nMass, nVal );
	set( handles.ListMeas, 'String', MeasList );
   set( handles.ListMeas, 'Value', Pos );
end

ListMeas_Callback;