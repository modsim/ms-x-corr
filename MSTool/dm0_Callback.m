function varagout = dm0_Callback

global MolList handles

iSel = get( handles.ListMol, 'Value' );
dSel = get( handles.ListDeri, 'Value' );

MolList(iSel).DeriList(dSel).StM0 = str2num( get( handles.dm0, 'String' ) );

markMeas;