function [Meas] = funCorr( Molecule, Meas )

MMM = BuildMMM( Molecule );

dimMMM = size( MMM, 1 );

P1 = eye( dimMMM, Meas.nMP );
%display( size( P1 ) );

P2 = [ zeros( Meas.nShift(1), Meas.nIso ); eye( dimMMM - Meas.nShift(1), Meas.nIso ) ];
%display( size( P2 ) );

MMM = P1' * MMM * P2;

%MMM 	= MMM( 1:Meas.nMP, Meas.nShift(1)+1:Meas.nShift(1)+Meas.nIso )

if ( Meas.bEstNoise == 1 & Meas.nMP > Meas.nIso ),
   
   % can only be calculated for at least 2 dgF, else use BLUE
   
   % ---------------------------------------------------------------
   % Correction with estimation of Measurment Noise Mean & Deviation
   
   MMM  = [ones(Meas.nMP,1) MMM];
   cMMM = (MMM'*MMM)^(-1);
   
   kVec = cMMM * MMM' * Meas.Vec;
   
   estVec   = kVec(2:end);		% first estimate is measurement mean
   EstMean  = kVec(1);
   n = length( estVec );
   
   if Meas.bFrac == 1,
      one  = sum( estVec );
      for i = 1:n,
         Jac(i,:) = repmat( -estVec(i) / one, 1, n );
      end
      Jac = Jac + eye( n );
   else, 
      one = 1;
      Jac = eye( n );
   end
   
   outVec 	= [];
   modVec 	= MMM * kVec;
   diffVec 	= Meas.Vec - modVec;
   
   if Meas.nShift(1) > 0, 	outVec = diffVec( 1:Meas.nShift(1) );   end
   if Meas.nShift(2) > 0, 	outVec = [ outVec; diffVec( end-Meas.nShift(2)+1:end )];   end
   
   if length( outVec ) > 1,
      dN = std( outVec );
   else
      dN = Meas.DevNoise;
   end
   
   dev = diag( (Jac*dN^2*cMMM(2:end,2:end)*Jac').^.5, 0 );

   if 1-Meas.pOldBM < 1,   % correction for nonlabeled biomass
     q = Meas.pOldBM;
     n = length(estVec);
     z = MassDistr( n-1 );
    
     estVec = (estVec - q * one * z) ./ (1-pOldBM);

     if Meas.bFrac == 1,
       one = sum( estVec );
     end
          
   end
   
   Meas.one = one;
   Meas.EstDevNoise = dN;
   Meas.EstMeanNoise = EstMean;
   Meas.EstVec = estVec;
   Meas.EstDev = dev;
   Meas.ChiSq = sum( diffVec.^2 )/dN^2;
   Meas.dgF = length(Meas.Vec)-length(kVec);
   Meas.ModVec = modVec;
   Meas.bEstMeas = 1;
   
else
   % ---------------------------------------------------------------
   % BLUE estimation
   
   cMMM 	= (MMM'*MMM)^(-1);
   
   estVec    = cMMM * MMM' * Meas.Vec;
   
   if Meas.bFrac == 1,	
      one  = sum( estVec );
      n = length( estVec );
      for i = 1:n,
         Jac(i,:) = repmat( -estVec(i) / one, 1, n );
      end
      Jac = Jac + eye( n );
   else, 
      one = 1;
      Jac = eye( length( estVec ) );
   end
   
   modVec 	= MMM * estVec;
   diffVec 	= Meas.Vec - modVec;
   
   dev = diag( (Jac*Meas.DevNoise^2*cMMM*Jac').^.5, 0 );
    
   % correction for nonlabeled biomass
   if (1-Meas.pOldBM) < 1,   

     q = Meas.pOldBM;
     n = length(estVec);
     z = MassDistr( n-1 );
    
     estVec = (estVec - q * one * z) ./ (1-Meas.pOldBM);
     
     if Meas.bFrac == 1,
       one = sum( estVec );
     end
     
   end
   
   Meas.one = one;
   Meas.EstDevNoise = [];
   Meas.EstMeanNoise = [];

   Meas.EstVec = estVec;
   Meas.EstDev = dev;
   if Meas.DevNoise > 0,
     Meas.ChiSq = sum( diffVec.^2 )/Meas.DevNoise^2;
   else
     Meas.ChiSq = Inf;
   end
   
   Meas.dgF = length(Meas.Vec)-length(estVec);
   Meas.ModVec = modVec;
   Meas.bEstMeas = 0;
   
   end
   
function z = MassDistr( n )
  
  z = zeros( n+1, 1);
  
  for i = 0:n
    z(i+1) = factorial(n)/factorial(i)/factorial(n-i) * (1-0.011)^(n-i) * (0.011)^i;
  end
  
  return   
