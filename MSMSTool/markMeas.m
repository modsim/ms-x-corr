function varagout = markMeas

global handles MolList

iMeasList   = get( handles.ListMeas, 'Value' );
iMolSel     = get( handles.ListMol, 'Value' );

if ~isempty( iMeasList ),

    for j=1:size( MolList(iMolSel).MeasData, 2 );
        ListMeas_detail{j} = sprintf( '%4.1f>%4.1f: %10.1f', MolList(iMolSel).MeasMass(j,:), MolList(iMolSel).MeasData(iMeasList, j) );
    end
   
   set( handles.ListMeas_detail, 'String', ListMeas_detail );
    
   else
      set( handles.ListMeas, 'Value', [] );
   end
   
  
end
