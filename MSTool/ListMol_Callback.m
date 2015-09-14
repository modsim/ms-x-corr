% --------------------------------------------------------------------
function varargout = ListMol_Callback

global MolList handles

iMolSel = get( handles.ListMol, 'Value' );

set( handles.edMolName, 'String', MolList(1).DeriList(iMolSel).Name );
set( handles.edMolSumForm, 'String', MolList(1).DeriList(iMolSel).MolSumForm );

if isempty( MolList(1).DeriList(iMolSel) ),
    set( handles.edSumForm, 'String', '' );
    set( handles.edSepForm, 'String', '' );
    set( handles.edC, 'String', '' );
    set( handles.edIsoBack, 'String', '' );
    set( handles.edIsoForw, 'String', '' );
    set( handles.edNoiseMean, 'String', '' );
    set( handles.edNoiseDev, 'String', '' )

else
    set( handles.edSumForm, 'String', MolList(1).DeriList(iMolSel).SumForm );
    set( handles.edSepForm, 'String', MolList(1).DeriList(iMolSel).SepForm );
    n = MolList(1).DeriList(iMolSel).nChain;
    c = [];
    for i=1:length(n)
       c = [ c, sprintf( 'C%g', n(i) ) ];
    end    
    set( handles.edC, 'String', c );
    set( handles.edMolSumForm, 'String', MolList(1).DeriList(iMolSel).MolSumForm );
    set( handles.edIsoBack, 'String', num2str( MolList(1).DeriList(iMolSel).nBack ) );
    set( handles.edIsoForw, 'String', num2str( MolList(1).DeriList(iMolSel).nForw ) );
    set( handles.ListSamples, 'String', MolList(1).DeriList(iMolSel).Samples );
    set( handles.ListMeas, 'Max', length(MolList(1).DeriList(iMolSel).Samples) );
    set( handles.edNoiseMean, 'String', sprintf( '%g', MolList(1).DeriList(iMolSel).Bias ) );
    set( handles.edNoiseDev, 'String', sprintf( '%g', MolList(1).DeriList(iMolSel).StdDev ) ) ;

    ListSamples_Callback;
end
    
edSumForm_Callback;
