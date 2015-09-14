% --------------------------------------------------------------------
function varargout = bDelDeri_Callback

global MolList handles eMolList

iMolSel  = get( handles.ListMol, 'Value' );
iDeriSel = get( handles.ListDeri, 'Value' );
iMax     = get( handles.ListDeri, 'Max' );

if iDeriSel == 1
    MolList(iMolSel).DeriList = MolList(iMolSel).DeriList(2:end);
else
    MolList(iMolSel).DeriList = [ MolList(iMolSel).DeriList(1:iDeriSel-1), MolList(iMolSel).DeriList(iDeriSel+1:end) ];
end

if isempty( MolList( iMolSel ).DeriList ),
   MolList(iMolSel).DeriList = eMolList(1).DeriList;
end

iMax  = length( MolList(iMolSel).DeriList );
MolList(iMolSel).DeriList;

if iDeriSel > iMax,
    iDeriSel = iMax;
end

cList = {};

for j=1:length( MolList(iMolSel).DeriList ),
    cList{j} = MolList(iMolSel).DeriList(j).Name;
end

set( handles.ListDeri, 'String', cList );
set( handles.ListDeri, 'Max', iMax );
set( handles.ListDeri, 'Value', iDeriSel );

ListDeri_Callback;
