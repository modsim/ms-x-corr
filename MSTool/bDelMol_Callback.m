% --------------------------------------------------------------------
function varargout = bDelMol_Callback

global MolList handles

iMolSel  = get( handles.ListMol, 'Value' );
iMax     = get( handles.ListMol, 'Max' );

if iMolSel == 1,
      MolList(1).DeriList = MolList(1).DeriList(2:end);
else
      MolList(1).DeriList = [ MolList(1).DeriList(1:iMolSel-1), MolList(1).DeriList(iMolSel+1:end) ];
end

iMax  = length(MolList(1).DeriList);

if iMolSel > iMax,
    iMolSel = iMax;
end

cList = {};

for j=1:length( MolList ),
    cList{j} = MolList(1).DeriList(j).Name;
end

set( handles.ListMol, 'String', cList );
set( handles.ListMol, 'Value', iMolSel );
set( handles.ListMol, 'Max', iMax );

ListMol_Callback;