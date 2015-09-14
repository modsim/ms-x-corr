% --------------------------------------------------------------------
function varargout = bDelMol_Callback

global MolList handles

iMolSel  = get( handles.ListMol, 'Value' );
iMax     = get( handles.ListMol, 'Max' );

if ~(length( MolList ) > 1),
    MolList = [];
    MolList = struct( 'Name', {''}, 'SumForm', {''}, 'DeriList', {}, 'DataFile', {''} );
    MolList(iMolSel).DeriList = struct( 'Name', {''}, 'SumForm', {''}, 'm0', {''}, 'StM0', {''}, 'nM',{''}, ...
        'nC', {''}, 'nH', {''}, 'nO', {''}, 'nN', {''}, 'nS', {''}, 'nP', {''}, 'nSi', {''}, 'iC', {''} );
else
    if iMolSel == 1,
        MolList = MolList(2:end);
    else
        MolList = [ MolList(1:iMolSel-1), MolList(iMolSel+1:end) ];
    end
end

iMax  = length(MolList);

if iMolSel > iMax,
    iMolSel = iMax;
end

cList = {};

for j=1:length( MolList ),
    cList{j} = MolList(j).Name;
end

set( handles.ListMol, 'String', cList );
set( handles.ListMol, 'Value', iMolSel );
set( handles.ListMol, 'Max', iMax );

ListMol_Callback;