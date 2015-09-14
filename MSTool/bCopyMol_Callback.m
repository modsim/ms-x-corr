% --------------------------------------------------------------------
function varargout = bCopyMol_Callback

global MolList handles

iMolSel  = get( handles.ListMol, 'Value' );
iMax     = get( handles.ListMol, 'Max' ) + 1;
cList 	= get( handles.ListMol, 'String' );

MolList(1).DeriList(end+1) = MolList(1).DeriList(iMolSel);

cList{end+1} = MolList(1).DeriList(end).Name;

set( handles.ListMol, 'String', cList );
set( handles.ListMol, 'Max', iMax );
set( handles.ListMol, 'Value', iMax );

ListMol_Callback;