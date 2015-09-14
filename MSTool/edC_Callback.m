function varagout = edC_Callback 

global MolList handles AtomList

iSel = get( handles.ListMol, 'Value' );

CChain = get( handles.edC, 'String' );

CPos = findstr( CChain, 'C' );	% Cs suchen
n = [];

for i=1:length(CPos)-1,
   n(i) = str2num( CChain( CPos(i)+1:CPos(i+1)-1 ) );
end

n = [ n, str2num( CChain( CPos(end)+1:end ) ) ];

MolList( 1 ).DeriList( iSel ).nChain  = n;
