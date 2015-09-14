% --------------------------------------------------------------------
function varargout = edFragmentName_Callback

global MolList handles

iMolSel = get( handles.ListMol,  'Value' );
Name 	= get( handles.edFragmentName, 'String' );

MolList(iMolSel).FragmentIon.Name = Name;
