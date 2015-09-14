function bFLoadMeas_Callback_xls

global handles

[fName, pName] = uigetfile( {'*.xls', 'xls data'; '*.xlsx', 'xlsx data'} );

loadMeasData_xls( [pName fName] );

MolList(1).DataFile = fName;
MolList(1).DataPath = pName;

ListSamples_Callback;
