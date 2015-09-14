function varagout = bRunCorr_Callback

global handles MolList Meas

% tolerance for mass peak search:
mTOLERANCE = 0.3;

iMolSel = get( handles.ListMol, 'Value' );

if isempty( MolList( iMolSel ).DataFile ),
   return
end

mNoise = str2double( get( handles.edNoiseMean, 'String' ) );
dNoise = str2double( get( handles.edNoiseDev, 'String' ) );
pOldBio= str2double( get( handles.edOldBio, 'String') ) / 100;

if isempty( mNoise ),	mNoise = 0; end
if isempty( dNoise ),   dNoise = 1; end

mData = loadMeasData( [ MolList(iMolSel).DataPath MolList( iMolSel ).DataFile ] );

MolList(iMolSel).FragmentIon

if MolList(iMolSel).FragmentIon.nC == 0,
  
  % look if at least nIso mass areas are present
  % number of mass-isotopomers = nC + 1
  % area of all fragments is summed and stored in mVec

  m0 = MolList(iMolSel).MotherIon.m0;
  nIso  = MolList(iMolSel).MotherIon.nC + 1;
  mVec = [];
  
  for n = 0:nIso-1,

    ind = find( mData(:,1) >= m0+n - mTOLERANCE & mData(:,1) < m0 + n + mTOLERANCE); 

    if isempty( ind ),
      fprintf( 1, 'Mother-Ion (MW0 + %d) not found in measurement data!\n', n );
      set( handles.ListCorr, 'Value', 1);
      set( handles.ListCorr, 'String', { '!! Error:', sprintf( 'respective mass M+%d', n) , 'not found' } ); 
      set( handles.ListCorr, 'Max', 3 );
      return
    end    

    % join all fragment measurements to mVec
    mVec = [ mVec; sum( mData( ind, 3 ) ) ];
  end

  fprintf( 1, 'Measurements for masses MW+0 to MW+%d found\n', nIso-1 );
  
  % look for lighter isotopes:
  nBack = 0; mBack = [];
  ind = find( mData(:,1) >= m0 - (nBack+1) - mTOLERANCE & mData(:,1) < m0 - (nBack+1) + mTOLERANCE);
  
  while ~isempty( ind ),
    mBack = [ mBack; sum( mData( ind, 3 ) ) ];
    nBack = nBack + 1;    
    ind = find( mData(:,1) >= m0 - (nBack+1) - mTOLERANCE & mData(:,1) < m0 - (nBack+1) + mTOLERANCE);

  end
  
  % look for heavier isotopes:
  nForw = 0; mForw = [];
  ind = find( mData(:,1) >= m0 + nIso-1 + (nForw+1) - mTOLERANCE & mData(:,1) < m0 + nIso-1 + (nForw+1) + mTOLERANCE );
  
  while ~isempty( ind ),
    mForw = [ mForw; sum( mData( ind, 3 ) ) ];
    nForw = nForw + 1;
    ind = find( mData(:,1) >= m0 + nIso-1 + (nForw+1) - mTOLERANCE & mData(:,1) < m0 + nIso-1 + (nForw+1) + mTOLERANCE );
  end
  
  fprintf( 1, 'Additional measurements back: %d\n', nBack );
  fprintf( 1, 'Additional measurements forw: %d\n', nForw );
  
  nM 	= nIso+nBack+nForw;
  
  MeasVec = [ mBack; mVec; mForw ];

  if any( diff( MeasVec( :, 1 ) ) > 1-mTOLERANCE & diff( MeasVec( :, 1 ) ) < 1+mTOLERANCE ),
    set( handles.ListCorr, 'Value', 1);
    set( handles.ListCorr, 'String', { '!! Error:', 'mass vector', 'not continous' } ); 
    set( handles.ListCorr, 'Max', 3 );
    return
  end

% $$$   display( MeasVec  );
  
  MeasVec = MeasVec - repmat( mNoise, nM, 1 );

  bFrac = get( handles.cbFracVal, 'Value' );

  Meas.nMP = nM;
  Meas.Vec = MeasVec;
  Meas.nShift = [ nBack nForw ];
  Meas.DevNoise = dNoise;
  Meas.MeanNoise = mNoise;
  Meas.nIso = nIso;
  Meas.bFrac = bFrac;
  Meas.bEstNoise = get( handles.cbAutoStat, 'Value' ) == 1;
  Meas.pOldBM = pOldBio;

  Mol = MolList(iMolSel).MotherIon;
  Mol.nC = 0; % C-Atoms are all from skeleton - do not correct for nat. isotopes of these C-atoms
  
  Meas = funCorr( Mol, Meas );
  

  
% ----------------------------------------------------------
% Measurement of a fragment containing C-atoms from skeleton
%
% Tandem Mass:
% Q1 --> Q2 ---> Q3
%
% Q1 to select a Mother Ion mass m0 + x1
% Q2 to fragment Mother Ion of mass m0 + x1 into f0 and f1
% Q3 to measure fragment f0( m0+x1 ) + xf0 
% 
% Method:
%
% try to reconstruct xMI by xU and xV:
%
% G_MI * x_MI = G_U * xU + G_V * xV

else
  
  % build matrix to estimate G_U * xU
  
  % measurements of V are sorted:
  % MI+0: --> V0,0
  % MI+1: --> V1,0 V1,1
  % MI+2: --> V2,0 V2,1 V2,2
  % MI+3: --> V3,0 V3,1 V3,2 V3,3
  
  % mVec = [ V0,0;
  %          V1,0;
  %          V1,1;
  %          V2,0;  
  %          V2,1;  
  %          V2,2;  
  %          ...
  
  % build mVec:
  
  % look if at least nIso mass areas are present
  % number of mass-isotopomers = nC + 1
  % area of all fragments is summed and stored in mVec

  MI_m0 = MolList(iMolSel).MotherIon.m0;
  MI_nIso  = MolList(iMolSel).MotherIon.nC + 1;

  FI_m0 = MolList(iMolSel).FragmentIon.m0;
  FI_nIso = MolList(iMolSel).FragmentIon.nC + 1;
  
  mVec = [];
  nFrags = [];
  
  % look for lighter isotopes:
  nBack = 0; mBack = [];
  ind = find( mData(:,1) >= MI_m0 - (nBack+1) - mTOLERANCE & mData(:,1) < MI_m0 - (nBack+1) + mTOLERANCE);

  while ~isempty( ind ),
    nBack = nBack + 1;    
    ind = find( mData(:,1) >= MI_m0 - (nBack+1) - mTOLERANCE & mData(:,1) < MI_m0 - (nBack+1) + mTOLERANCE);
  end
  
  % look for heavier isotopes:
  nForw = 0; mForw = [];
  ind = find( mData(:,1) >= MI_m0 + MI_nIso-1 + (nForw+1) - mTOLERANCE & mData(:,1) < MI_m0 + MI_nIso-1 + (nForw+1) + mTOLERANCE );
  
  while ~isempty( ind ),
    nForw = nForw + 1;
    ind = find( mData(:,1) >= MI_m0 + MI_nIso-1 + (nForw+1) - mTOLERANCE & mData(:,1) < MI_m0 + MI_nIso-1 + (nForw+1) + mTOLERANCE );
  end

  fprintf( 1, 'Additional measurements back: %d\n', nBack );
  fprintf( 1, 'Additional measurements forw: %d\n', nForw );

  nBack = 0;
  
  mU_max = 0;
  mV_max = 0;
  y_sum_yV  = [];
  
  for MI_n = -nBack : MI_nIso+nForw-1,

    ind = find( mData(:,1) >= MI_m0+MI_n - mTOLERANCE & mData(:,1) < MI_m0 + MI_n + mTOLERANCE); 

    if isempty( ind ),
      fprintf( 1, 'Mother-Ion (MW0 + %d) not found in measurement data!\n', MI_n );
      set( handles.ListCorr, 'Value', 1);
      set( handles.ListCorr, 'String', { '!! Error:', sprintf( 'respective mass M+%d', MI_n) , 'not found' } ); 
      set( handles.ListCorr, 'Max', 3 );
      return
    end    

    % join all fragment measurements to mVec
    for FI_n=0:length( ind ) - 1,
      mVec = [ mVec; mData( ind(FI_n+1), 3 ) ];
      
      % determine which fragments where measured
      % Mass of measured fragment:
      mIon = mData( ind(FI_n+1), 2 );
      
      y( MI_n+1 ).yV( FI_n+1 ).m = round( mIon - FI_m0 );
      y( MI_n+1 ).yV( FI_n+1 ).Area = mData( ind(FI_n+1), 3 );
    
      mV_max = max( y( MI_n+1 ).yV( FI_n+1 ).m, mV_max );
      mU_max = max( round( MI_n - y( MI_n+1 ).yV( FI_n+1 ).m ), mU_max );      
      
      fprintf( 1, 'For MI+%d, Fragment V+%d = %10f \n', MI_n, y( MI_n+1 ).yV( FI_n+1 ).m, y( MI_n+1 ).yV( FI_n+1 ).Area );
    end
    
    y_sum_yV = [ y_sum_yV; sum( mData( ind, 3 ) ) ];
    
    fprintf( 1, 'For MI+%d found %d fragment measurements\n\n', MI_n, length( ind ) );
    nFrags = [ nFrags; length( ind ) ];   
    
    
  end

  % Matrix construction:
  % y0 = v0,0 * u0
  % y1 = v1,1 * u0 + v1,0 * u1
  % y2 = v2,2 * u0 + v2,1 * u1 + v2,0 * u2
  % y3 = v3,3 * u0 + v3,2 * u1 + v3,1 * u2 + v3,0 * u3
  % a.s.o
  
  % size of vN is given in nFrags
  
  mVec0 = mVec;
  
  if nBack > 0,
    nFragsBack = sum( nFrags( 1:nBack ) );
    mVec0 = mVec( nFragsBack+1:end );
  end
  
  fprintf( 1, '\nFragment U (not-measured) max. mass M+%d\n', mU_max );
  fprintf( 1, '\nFragment V (measured) max. mass M+%d\n', mV_max );
  
  mY_max = (MI_nIso-1) + nForw;

  yV = zeros( sum( nFrags ), mU_max + 1 );
  yY = zeros( sum( nFrags ), mY_max + 1 );
  
  yV_sum = zeros( mV_max );
  
  b = 1;
  
  % for all mother-ions x+0 .. x+n,
  for n_MI = 1:mY_max+1,

    % for all measured fragments v+0 .. v+k
    for n_FI = 1:nFrags( n_MI ),

      n_FIV = y(n_MI).yV(n_FI).m;
      n_FIU = (n_MI-1) - n_FIV;
      
      yV_sum( n_FIV+1 ) = yV_sum( n_FIV+1 ) + y(n_MI).yV(n_FI).Area;
      
%      fprintf( 1, 'yV( %d, %d ) = -1 \n', b, n_FIU );

      if n_FIU >= 0,
        yV( b, n_FIU+1 ) = -1; % write -1 for substraction of nonmeasured fragment U (mass MI+n_MI-(V+nFIV) ) 
      end
      
%      frpintf( 1, 'yY(%d, %d) = 1\n', b, n_MI );
   
      yY( b, n_MI ) = 1;
      
      b = b + 1;
    end
  end
  
  display( yV );
  display( yY );
  
  yYV = [ yY yV ];
  
  % start optimization with starting values for x, u, v
  % 
  % assume y ~ sum( yV )
  % do correction for nat. isotopes
  
  nY = length( y );
  MMM = BuildMMM( MolList( iMolSel ). MotherIon );
  
  Meas.nMP = nY;
  Meas.Vec = y_sum_yV;
  
  Meas.nShift = [ nBack nForw ];
  Meas.DevNoise = 1;
  Meas.MeanNoise = 0;
  Meas.nIso = MI_nIso;
  Meas.bFrac = 1;
  Meas.bEstNoise = 0;
  Meas.pOldBM = 0;

  Mol = MolList(iMolSel).MotherIon;
  Mol.nC = 0; % C-Atoms are all from skeleton - do not correct for nat. isotopes of these C-atoms
  
  Meas = funCorr( Mol, Meas );
  
  xhat = Meas.EstVec ./ Meas.one;
  
  fprintf( 'Hat for x+%d = %g\n', [0:MI_nIso-1]', xhat );
    
  % 
  % assume v ~ sum( yV_n )
  % do correction for nat. isotopes
  
  nY = length( yV_sum );
  MMM = BuildMMM( MolList( iMolSel ).FragmentIon );
  
  Meas.nMP = nY;
  Meas.Vec = yV_sum;
  
  Meas.nShift = [ 0 nY - FI_nIso ];
  Meas.DevNoise = 1;
  Meas.MeanNoise = 0;
  Meas.nIso = FI_nIso;
  Meas.bFrac = 1;
  Meas.bEstNoise = 0;
  Meas.pOldBM = 0;

  Mol = MolList(iMolSel).FragmentIon;
  Mol.nC = 0; % C-Atoms are all from skeleton - do not correct for nat. isotopes of these C-atoms
  
  Meas = funCorr( Mol, Meas );
  
  vhat = Meas.EstVec ./ Meas.one;

  fprintf( 'Hat for v+%d = %g\n', [0:MI_nIso-1]', vhat );  
  
end  
  
  
  

if bFrac == 1, 
  format = 'm+%g: %6.4f ±%5.4f';
else
  format = 'm+%g: %8.0f ±%5.4f';
end

for k=1:nIso
   cCorr{k} = sprintf( format, k-1, Meas.EstVec(k)/Meas.one, Meas.EstDev(k)/Meas.one );
end

cCorr{end+1} = '';

if Meas.bEstMeas == 1,   
   cCorr{end+1} = '------------------';
   cCorr{end+1} = sprintf( 'N. mean= %9.2f', Meas.EstMeanNoise );
   cCorr{end+1} = sprintf( 'N. dev.= %9.2f', Meas.EstDevNoise );
end

load( ['chi2mat.mat'], '-mat' );

cCorr{end+1} = '------------------';
cCorr{end+1} = sprintf( 'Chi-Sq= %10.4f', Meas.ChiSq );
cCorr{end+1} = sprintf( 'Chi-Sq (%g,%g dgF)', 0.9, Meas.dgF );
cCorr{end+1} = sprintf( ' = %10.5f', chi2mat( Meas.dgF+1, 1 ) );

set( handles.ListCorr, 'Value', 1);
set( handles.ListCorr, 'String', cCorr );
set( handles.ListCorr, 'Max', length(cCorr) );   

return
