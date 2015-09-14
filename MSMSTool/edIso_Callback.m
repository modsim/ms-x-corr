function varagout = edIso_Callback;

global MolList handles

iSel = get( handles.ListMol, 'Value' );
dSel = get( handles.ListDeri, 'Value' );

MolList(iSel).DeriList(dSel).nBack = str2num( get( handles.edIsoBack, 'String' ) );
MolList(iSel).DeriList(dSel).nForw = str2num( get( handles.edIsoForw, 'String' ) );

markMeas;