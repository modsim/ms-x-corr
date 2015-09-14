% --------------------------------------------------------------------
function varargout = edDeriName_Callback

global MolList handles

iMolSel  = get( handles.ListMol,  'Value' );
iDeriSel = get( handles.ListDeri, 'Value' );
iMax     = get( handles.ListDeri, 'Max' );
Name 		= get( handles.edDeriName, 'String' );

Pos = 0;

for i=1:length( MolList(iMolSel).DeriList ),
   if strcmp( MolList(iMolSel).DeriList(i).Name, Name ),
      Pos = i;
   end
end

if Pos ~ 0,
   set( handles.ListDeri, 'Value', Pos );
   ListDeri_Callback;
   return
end

if isempty( MolList(iMolSel).DeriList(end).Name )
   MolList(iMolSel).DeriList(end).Name  = get( handles.edDeriName,  'String' );
else
   MolList(iMolSel).DeriList(end+1).Name  = get( handles.edDeriName,  'String' );
end

MolList(iMolSel).DeriList(end).SumForm = get( handles.edSumForm, 'String' );
MolList(iMolSel).DeriList(end).m0 = '';

iMax  = length( MolList(iMolSel).DeriList );

for j=1:iMax
    cList{j}=MolList(iMolSel).DeriList(j).Name;
end

set( handles.ListDeri, 'String', cList );
set( handles.ListDeri, 'Max', iMax );
set( handles.ListDeri, 'Value', iMax );

ListDeri_Callback;