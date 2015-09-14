function varagout = bFLoadMeas_Callback

global MolList handles

[fname, pname] = uigetfile( {'*.xls'; '*.xlsx' }, 'Load Measure Data from excel' );
set( handles.edPMeas, 'String', [ pname fname ] );

iMolSel = get( handles.ListMol, 'Value' );
MolList( iMolSel ).DataFile = fname;
MolList( iMolSel ).DataPath = pname;

if ~isempty( fname )
%    loadMeasData( [pname fname] );
    edFMeas_Callback;
end
