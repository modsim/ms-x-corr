function varagout = bNatDist_Callback

global handles MolList Meas AtomList

iMolSel = get( handles.ListMol, 'Value' );

if isempty( MolList( iMolSel ).DataFile ),
   return
end

MotherIon = MolList(iMolSel).MotherIon;
FragmentIonV = MolList(iMolSel).FragmentIon;
mData = [ MolList(iMolSel).MeasMass, MolList(iMolSel).MeasData(1,:)' ];

% calculate non-measured fragment:
FragmentIonU = [];
for j = 1:length( AtomList )
   cAt  = getfield( AtomList(j), 'Symbol' );
   mAt  = getfield( AtomList(j), 'Mass' );
   nAt_W = getfield( MotherIon, ['n' cAt ] );
   nAt_V = getfield( FragmentIonV, ['n' cAt ] );
   FragmentIonU = setfield( FragmentIonU, ['n' cAt ], nAt_W-nAt_V );
end

FragmentIonU.iC = setdiff( MotherIon.iC, FragmentIonV.iC );
FragmentIonU.nC = FragmentIonU.nC - length( FragmentIonU.iC ) ;
FragmentIonV.nC = FragmentIonV.nC - length( FragmentIonV.iC ) ;

% do not correct for C-Atoms of chain
[yTM_Ind, lab ] = gen_yTM( MotherIon, FragmentIonV );

% add natural isotopes to all possible measurements yTM,
% first generate maximum size matrix including impossible combinations
% y_to_z_MM = Matrix that transforms from y(no nat. isotopes) to z (incl. nat. isotopes)
% z_Ind will be generated with -1 fill 
% look for measured y(i.j), generate Vector with index [i,j]
mTOLERANCE = 0.1;

ind_mz0 = 1;

fprintf( 1, 'Starting at mData(%d,:)\n', ind_mz0 );
z_mM = [ round( mData( :,1 ) - MotherIon.m0 ), round( mData( :,2 ) - FragmentIonV.m0 ) ];

fprintf( 1, 'Reading data:\n' );
for i=1:length( z_mM ),
  fprintf( 1, 'z%d,%d = %g\n', z_mM(i,:), mData( i, 3 ) );
end

 
% Natural isotope distribution for U (not measured fragment)
ni_V = Build_ni_vec( FragmentIonV );
maxIso_V = length( ni_V );
assignin( 'base', 'F_I_V', FragmentIonV )

% Distribution for U (not measured fragment)
ni_U = Build_ni_vec( FragmentIonU );
maxIso_U = length( ni_U );
assignin( 'base', 'F_I_U', FragmentIonU )


% length is depending on maximal occuring isotopes in V and U (U+V=W)
maxIso_W = maxIso_U + maxIso_V;

for i=1:size( yTM_Ind, 1 ),
  
  fprintf( 1, 'Natural Isotopes of y%d,%d (%s)\n', yTM_Ind(i,1), yTM_Ind(i,2), lab{i} );
  
  nQ1 = yTM_Ind( i, 1 ); % weigth of W (U+V)
  nQ3 = yTM_Ind( i, 2 ); % weigth of V
  
  for nV=0:maxIso_V-1,
    for nU=0:maxIso_U-1,
      
      z_mMi = find( z_mM(:,1) == nV+nU+nQ1 & z_mM(:,2) == nQ3 + nV );
      
      if ~isempty( z_mMi ),
        fprintf( 1, '   + V+%d, U+%d = z%d,%d is measured; probability = %g * %g = %g, (z_mM pos=%d)\n', ...
                 nV, nU, nQ1+nV+nU, nQ3+nV, ni_V(nV+1),  ni_U(nU+1), ni_V(nV+1) * ni_U(nU+1), z_mMi );
        
%        if  ni_V(nV+1) * ni_U(nU+1) > 1e-6,
          y_to_z_mM( z_mMi, i ) = ni_V(nV+1) * ni_U(nU+1);
%        end
        
      end
    end
  end
end

% calculate mass shift due to natural isotopes:
mMax = length( MotherIon.iC );
dMax = length( FragmentIonV.iC );

assignin( 'base', 'yTM_Ind', yTM_Ind )

    nc_M = mMax;            % total number of carbons in motherion
    nc_D = dMax;            % number of C in the daughterion 
    nc_L = mMax - dMax;     % neutral loss
    
    cl = AtomList(1).IsoTable(2,1); % carbon labeling: 0.0107 is naturally labeled. 
    mid_M = binopdf(0:nc_M, nc_M, cl);    %mass isotopomer distribution
    mid_D = binopdf(0:nc_D, nc_D, cl);    %mass isotopomer distribution
    mid_L = binopdf(0:nc_L, nc_L, cl);    %mass isotopomer distribution
    
for ii = 1:size( yTM_Ind(:,1), 1 );

    % probability for neutral loss & fragment ion == motherion
    % mass of neutral loss = yTM(x,1) - yTM( x,2 )
    
    MI_ni_dist(ii,1) = ( mid_L( yTM_Ind(ii,1)-yTM_Ind(ii,2) +1) * mid_D( yTM_Ind(ii,2)+1)  );
end

assignin( 'base', 'mid_L', mid_L )
assignin( 'base', 'mid_M', mid_M )
assignin( 'base', 'mid_D', mid_D )
assignin( 'base', 'y_to_z_mM', y_to_z_mM )
assignin( 'base', 'MI_ni_dist', MI_ni_dist )

y = y_to_z_mM * MI_ni_dist;

cCorr = { 'expected distribution (natural labeling)' };

for k=1:length( y_to_z_mM ),
   cCorr{end+1} = sprintf( 'z%d.%d = %10.4f', z_mM(k,1), z_mM(k,2), y(k) );
end

set( handles.ListCorr, 'Value', 1);
set( handles.ListCorr, 'String', cCorr );
set( handles.ListCorr, 'Max', length(cCorr) );   

disp( ['Natural labeling ' MolList(iMolSel).Name ] );
for ii=1:size( z_mM, 1 ),
    fprintf( '%d\t%d\t%8.6f\n', z_mM(ii,1)+MotherIon.m0, z_mM(ii,2)+FragmentIonV.m0, y(ii) );
end

for ii=0:mMax,
    MI_ni_dist(ii+1,1) = 0.01^(mMax-ii) * 0.99^(ii);
end
y = y_to_z_mM * MI_ni_dist;

disp( ['U-13C labeling shift ' MolList(iMolSel).Name ] );

for ii=1:size( z_mM, 1 ),
    fprintf( '%d\t%d\t%8.6f\n', z_mM(ii,1)+MotherIon.m0, z_mM(ii,2)+FragmentIonV.m0, y(ii) );
end

fprintf( 'dims: dim y_zmM = %dx%d, z_mM = %dx%d\n', size( y_to_z_mM ), size( z_mM ) );

 
return
