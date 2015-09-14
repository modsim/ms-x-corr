% --------------------------------------------------------------------
function varargout = edMMeas_Callback

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
   set( handles.ListMeas, 'Value', Pos );
else
	if isempty( MeasList )
  	 	MeasList{end} = sprintf( 'M-%6.2f:%11.1f', nMass, 0 );
	else
	   MeasList{end+1} = sprintf( 'M-%6.2f:%11.1f', nMass, 0 );
	end
	set( handles.ListMeas, 'String', MeasList );
	set( handles.ListMeas, 'Max', length( MeasList ) );
	set( handles.ListMeas, 'Value', length( MeasList ) );
end

ListMeas_Callback;