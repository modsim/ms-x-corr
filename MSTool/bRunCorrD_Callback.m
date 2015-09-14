function varagout = bRunCorrD_Callback( varagin )

global handles MolList

iSel  = get( handles.ListMol, 'Value' );

bFrac = get( handles.cbFracVal, 'Value' );
bStat = get( handles.cbIncStat, 'Value' );

if isempty( MolList(iSel).DataFile ),
   set( handles.ListCorr, 'String', {''} );
   return
end

mNoise = str2num( get( handles.edNoiseMean, 'String' ) );
dNoise = str2num( get( handles.edNoiseDev, 'String' ) );

fName = MolList(iSel).DataFile;
pName = MolList(iSel).DataPath;
fMeas = [pName fName];

MeasList = loadMeasData( fMeas );

if nargin == 0,
   i = findstr( '.', fMeas );
   if ~isempty(i)
      fMeas = fMeas( 1:i-1 );
   end
   fCorr = fopen( [fMeas '.cms'], 'w' );
else
   fCorr = varagin;
end

fprintf( fCorr, [ MolList(iSel).Name '  (' MolList(iSel).SumForm '):\n\n' ] );

fprintf( fCorr, repmat( ' ', 10, 1 ) );
fprintf( fCorr, '\tm+%2.0f      ', 0:MolList(iSel).DeriList(1).iC );

if bStat == 1,
   fprintf( fCorr, '\t' );
   fprintf( fCorr, '\tDev(%2.0f)   ', 0:MolList(iSel).DeriList(1).iC );
   fprintf( fCorr, '\tChi-Square ' );
end

fprintf( fCorr, '\n' );

i  		= parse( MolList(iSel).SumForm );
maxIso = i.nC + 1;


for dSel=1:length(MolList(iSel).DeriList),
   
   set( handles.ListDeri, 'Value', dSel );
   ListDeri_Callback;
   
   nIso  = MolList(iSel).DeriList(dSel).iC + 1;
   nMore = [0,0];
   
   if ~isempty( MolList(iSel).DeriList(dSel).nBack ),	nMore(1) = MolList(iSel).DeriList(dSel).nBack;   end
   if ~isempty( MolList(iSel).DeriList(dSel).nForw ), nMore(2) = MolList(iSel).DeriList(dSel).nForw;   end
   
   m0 	= MolList( iSel ).DeriList( dSel ).StM0;
   
   if isempty( m0 ),
      m0  = MolList(iSel).DeriList(dSel).m0;
   end
   
   Pos = find( MeasList(:,1) >= m0 & MeasList(:,1) < m0 + 1 );
   
   nM = nIso+nMore(1)+nMore(2);
   MeasVec = MeasList( Pos-nMore(1):Pos+nIso+nMore(2)-1, : );
   
   MeasVec = MeasVec(:,2) - repmat( mNoise, nM, 1 );
   
   Meas.nMP = nM;
   Meas.Vec = MeasVec;
   Meas.nShift = nMore;
   Meas.DevNoise = dNoise;
   Meas.MeanNoise = mNoise;
   Meas.nIso = nIso;
   Meas.bFrac = bFrac;
   Meas.bEstMeas = get( handles.cbAutoStat, 'Value' ) == 1;
   
   Meas = funCorr( MolList(iSel).DeriList(dSel), Meas, Meas.bEstMeas );
   
   if bFrac == 1,
      format = '%10.8f';
      dformat = '%10.8f';
   else
      format = '%10.0f';
      dformat = '%10.2f';
   end
   
   fprintf( fCorr, '%10s:\t', MolList(iSel).DeriList(dSel).Name );
   fprintf( fCorr, [format '\t'], Meas.EstVec'*1/Meas.one );
   fprintf( fCorr, repmat( '          \t', 1, maxIso-nIso ) );
   
   if bStat == 1,
      fprintf( fCorr, '\t' );
      fprintf( fCorr, [dformat '\t'], Meas.EstDev/Meas.one );
		fprintf( fCorr, repmat( '          \t', 1, maxIso-nIso ) );
      fprintf( fCorr, '%10.5f\t', Meas.ChiSq );
   end
   
   fprintf( fCorr, '\n' );
   
end

%end

fprintf( fCorr, '\n\n\n' );

if nargin == 0,    
   fclose( fCorr ); 
end

if bFrac == 1, 
   format = 'm%g: %6.4f ±%5.4f';
else
   format = 'm%g: %8.0f ±%5.4f';
end

for k=1:nIso
   cCorr{k} = sprintf( format, k-1, Meas.EstVec(k)/Meas.one, Meas.EstDev(k)/Meas.one );
end

cCorr{end+1} = '';

if Meas.bEstMeas,   
   cCorr{end+1} = '------------------';
   cCorr{end+1} = sprintf( 'N. mean= %9.2f', Meas.EstMeanNoise );
   cCorr{end+1} = sprintf( 'N. dev.= %9.2f', Meas.EstDevNoise );
end

cCorr{end+1} = '------------------';
cCorr{end+1} = sprintf( 'Chi-Sq= %10.4f', Meas.ChiSq );
cCorr{end+1} = sprintf( 'Chi-Sq (%g,%g dgF)', 0.9, Meas.dgF );
cCorr{end+1} = sprintf( ' = %10.5f', chi2inv(0.9, Meas.dgF) );

set( handles.ListCorr, 'Value', 1);
set( handles.ListCorr, 'String', cCorr );
set( handles.ListCorr, 'Max', length(cCorr) );