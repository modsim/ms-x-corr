function varagout = bNewMol_Callback

global MolList handles eMolList

iMolSel = get( handles.ListMol, 'Value' );

if isempty( MolList(1).DeriList(end).Name )
   MolList(1).DeriList(end).Name    = '';
else
   MolList(1).DeriList(end+1).Name  = '';
end

MolList(1).DeriList(end)	= eMolList(1).DeriList;

iMax  = length( MolList(1).DeriList );

for j=1:iMax
    cList{j}=MolList(1).DeriList(j).Name;
end

set( handles.ListMol, 'String', cList );
set( handles.ListMol, 'Max', iMax );
set( handles.ListMol, 'Value', iMax );

ListMol_Callback;