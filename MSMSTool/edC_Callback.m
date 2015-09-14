function varagout = edC_Callback 

global MolList handles AtomList

iSel = get( handles.ListMol, 'Value' );
dSel = get( handles.ListDeri, 'Value' );

CChain = get( handles.edC, 'String' );

if isempty(CChain),
  MolList( iSel ).DeriList( dSel ).nChain = ['1-' int2str( MolList(iSel).DeriList(dSel).iC ) ];
else
  MolList( iSel ).DeriList( dSel ).nChain = CChain;
end
