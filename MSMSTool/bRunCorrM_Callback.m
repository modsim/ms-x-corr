function varagout = bRunCorrM_Callback

global handles MolList

%% write results to excel file
xlsfile = sprintf( 'MScorr_run_%g_%g_%g_%g_%g_%g.xls', clock );

for iSel = 1:length( MolList ),
    
    set( handles.ListMol, 'Value', iSel );
    ListMol_Callback;
    
    fprintf( 1, 'Run on molecule: %s\n\n', MolList( iSel ).Name );
    
    
    if ~isempty( MolList(iSel).MeasData ),
        
        Meas = funCorr_TM( MolList(iSel) );
        
        txt = {};
        txt{1,1} = 'Sample';
        
        for ii=1:size( MolList(iSel).MeasMass, 1 ),
            txt{1,ii+1} = sprintf( '%d>%d', MolList(iSel).MeasMass(ii,1), MolList(iSel).MeasMass(ii,2) );
        end
        
        
        for sSel=1:length( Meas ),
            
            txt{ sSel+1, 1 } = MolList(iSel).Samples{sSel};
            
            c_mol_e = 0;
            
            for ii=1:length( Meas(sSel).EstVec ),
                txt{ sSel+1, 1+ii } = Meas(sSel).EstVec( ii );
            end
            
        end
        
        assignin( 'base', 'txt', txt );
        
        xlswrite( xlsfile, txt, MolList(iSel).Name );
    end
    
end

set( handles.ListCorr, 'String', {''} );
