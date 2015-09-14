% --------------------------------------------------------------------
function varargout = edFMeas_Callback

global MolList handles

fname = get( handles.edPMeas, 'String' );
loadMeasData( fname );

iMolSel = get( handles.ListMol, 'Value' );

if isempty( MolList(iMolSel).Samples ),
   set( handles.ListMeas, 'String', {} );
   set( handles.ListMeas, 'Max', 1 );
   set( handles.ListMeas, 'Value', 0 );
%   set( handles.edFMeas, 'String', '' );
   set( handles.ListMeas_detail, 'String', '' );
   set( handles.ListMeas_detail, 'Max', 1 );
   set( handles.ListMeas_detail, 'Value', 0 );
   return
end

ListMeas={};

for j=1:length( MolList(iMolSel).Samples )
    ListMeas{j} = sprintf( '%s', MolList(iMolSel).Samples{j} );
end

set( handles.ListMeas, 'String', ListMeas );
set( handles.ListMeas, 'Max', length( ListMeas ) );
set( handles.ListMeas, 'Min', 1 );
set( handles.ListMeas, 'Value', 1 );

for j=1:size( MolList(iMolSel).MeasData, 2 );
    ListMeas_detail{j} = sprintf( '%4.1f>%4.1f: %10.1f', MolList(iMolSel).MeasMass(j,:), MolList(iMolSel).MeasData(1, j) );
end

set( handles.ListMeas_detail, 'String', ListMeas_detail );
set( handles.ListMeas_detail, 'Max', length( ListMeas_detail ) );
set( handles.ListMeas_detail, 'Min', 1 );
set( handles.ListMeas_detail, 'Value', 1 );
