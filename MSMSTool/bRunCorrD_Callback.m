function varagout = bRunCorrD_Callback( fCorr, fi, fLog )

global handles MolList

iSel  = get( handles.ListMol, 'Value' );
bFrac = get( handles.cbFracVal, 'Value' );
bStat = get( handles.cbIncStat, 'Value' );

% ----- read Meas.data
if isempty( MolList(iSel).DataFile ),% return if no file specified
   set( handles.ListCorr, 'String', {''} );
   return
end

mNoise = str2double( get( handles.edNoiseMean, 'String' ) );
dNoise = str2double( get( handles.edNoiseDev, 'String' ) );

pOldBio = str2double( get( handles.edOldBio, 'String') ) / 100;

% ----- Open Outputfile (depends on input arguments ----

if nargin == 0,% Call from Button "Run for all Fragments"
  
  fN = MolList(iSel).DataFile;
  [p,n,e,v] = fileparts( fN );
  pN = MolList(iSel).DataPath;
  ff = [pN n];
  
  [fname, pname, fi] = uiputfile( ...
    {'*.csv', 'Tab-seperated Text file'; ...
      '*.ftbl', '13CFLUX ftbl format' }, 'Save as', ff );

  [p,n,e,v] = fileparts( fname )
  ext = {'.csv', '.ftbl'};
  
  if isempty( e ), 
    fname = [ fname, ext{fi} ];
  end
  
  fCorr = fopen( [pname fname], 'w+' );
  fLog = fopen( [pname fname '.log'], 'w+' );
  
end

MeasList = loadMeasData( [ MolList(iSel).DataPath MolList(iSel).DataFile ] );

if isempty( MeasList ),
  fprintf( fLog, 'Erorr for molecule %s  Datafile: %s is not found!\n', ...
           MolList(iSel).Name, MolList(iSel).DataFile );
  return
end

switch fi
 case 1 %csv-format
  fprintf( fCorr, [ MolList(iSel).Name '  (' MolList(iSel).SumForm '):\n\n' ] );
  fprintf( fCorr, repmat( ' ', 10, 1 ) );
  fprintf( fCorr, '\tm+%2.0f      ', 0:MolList(iSel).DeriList(1).iC );

  if bStat == 1,
    fprintf( fCorr, '\t' );
    fprintf( fCorr, '\tDev(%2.0f)   ', 0:MolList(iSel).DeriList(1).iC );
    fprintf( fCorr, '\tChi-Square ' );
  end
  fprintf( fCorr, '\n' );
  
 case 2 % ftbl-format
  ii = find( MolList(iSel).Name == '[' | MolList(iSel).Name == ']' );
  if ~isempty( ii )
    MetName = MolList(iSel).Name( (ii(1)+1):(ii(2)-1) );
  else
    MetName = MolList(iSel).Name;
  end
      
  fprintf( fCorr, '\n\t%s\t', MetName );
  
end

i = parse( MolList(iSel).SumForm );
maxIso = i.nC + 1;

FirstDeri = 1;

for dSel=1:length(MolList(iSel).DeriList),
  
  set( handles.ListDeri, 'Value', dSel );
 
  ListDeri_Callback;
   
  nIso  = MolList(iSel).DeriList(dSel).iC + 1;
   nMore = [0,0];
   
   if ~isempty( MolList(iSel).DeriList(dSel).nBack ), nMore(1) = ...
         MolList(iSel).DeriList(dSel).nBack; end
   if ~isempty( MolList(iSel).DeriList(dSel).nForw ), nMore(2) = ...
         MolList(iSel).DeriList(dSel).nForw; end
   
   m0 	= MolList( iSel ).DeriList( dSel ).StM0;
   
   if isempty( m0 ),
      m0  = MolList(iSel).DeriList(dSel).m0;
   end
   
   Pos = find( MeasList(:,1) >= m0 & MeasList(:,1) < m0 + 1 );
   
   if isempty( Pos ), % entsprechende Massenspur vorhanden?
     set( handles.ListCorr, 'Value', 1);
     set( handles.ListCorr, 'String', { '!! Error:', 'respective mass', 'not found' } ); 
     set( handles.ListCorr, 'Max', 3 );
     fprintf( 1, ['!! respective mass not found for fragment: %s, %s ' ...
                  '!!\n'], MolList(iSel).Name, MolList(iSel).DeriList(dSel).Name ...
              );
     fprintf( fLog, 'Error at fragment: %s, %s: respective mass not found!\n', ...
              MolList(iSel).Name, MolList(iSel).DeriList(dSel).Name ); 
     continue
   end
      
   nM = nIso+nMore(1)+nMore(2);
   MeasVec = MeasList( Pos-nMore(1):Pos+nIso+nMore(2)-1, : );

   if any( diff( MeasVec( :, 1 ) ) ~= 1 ), % check if continous
       set( handles.ListCorr, 'Value', 1);
       set( handles.ListCorr, 'String', { '!! Error:', 'mass vector', 'not continous' } ); 
       set( handles.ListCorr, 'Max', 3 );
       cCorr = { {'!! Error:'}, {'mass vector'}, {'not continous'} };
       fprintf( 1, ['!! mass vector is not continous for fragment: %s, %s ' ...
                  '!!\n'], MolList(iSel).Name, MolList(iSel).DeriList(dSel).Name );
       fprintf( fLog, ['Error at fragment: %s, %s: mass vector is not ' ...
                       'continous!\n'], MolList(iSel).Name, ...
                MolList(iSel).DeriList(dSel).Name );
       continue
   end
        
   MeasVec = MeasVec(:,2) - repmat( mNoise, nM, 1 );
   
   Meas.nMP = nM;
   Meas.Vec = MeasVec;
   Meas.nShift = nMore;
   Meas.DevNoise = dNoise;
   Meas.MeanNoise = mNoise;
   Meas.nIso = nIso;
   Meas.bFrac = bFrac;
   Meas.bEstMeas = get( handles.cbAutoStat, 'Value' ) == 1;
   
   Meas = funCorr( MolList(iSel).DeriList(dSel), Meas, Meas.bEstMeas, 1-pOldBio );
   
   if bFrac == 1,
      format = '%10.8f';
      dformat = '%10.8f';
   else
      format = '%10.0f';
      dformat = '%10.2f';
   end
   
% Document Chi^2 - Testing:

   chi2comment = [];
 
   load( ['chi2mat.mat'], '-mat' );
   fprintf( fLog, '%s, %s: ', MolList(iSel).Name, ...
            MolList(iSel).DeriList(dSel).Name );
     
   if Meas.dgF > 0,
     
     fprintf( fLog, 'Chi-Sq=%g,', Meas.ChiSq );
     fprintf( fLog, 'Chi-Sq (%g,%g)= %g, ', 0.9, Meas.dgF,chi2mat( Meas.dgF+1, 1 )  );      
     
     if Meas.ChiSq < chi2mat( Meas.dgF+1, 1 ),
       fprintf( fLog, 'o.k.' );
       chi2comment = sprintf( 'Chi^2 (%5.2f<%5.2f), o.k.', Meas.ChiSq,chi2mat( Meas.dgF+1, 1 ) );
     else
       if Meas.ChiSq > chi2mat( Meas.dgF+1, 1 )*10,
         fprintf( fLog, 'possible inconsistency' );
         chi2comment = sprintf( ['!!!! Chi^2 warning (%5.2f>%5.2f), possibly ' ...
                             'inconsistent'], Meas.ChiSq,chi2mat(Meas.dgF+1, 1 ) ) ;
       else
         fprintf( fLog, 'possible inconsistency' );
         chi2comment = sprintf( ['! Chi^2 warning (%5.2f>%5.2f), possibly ' ...
                             'inconsistent'], Meas.ChiSq,chi2mat(Meas.dgF+1, 1 ) ) ;
       end
     end
    
   else
     fprintf( fLog, 'not checked, no additional measurements availible' );
     chi2comment = 'Not chi^2 tested';
   end
   
   if max( Meas.EstVec ) * 0.05 < max( Meas.EstDev );
     fprintf( 'warning: noisy measurement (>5%), ' );
     chi2comment = [chi2comment, ', noisy measurement (>5%)' ];
   end
   
   fprintf( fLog, '\n' );
   
   switch fi
    % csv-format
    case 1  
     fprintf( fCorr, '%10s:\t', MolList(iSel).DeriList(dSel).Name );
     fprintf( fCorr, [format '\t'], Meas.EstVec'*1/Meas.one );
     fprintf( fCorr, repmat( '          \t', 1, maxIso-nIso ) );
     fprintf( fCorr, '//%s\t', chi2comment );
  
     if bStat == 1,
       fprintf( fCorr, '\t' );
       fprintf( fCorr, [dformat '\t'], Meas.EstDev/Meas.one );
       fprintf( fCorr, repmat( '          \t', 1, maxIso-nIso ) );
       fprintf( fCorr, '%10.5f\t', Meas.ChiSq );
     end
   
     fprintf( fCorr, '\n' );

    % FTBL - format
     
    case 2

     if FirstDeri ~= 1,% not first entry?
       fprintf( fCorr, '\t\t' );     
     else
       FirstDeri = 0;
     end       
     
     fprintf( fCorr, '%s\t', MolList(iSel).DeriList(dSel).nChain );
     fprintf( fCorr, ['0\t' format '\t' dformat '\t // %s(%s), %s \n'], ...
              Meas.EstVec(1)*1/Meas.one, Meas.EstDev(1)/Meas.one, ...
              MetName, MolList(iSel).DeriList(dSel).Name, chi2comment );
     
     for m=2:nIso,
       fprintf( fCorr, ['\t\t\t%d\t' format '\t' dformat '\n'], ...
                m-1, Meas.EstVec(m)/Meas.one, Meas.EstDev(m)/Meas.one );
     end
     
   end

end
     
if nargin == 0,    
   fclose( fCorr ); 
   fclose( fLog );
end

return
