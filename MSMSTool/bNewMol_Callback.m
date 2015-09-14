function varagout = bNewMol_Callback

global MolList handles eMolList

iMolSel = get( handles.ListMol, 'Value' );

if isempty( MolList(end).Name )
   MolList(end).Name    = '';
else
   MolList(end+1).Name  = '';
end

MolList(end).FragmentIon = eMolList(1).FragmentIon;
MolList(end).MotherIon = eMolList(1).MotherIon;

iMax  = length( MolList );

for j=1:iMax
    cList{j}=MolList(j).Name;
end

set( handles.ListMol, 'String', cList );
set( handles.ListMol, 'Max', iMax );
set( handles.ListMol, 'Value', iMax );

ListMol_Callback;
