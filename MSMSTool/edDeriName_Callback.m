% --------------------------------------------------------------------
function varargout = edDeriName_Callback

global MolList handles

iMolSel = get( handles.ListMol,  'Value' );
Name 	= get( handles.edFragmentName, 'String' );

MolList(iMolSel).FragmentIon.SumForm = get( handles.edSumForm, 'String' );

edSumForm_Callback;
