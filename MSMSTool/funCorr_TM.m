function Meas = funCorr_TM( molecule )

global handles AtomList

% tolerance for mass peak search:
mTOLERANCE = 0.3;

if isempty( molecule.Samples ),
    Meas = [];
    return
end

mNoise = str2double( get( handles.edNoiseMean, 'String' ) );
dNoise = str2double( get( handles.edNoiseDev, 'String' ) );

if isempty( mNoise ),	mNoise = 0; end
if isempty( dNoise ),   dNoise = 1; end

% look for measured y(i.j), generate Vector with index [i,j]

%% look for m+0 in data:

ind_mz0 = find( molecule.MeasMass( :,1 ) > molecule.MotherIon.m0 - mTOLERANCE & molecule.MeasMass(:,1) < molecule.MotherIon.m0 + mTOLERANCE );
z_mM = [ round( molecule.MeasMass( :, 1 ) - molecule.MotherIon.m0 ), round( molecule.MeasMass( :, 2 ) - molecule.FragmentIon.m0 ) ];

% calculate non-measured fragment:
FragmentIonU = [];
for j = 1:length( AtomList )
    cAt  = getfield( AtomList(j), 'Symbol' );
    mAt  = getfield( AtomList(j), 'Mass' );
    nAt_W = getfield( molecule.MotherIon, ['n' cAt ] );
    nAt_V = getfield( molecule.FragmentIon, ['n' cAt ] );
    FragmentIonU = setfield( FragmentIonU, ['n' cAt ], nAt_W-nAt_V );
end

nC_molecule = length( molecule.MotherIon.iC );
FragmentIonU.iC = setdiff( molecule.MotherIon.iC, molecule.FragmentIon.iC );

% do not correct for C-Atoms of chain
[yTM_Ind, lab ] = gen_yTM( molecule.MotherIon, molecule.FragmentIon );

FragmentIon.nC = FragmentIonU.nC - length( FragmentIonU.iC ) ;
molecule.FragmentIon.nC = molecule.FragmentIon.nC - length( molecule.FragmentIon.iC ) ;

% add natural isotopes to all possible measurements yTM,
% first generate maximum size matrix including impossible combinations
% y_to_z_MM = Matrix that transforms from y(no nat. isotopes) to z (incl. nat. isotopes)
% z_Ind will be generated with -1 fill

% Natural isotope distribution for U (not measured fragment)

ni_V = Build_ni_vec( molecule.FragmentIon );
maxIso_V = length( ni_V );

% Distribution for U (not measured fragment)
FragmentIonU.nC = FragmentIonU.nC - length( FragmentIonU.iC );
ni_U = Build_ni_vec( FragmentIonU );
maxIso_U = length( ni_U );

% length is depending on maximal occuring isotopes in V and U (U+V=W)
maxIso_W = maxIso_U + maxIso_V;

y_to_z_mM = zeros( 1, 1 );

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
                
                %if  ni_V(nV+1) * ni_U(nU+1) > 1e-6,
                y_to_z_mM( z_mMi, i ) = ni_V(nV+1) * ni_U(nU+1);
                %end
                
            end
        end
    end
end

assignin( 'base', 'y_to_z_mM', y_to_z_mM );

% do correction (linear regression):
fprintf( 'dims: dim y_zmM = %dx%d, z_mM = %dx%d, cov z_mM = %dx%d\n', size( y_to_z_mM ), size( z_mM ), size( diag( dNoise^-2 * ones( size( z_mM, 1 ), 1 ), 0 ) ) );

if dNoise < 1e-4,
    dNoise = 1;
end

for dd=1:length( molecule.Samples ),
    
    if ~isnan( molecule.Samples{dd} ),
        
        mData = [molecule.MeasMass( :,1 ) molecule.MeasMass( :,2 ) molecule.MeasData( dd, : )'];
        
        fprintf( 1, 'Starting at mData(%d,:)\n', ind_mz0 );
        z_mM = [ round( mData( :,1 ) - molecule.MotherIon.m0 ), round( mData( :,2 ) - molecule.FragmentIon.m0 ) ];
        
        fprintf( 1, 'Reading data:\n' );
        
        for i=1:length( z_mM ),
            fprintf( 1, 'z%d,%d = %g\n', z_mM(i,:), mData( i, 3 ) );
        end
        
        y = y_to_z_mM \ mData(:,3);
        
        err = ( y_to_z_mM' * diag( dNoise^-2 * ones( size( z_mM, 1 ), 1 ), 0 ) * y_to_z_mM )^-1;
        derr = diag( err, 0 );
        
        % calculate mass daistribution vector MDV:
        [~, ~, im] = unique( yTM_Ind(:,1 ) );
        
        mdv = zeros( max(yTM_Ind(:,1))+1,1 );
        err_mdv = zeros( size( mdv ) );
        
        for i=min(yTM_Ind(:,1)):max(yTM_Ind(:,1)),
            
            h = find( yTM_Ind(:,1) == i );
            
            mdv(i+1,1) = sum( y( h ) );
            err_mdv(i+1,1) = sum( derr( h ) );
            
            fprintf( 1, 'm+%d = y%d,y%d', i+1, yTM_Ind(h(1),1),  yTM_Ind(h(1),2) );
            for j=2:length( h ),
                fprintf( 1, '+ y%d,%d ' , yTM_Ind(h(j),1),  yTM_Ind(h(j),2) );
            end
            fprintf( 1, '\n' );
        end
        
        % save results:
        Meas(dd).yTM = yTM_Ind;
        Meas(dd).FTBL_lab = lab;
        Meas(dd).EstVec = y ./ sum(y);
        Meas(dd).EstDev = derr.^0.5 ./ sum(y);
        
        Meas(dd).EstMDV = mdv ./ sum( mdv );
        Meas(dd).EstDevMDV = err_mdv.^0.5 ./ sum( mdv );
        
        % Chi^2
        Meas(dd).dgF = size( z_mM, 1 ) - size( y, 1);
        
        if Meas(dd).dgF > 1e6,
            z_hat = y_to_z_mM * y;
            fprintf( 1, 'sizes: dim( mData(:,3) ) = %dx%d, dim(z_hat) = %dx%d. dim(cov) = %dx%d\n', size( mData(:,3)), size( z_hat ), size( diag( dNoise^-2 * ones( size( z_mM, 1 ), 1 ), 0 ) ) );
            Meas(dd).ChiSq = ( mData(:,3) - z_hat )' * diag( dNoise^-2 * ones( size( z_mM, 1 ), 1 ), 0 ) * ( mData(:,3) - z_hat );
        else
            Meas(dd).ChiSq = NaN;
        end
        
        Meas(dd).one = 1;
        Meas(dd).EstMeanNoise = 0;
        Meas(dd).EstDevNoise  = 0;
        Meas(dd).bEstMeas = 0;
    else
        
        Meas(dd).one = 1;
        Meas(dd).EstMeanNoise = 0;
        Meas(dd).EstDevNoise  = 0;
        Meas(dd).bEstMeas = 0;
    end
end

return
