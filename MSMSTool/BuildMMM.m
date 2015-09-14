% -----------------------------------------------------------------
% Berechnung der Korrekturmatrix, MMM mit Fehlerabschaetzung

function MMM = BuildMMM( Molecule )

global AtomList

maxSize = 100;

% maximal auftretende Isotope:
%maxIso = Molecule.nC + 1;
maxIso = 10;

% Molekuelmasse
mass = 0;

for j = 1:length( AtomList )
   cAt  = getfield( AtomList(j), 'Symbol' );
   mAt  = getfield( AtomList(j), 'Mass' );
   nAt  = getfield( Molecule, ['n' cAt ] );
   nIso = size( getfield( AtomList(j), 'IsoTable' ), 1 ) - 1;
   
   maxIso = maxIso + nIso * nAt;
   mass   = mass + mAt * nAt;
end

% Calculate Mass Mapping Matrix     

maxIso = min( maxIso, maxSize );
MMM = eye( maxIso, maxIso );

for j=1:length( AtomList ),
   
   cAt   = getfield( AtomList(j), 'Symbol' );         % chemical Symbol (as Char)
   nAt   = getfield( Molecule, ['n' cAt ] );          % Number of Atoms cAt in observed Molecuile
   IsoDM = getfield( AtomList(j), 'IsoTable' );       % get stable Isomere Distribution Matrix
   nIso  = size( IsoDM,1 );                           % Number of lines in IDM
   
   cMMM = zeros( maxIso, maxIso );
   cMMM = cMMM + diag( IsoDM(1,1) * ones( maxIso, 1 ), 0 );
   
   for n = 2 : nIso
      cMMM = cMMM + diag( IsoDM(n,1) * ones( maxIso-n+1, 1 ), -n+1 );
      cMMM = cMMM + diag( IsoDM(1,n) * ones( maxIso-n+1, 1 ), n-1 );
   end
   
   MMM = MMM * cMMM^nAt;
end

return
