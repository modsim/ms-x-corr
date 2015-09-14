function bFLoadMeas_Callback_csv

global handles

[fname, pname] = uigetfile( '*.csv', 'Load Measure Data' );

set( handles.edPMeas, 'String', pname );
set( handles.edFMeas, 'String', fname );

if ~isempty( fname )
   edFMeas_Callback;
end