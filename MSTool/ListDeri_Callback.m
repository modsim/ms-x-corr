% --------------------------------------------------------------------
function varargout = ListDeri_Callback

global MolList handles

iMolSel  = get( handles.ListMol, 'Value' );
iSmpSel = get( handles.ListSamples,'Value' );

if isempty( MolList(iMolSel).DeriList ),
    set( handles.edDeriName, 'String', '' );
    set( handles.edSumForm, 'String', '' );
    set( handles.edSepForm, 'String', '' );
    set( handles.edC, 'String', '' );
    set( handles.dm0, 'String', '' );
    set( handles.edIsoBack, 'String', '' );
    set( handles.edIsoForw, 'String', '' );
else
    set( handles.edDeriName, 'String', MolList(1).DeriList(iMolSel).Name );
    set( handles.edSumForm, 'String', MolList(1).DeriList(iMolSel).SumForm );
    set( handles.edSepForm, 'String', MolList(1).DeriList(iMolSel).SepForm );
    n = MolList(1).DeriList(iMolSel).nChain;
    c = [];
    for i=1:length(n)
       c = [ c, sprintf( 'C%g', n(i) ) ];
    end    
    set( handles.edC, 'String', c );
    set( handles.edMolSumForm, 'String', MolList(1).DeriList(iMolSel).SumForm );
    set( handles.dm0, 'String', num2str( MolList(1).DeriList(iMolSel).m0 ) );
    set( handles.edIsoBack, 'String', num2str( MolList(1).DeriList(iMolSel).nBack ) );
    set( handles.edIsoForw, 'String', num2str( MolList(1).DeriList(iMolSel).nForw ) );
end

edSumForm_Callback;

set( handles.ListCorr, 'Value', 0);
set( handles.ListCorr, 'Max', 0 );
set( handles.ListCorr, 'String', {} );