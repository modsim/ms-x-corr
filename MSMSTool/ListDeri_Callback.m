% --------------------------------------------------------------------
function varargout = ListDeri_Callback

global MolList handles

iMolSel  = get( handles.ListMol, 'Value' );
iDeriSel = get( handles.ListDeri,'Value' );

if isempty( MolList(iMolSel).DeriList ),
    set( handles.edDeriName, 'String', '' );
    set( handles.edSumForm, 'String', '' );
    set( handles.edSepForm, 'String', '' );
    set( handles.edC, 'String', '' );
    set( handles.dm0, 'String', '' );
    set( handles.edIsoBack, 'String', '' );
    set( handles.edIsoForw, 'String', '' );
else
    set( handles.edDeriName, 'String', MolList(iMolSel).DeriList(iDeriSel).Name );
    set( handles.edSumForm, 'String', MolList(iMolSel).DeriList(iDeriSel).SumForm );
    set( handles.edSepForm, 'String', MolList(iMolSel).DeriList(iDeriSel).SepForm );
    
    set( handles.edC, 'String', MolList(iMolSel).DeriList(iDeriSel).nChain );
    set( handles.edMolSumForm, 'String', MolList(iMolSel).SumForm );
    set( handles.dm0, 'String', num2str( MolList(iMolSel).DeriList(iDeriSel).m0 ) );
    set( handles.edIsoBack, 'String', num2str( MolList(iMolSel).DeriList(iDeriSel).nBack ) );
    set( handles.edIsoForw, 'String', num2str( MolList(iMolSel).DeriList(iDeriSel).nForw ) );
end

edSumForm_Callback;

set( handles.ListCorr, 'Value', 0);
set( handles.ListCorr, 'Max', 0 );
set( handles.ListCorr, 'String', {} );
