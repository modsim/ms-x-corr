function bFLoadMeas_Callback_csv

global handles

[fName, pName] = uigetfile( '*.csv', 'Load Measure Data' );

loadMeasData_csv( [pName fName] );

MolList(1).DataFile = fName;
MolList(1).DataPath = pName;

ListSamples_Callback;
