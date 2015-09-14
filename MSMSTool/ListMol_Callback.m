% --------------------------------------------------------------------
function varargout = ListMol_Callback

global MolList handles

iMolSel = get( handles.ListMol, 'Value' );

cList = {};

set( handles.edMolName, 'String', MolList(iMolSel).Name );
set( handles.edMolSumForm, 'String', MolList(iMolSel).MotherIon.SumForm );
set( handles.edDerSumForm, 'String', MolList(iMolSel).MotherIon.DerForm );

set( handles.edSepForm, 'String', MolList(iMolSel).FragmentIon.SepForm );
%set( handles.edFragmentName, 'String', MolList(iMolSel).FragmentIon.Name );
set( handles.edC, 'String', [ '[' num2str( MolList(iMolSel).FragmentIon.iC ) ']' ] );

set( handles.edPMeas, 'String', [ MolList(iMolSel).DataPath MolList(iMolSel).DataFile ] );

ListMeas={};

for j=1:length( MolList(iMolSel).Samples )
    ListMeas{j} = sprintf( '%s', MolList(iMolSel).Samples{j} );
end

set( handles.ListMeas, 'String', ListMeas );
set( handles.ListMeas, 'Max', length( ListMeas ) );
set( handles.ListMeas, 'Min', 1 );
set( handles.ListMeas, 'Value', 1 );

ListMeas_detail={};

for j=1:size( MolList(iMolSel).MeasData, 2 );
    ListMeas_detail{j} = sprintf( '%4.1f>%4.1f: %10.1f', MolList(iMolSel).MeasMass(j,:), MolList(iMolSel).MeasData(1, j) );
end

set( handles.ListMeas_detail, 'String', ListMeas_detail );
set( handles.ListMeas_detail, 'Max', length( ListMeas_detail ) );
set( handles.ListMeas_detail, 'Min', 1 );
set( handles.ListMeas_detail, 'Value', 1 );

edSumForm_Callback;
