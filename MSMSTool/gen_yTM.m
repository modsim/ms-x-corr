function [yTM_Ind, label_yIso] = gen_yTM( Mol, fragV )

nC_Mol = length( Mol.iC );

% Generate Tandem Mass Distribution Vector yTM,
% first fill with -1, not used positions then can be recognized and removed later
yTM_Ind = -1 * ones( sum( sum( 1:nC_Mol+1 ) ), 2 );

% and Tandem Mass Mapping Matrix - TMMM
% first for all combinations, remove unused lines later (-1 in yTM_Ind)
TMMM = zeros( sum( sum( 1:nC_Mol+1 ) ), 2^nC_Mol );

for i=1:2^nC_Mol,
  
  % generate bitcode for whole molecule
  wbit = dec2bin( i-1, nC_Mol );
  
  nQ1 = length( find( wbit == '1' ) );
  nQ3 = length( find( wbit( fragV.iC ) == '1' ) );

  L = sum( sum( 1:nQ1 ) );
  TMMM( L+nQ3+1, i ) = 1;
  
  yTM_Ind( L+nQ3+1, : ) = [ nQ1, nQ3 ];
 
end

fprintf( 1, '\n' );
 
% remove impossible combinations:
% yTM_Ind then has -1, -1 
kill = find( yTM_Ind(:,1) == -1 );

% remove lines in yTM and resp. Measure Matrix
yTM_Ind( kill, : ) = [];
TMMM( kill, : ) = [];

% generate labeling for measurements
for i=1:size( TMMM, 1 ),
  fprintf( 1, 'y%d,%d = ', yTM_Ind( i, : ) );
  ind = find( TMMM(i,:) == 1 );
  tmp = [];
  for j=1:length(ind),
    if j<length(ind), a=' + '; else, a=''; end
    tmp = [ tmp sprintf( '#%s%s', dec2bin( ind(j)-1, nC_Mol ),a  ) ]; 
  end
  label_yIso{i,1} = tmp;
  fprintf( 1, '%s', tmp );
  fprintf( 1, '\n' );
end
