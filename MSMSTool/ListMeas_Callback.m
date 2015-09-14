% --------------------------------------------------------------------
function varargout = ListMeas_Callback

global MolList handles

nSel  = get( handles.ListMeas, 'Value' );
cList = get( handles.ListMeas, 'String' );

set( handles.edMMeas, 'String', '' );
set( handles.edValMeas, 'String', '' );

if length( nSel ) > 1 | isempty( nSel )
   return
end

if ~isempty( cList ),

	sMeas = cList{ nSel };

	nMass = str2num( sMeas(3:8) );
	nVal  = str2num( sMeas(10:20) );

	set( handles.edMMeas, 'String', num2str( nMass ) );
   set( handles.edValMeas, 'String', num2str( nVal ) );
   
end   