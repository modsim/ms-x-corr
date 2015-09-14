function varagout = bRunCorrM_Callback

global handles MolList

fCorr = fopen( 'CorrData.txt', 'w' );
xlsfile = sprintf( 'MScorr_run_%g_%g_%g_%g_%g_%g.xls', clock );

for iSel=1:length(MolList.DeriList),
    
    set( handles.ListMol, 'Value', iSel );
    
    % loop if empty
    if isempty( MolList(1).DeriList( iSel ).MeasData )
        fprintf( 1, 'No data for %s\n', MolList.DeriList(iSel).Name );
        fprintf( fCorr, '\nNo data for %s\n\n', MolList.DeriList(iSel).Name );
        continue
    end
    
    fprintf( fCorr, 'Metabolite:\t%s\tStdDev:\t%g\tbias:\t%g\n', ...
            MolList(1).DeriList( iSel).Name, ...
            MolList(1).DeriList( iSel ).StdDev, ...
            MolList(1).DeriList( iSel ).Bias );
            
    % run for all samples

    % header
    fprintf( fCorr, '\tSample' ); 
    fprintf( fCorr, '\t+%d', 0:MolList(1).DeriList(iSel).iC );
    fprintf( fCorr, '\t' );
    fprintf( fCorr, '\tdev +%d', 0:MolList(1).DeriList(iSel).iC );
    fprintf( fCorr, '\n' );
    
    txt = { 'Sample' };
    
    for ii=0:MolList(1).DeriList(iSel).iC,
        txt{ii+2} = sprintf( 'm+%d', ii );
    end
    
    xlswrite( 'MScorr_export.xls', txt, MolList(1).DeriList( iSel).Name, 'A1' );

    txt = {};
    
    for sSel=1:size( MolList(1).DeriList(iSel).MeasData, 1)-1,
        
            % select measurements
            nMore = [0,0];
            if ~isempty( MolList( 1 ).DeriList(iSel).nBack ),   nMore(1) = MolList(1).DeriList(iSel).nBack; end
            if ~isempty( MolList( 1 ).DeriList(iSel).nForw ),   nMore(2) = MolList(1).DeriList(iSel).nForw; end

            tmp = MolList(1).DeriList(iSel).MeasData(1,:)';
            
            if isnan( any( tmp ) ),
                continue
            end

            Pos = find( tmp >= MolList(1).DeriList(iSel).m0 & tmp < MolList(1).DeriList(iSel).m0+1 );

            nIso = MolList( 1 ).DeriList( iSel ).iC + 1;
            nM 	= nIso + nMore(1) + nMore(2);
            MeasVec = [ MolList(1).DeriList(iSel).MeasData(      1, Pos-nMore(1):Pos+nIso+nMore(2)-1 )' ...
                        MolList(1).DeriList(iSel).MeasData(   sSel+1, Pos-nMore(1):Pos+nIso+nMore(2)-1 )' ];

            MeasVec = MeasVec(:,2) - repmat( MolList(1).DeriList(iSel).Bias, nM, 1 );

            Meas.nMP = nM;
            Meas.Vec = MeasVec;
            Meas.nShift = nMore;
            Meas.DevNoise = MolList.DeriList( iSel ).StdDev;
            Meas.MeanNoise = MolList.DeriList( iSel ).Bias;
            Meas.nIso = nIso;
            Meas.bFrac = 1;
        
            Meas = funCorr( MolList(1).DeriList(iSel), Meas, 1 );
        
            % write-out (normalized)
            c_mid = Meas.EstVec ./ Meas.one;
            c_mid_dev = Meas.EstVec ./ Meas.one;
        
            fprintf( fCorr, '\t%s', MolList(1).DeriList(iSel).Samples{sSel} ); 
            fprintf( fCorr, '\t%g', c_mid );
            fprintf( fCorr, '\t' );
            fprintf( fCorr, '\t%g', c_mid_dev );
            fprintf( fCorr, '\n' );
            
            txt{ sSel, 1 } = MolList(1).DeriList(iSel).Samples{sSel};
            
            c_mol_e = 0;
            
            for ii=1:length( c_mid );,
                txt{ sSel, 1+ii } = c_mid( ii );
                c_mol_e = c_mol_e + c_mid( ii ) * (ii-1);
            end
            
            txt{ sSel, 3+ii } = c_mol_e / (length( c_mid )-1);
    end
    
     xlswrite( xlsfile, txt, MolList(1).DeriList( iSel).Name, 'A2' );

     fprintf( fCorr, '\n' );

end

fclose( fCorr );
ListMol_Callback;