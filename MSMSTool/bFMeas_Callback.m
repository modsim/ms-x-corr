function varagout = bFMeas_Callback

global MolList handles

[fname, pname] = uigetfile( '*.txt', 'Load Measuredata from file' );

set( handles.edFMeas, 'String', [pname fname] );

edFMeas_Callback;