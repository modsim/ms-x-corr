function varagout = edIso_Callback;

global MolList handles

iSel = get( handles.ListMol, 'Value' );

MolList(1).DeriList(iSel).nBack = str2num( get( handles.edIsoBack, 'String' ) );
MolList(1).DeriList(iSel).nForw = str2num( get( handles.edIsoForw, 'String' ) );