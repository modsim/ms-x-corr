% --------------------------------------------------------------------
function varargout = bDelAllDeri_Callback

global MolList handles

iMolSel  = get( handles.ListMol, 'Value' );
iDeriSel = get( handles.ListDeri, 'Value' );
iMax     = get( handles.ListDeri, 'Max' );

MolList(iMolSel).DeriList = struct( 'Name', {''}, 'SumForm', {''}, 'm0', {''}, 'StM0', {''}, 'nM',{''}, ...
                                    'nC', {''}, 'nH', {''}, 'nO', {''}, 'nN', {''}, 'nS', {''}, 'nP', {''}, 'nSi', {''}, 'iC', {''} );
iMax  = max( iMax-1, 1 );

if iDeriSel > iMax,
    iDeriSel = iMax;
end

cList = {}

for j=1:length( MolList(iMolSel).DeriList )
    cList{j} = MolList(iMolSel).DeriList(j).Name
end

set( handles.ListDeri, 'Value', iDeriSel );
set( handles.ListDeri, 'Max', iMax );

set( handles.ListDeri, 'String', cList );

ListDeri_Callback;
