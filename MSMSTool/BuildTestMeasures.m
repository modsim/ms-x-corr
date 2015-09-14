function BuildTestMeasures

% x = mass distribution vector MotherIon
% e.g. succinate

% Succinate:
% $$$ Mol.nC = 0;
% $$$ Mol.nH = 5;
% $$$ Mol.nP = 0;
% $$$ Mol.nN = 0;
% $$$ Mol.nS = 0;
% $$$ Mol.nO = 4;
% $$$ Mol.nSi = 0;
% $$$ Mol.m0 = 117;

Mol.nC = 0;
Mol.nH = 0;
Mol.nP = 0;
Mol.nN = 0;
Mol.nS = 0;
Mol.nO = 0;
Mol.nSi = 0;
Mol.m0 = 117;

% Succinat-CO2
% $$$ fragV.m0 = 73;
% $$$ fragV.nC = 0;
% $$$ fragV.nH = 5;
% $$$ fragV.nO = 2;
% $$$ fragV.nN = 0;
% $$$ fragV.nS = 0;
% $$$ fragV.nP = 0;
% $$$ fragV.nSi = 0;

fragV.m0 = 73;
fragV.nC = 0;
fragV.nH = 0;
fragV.nO = 0;
fragV.nN = 0;
fragV.nS = 0;
fragV.nP = 0;
fragV.nSi = 0;

% CO2
fragU.m0 = 44;
% $$$ fragU.nC = 0;
% $$$ fragU.nH = 0;
% $$$ fragU.nO = 2;
% $$$ fragU.nN = 0;
% $$$ fragU.nS = 0;
% $$$ fragU.nP = 0;
% $$$ fragU.nSi = 0;
fragU.nC = 0;
fragU.nH = 0;
fragU.nO = 0;
fragU.nN = 0;
fragU.nS = 0;
fragU.nP = 0;
fragU.nSi = 0;

% 4 carbon atoms - 2^4 isotopes:
x = zeros( 2^4, 1 );
x(0+1) = 0.7;
x(1+1) = 0.1;  % #0001
x(2+1) = 0.1;  % #0010
x(4+1) = 0.1;  % #0100
x(8+1) = 0.0;  % #1000
x(15+1) = 0.0; % #1111

MMM =  [ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
         0 1 1 0 1 0 0 0 1 0 0 0 0 0 0 0; ...
         0 0 0 1 0 1 1 0 0 1 1 0 1 0 0 0; ...
         0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0; ...
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ];

mMI = MMM * x;

% Succinate - CO2
% assume, CO2 - split off at position 4

MMM_f123 = [ 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
             0 0 1 1 1 1 0 0 1 1 0 0 0 0 0 0; ...
             0 0 0 0 0 0 1 1 0 0 1 1 1 1 0 0; ...
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 ];

mV = MMM_f123 * x;

size( mV )

ISM = BuildMMM( fragV );
yV = ISM( 1:7, 1:4 ) * mV;

size( yV )

fprintf( 1, 'yV (M+%d) = %g\n', [ [0:6] ; yV' ] );

% ---------------------------------
% construct measurements:
% y - Virtual Vector going into Q1

ISM = BuildMMM( Mol );

% assume 2 additional measurements
yY = ISM( 1:7, 1:5 ) * mMI;

fprintf( 1, 'yMI (M+%d) = %g\n', [ [0:6]; yY' ] );


% Measurement for fragment U
% C4 - 1er bit gesetzt

MMM_f4 = [ 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0; ...
           0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 ];

ISM_U = BuildMMM( fragU );
ISM_U = ISM_U( 1:4, 1:2 );

yU = ISM_U * ( MMM_f4 * x );

fprintf( 1, 'yU (M+%d) = %g\n', [ [0:3] ; yU' ] );

% Wahrscheinlichkeit für ein fragment yV0,0:
% (V+0)*(+0) = (MI+0) & (U+0)*(+0) + (MI+0) * (V+0)*(+0)

% Wahrscheinlichkeit für ein fragment y+1, y+0
% (V+0)*(+0) = (MI+1) & ( (U+1)*(+0) + (U+0)*(+1) )

% Wahrscheinlichkeit für ein Fragment y+1, y+1:
% (V+0)*(+1) = (MI+1) & ( (U+0)*(+0) )

% Wahrscheinlichkeit für ein Fragment y+2, y+0
% (V+0)*(+0) = (MI+2) & ( (U+2)*(+0) + (U+1)*(+1) + (U+0)*(+2) )

% generate measurements:

vec_Y = []; b = 1;
maxMI = length( yY );

yF = zeros( sum(1:maxMI), length( yY ) );

fID = fopen( 'MS_MS_TestData.txt', 'w+' );
  
% for all mother-ions x+0 .. x+n,
for n_MI = 1:maxMI,

  % for all measured fragments v+0 .. v+k
  
  yU_sum = sum( yU( 1 : min( length( yU ), n_MI-1 ) ) );
  
  for n_FI = 1:n_MI,

      n_FIV = n_FI-1;
      n_FIU = (n_MI-1) - n_FIV;
        
      if n_FIU >= 0 & n_FIU < length( yU )-1,
        yF( b, n_MI ) = yU(n_FIU+1); % write probability of u+n_FIU
        
        fprintf( 1, 'yF( %d, %d ) = yU(%d)* yMI(%d) = ( %g / %g ) * %g = %g \n', n_MI-1, n_FIV, n_FIU, n_MI-1, yU(n_FIU+1), ...
                 yU_sum, yY(n_MI), yU(n_FIU+1)/yU_sum * yY(n_MI)  );
% $$$         fprintf( 1, 'yF( %d, %d ) = %g * %g = %g \n', n_MI-1, n_FIV, yF(n_FIV+1), ...
% $$$                  yU(n_FIU+1), yF(n_FIV+1)*yU(n_FIU+1) );

%        fprintf( fID, '%d/%d;%g\n', Mol.m0 + n_MI-1, fragV.m0 + n_FIV, yU(n_FIU+1)*yY(n_MI) ); 
      
      end
      
      b = b + 1;
    end
  end
  
  fclose( fID);

% $$$   display( yV );
% $$$   display( size( yV ) );
% $$$ 
% $$$    display( yV * yY );
% $$$    display( yV*yY ./ sum( yV*yY ) );

   
   % an other approach
   
   yM(1,1) = yV(1) - yV(1) * yU(2) - yV(1) * yU(3); % Q1+0, fragV +0 = U+0
   
   yM(2,1) = yV(1) - yV(1) * yU(1) - yV(1) * yU(3); % Q1 + 1, fragV+0 = U+1
   yM(2,2) = yV(2) - yV(2) * yU(2) - yV(2) * yU(3); % Q1 + 1, fragV+1 = U+0

   yM(3,1) = yV(1) - yV(3) * yU(1) - yV(3) * yU(2); % Q1 + 2, fragV+0 = U+2
   yM(3,2) = yV(2) - yV(3) * yU(1) - yV(3) * yU(3); % Q1 + 2, fragV+1 = U+1  
   yM(3,3) = yV(3) - yV(3) * yU(2) - yV(3) * yU(3); % Q1 + 2, fragV+2 = U+0    
   
   yM
   

  
