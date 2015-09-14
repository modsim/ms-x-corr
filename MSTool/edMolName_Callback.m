function varagout = edMolName_Callback

global MolList handles

iMolSel = get( handles.ListMol, 'Value' );
iMax     = get( handles.ListMol, 'Max' );
Name	= get( handles.edMolName, 'String' );

Pos = 0;

for i=1:length( MolList ),
   if strcmp( MolList(1).DeriList(i).Name, Name ),
      Pos = i;
   end
end

if Pos ~ 0,
   set( handles.ListMol, 'Value', Pos );
else
   MolList(1).DeriList( iMolSel ).Name = Name;
   cList = get( handles.ListMol, 'String' );
   cList{iMolSel} = Name;
   set( handles.ListMol, 'String', cList );
end

ListMol_Callback;