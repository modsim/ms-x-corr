% --------------------------------------------------------------------
function varargout = edSumForm_Callback

global MolList handles AtomList

iSel = get( handles.ListMol, 'Value' );
sSel = get( handles.ListSamples, 'Value' );

MolSumForm  = get( handles.edMolSumForm, 'String' );
DeriSumForm = get( handles.edSumForm, 'String' );
SepSumForm = get( handles.edSepForm, 'String' );

MolList(1).DeriList(iSel).MolSumForm = MolSumForm;

MolList(1).DeriList(iSel).SumForm = DeriSumForm;
MolList(1).DeriList(iSel).SepForm = SepSumForm;

% get Amount of Atoms in original chain:
nOriginal = parse( MolSumForm );

% get Amount of Atoms in derivated chain:
nDerivate = parse( DeriSumForm );

% get Amount of Atoms of seperated chain:
nSepChain = parse( SepSumForm );

% calculate Amount of Atoms for correction -> non-skelet atoms

for j=1:length(AtomList),
   Atom = AtomList(j).Symbol;
   
   nOrg = getfield( nOriginal, [ 'n' Atom ] );
   nDer = getfield( nDerivate, [ 'n' Atom ] );
   nSep = getfield( nSepChain, [ 'n' Atom ] );
   
   nCorr = nOrg-nSep + nDer;
   
   if Atom == 'C',
      nCorr = nDer;
      MolList(1).DeriList(iSel).iC = nOrg-nSep;
   end
   
   h1 = getfield( handles, ['n' Atom] );
   set( h1, 'String', num2str( nCorr ) );
   
   MolList(1).DeriList = setfield( MolList(1).DeriList, {iSel}, ['n' Atom], nCorr );

end

MW = nOriginal.MW - nSepChain.MW + nDerivate.MW;
   
MolList( 1 ).DeriList( iSel ).m0 = MW;

nIso = MolList(1).DeriList(iSel).iC;
set( handles.m0, 'String', num2str( MW ) );
