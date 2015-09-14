% --------------------------------------------------------------------
function varargout = edSumForm_Callback

global MolList handles AtomList

iMolSel = get( handles.ListMol, 'Value' );

MolSumForm = get( handles.edMolSumForm, 'String' );
SepSumForm = get( handles.edSepForm, 'String' );
Frag_iC_Pos = get( handles.edC, 'String' );
DerSumForm = get( handles.edDerSumForm, 'String' );

MolList(iMolSel).MotherIon.SumForm = MolSumForm;
MolList(iMolSel).MotherIon.DerForm = DerSumForm;
MolList(iMolSel).FragmentIon.SepForm = SepSumForm;

% get amount of atoms in original chain:
nOriginal = parse( [ MolSumForm DerSumForm ] );

% get amount of atoms of seperated chain:
nSepChain = parse( SepSumForm );

for j=1:length(AtomList),
   Atom = AtomList(j).Symbol;
   
   nOrg = getfield( nOriginal, [ 'n' Atom ] );
   nSep = getfield( nSepChain, [ 'n' Atom ] );
   
   nFrag = nOrg-nSep;
   
   h1 = getfield( handles, ['n' Atom] );
   set( h1, 'String', num2str( nOrg ) );
   
   MolList(iMolSel).MotherIon = setfield( MolList(iMolSel).MotherIon, ['n' Atom], nOrg );
   MolList(iMolSel).FragmentIon = setfield( MolList(iMolSel).FragmentIon, ['n' Atom], nFrag );
end

% set arrays for C-Atom positions:

% get amount of atoms in molecule:
nSkelet = parse( MolSumForm );

MolList(iMolSel).MotherIon.iC = 1:nSkelet.nC;

if ~isempty( Frag_iC_Pos ),
  MolList(iMolSel).FragmentIon.iC = eval( Frag_iC_Pos );
else
  MolList(iMolSel).FragmentIon.iC = [];
end

% $$$ display( MolList(iMolSel).MotherIon );
% $$$ display( MolList(iMolSel).FragmentIon );

%set molecular weights
MolList( iMolSel ).MotherIon.m0 = nOriginal.MW;
MolList( iMolSel ).FragmentIon.m0 = nOriginal.MW - nSepChain.MW;

set( handles.m0, 'String', num2str( MolList( iMolSel ).MotherIon.m0 ) );
set( handles.m0f, 'String', num2str( MolList( iMolSel ).FragmentIon.m0 ) );
