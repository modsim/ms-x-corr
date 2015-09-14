% --------------------------------------------------------------------
function varargout = bDelMeas_Callback

global MolList handles

nSel  = get( handles.ListMeas, 'Value' );
cList = get( handles.ListMeas, 'String' );
nMax  = get( handles.ListMeas, 'Max' );

cList = { cList{1:nSel-1}, cList{nSel+1:end} };
nMax  = max( length( cList ), 1 );

if nSel > length( cList ),
    nSel = max( length( cList ), 1 );
end

set( handles.ListMeas, 'Value', nSel );
set( handles.ListMeas, 'Max', max( nSel, length( cList ) ) );
set( handles.ListMeas, 'String', cList );
