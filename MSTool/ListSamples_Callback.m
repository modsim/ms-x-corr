% --------------------------------------------------------------------
function varargout = ListSamples_Callback

global MolList handles

iSel = get( handles.ListMol, 'Value' );
iSmp = get( handles.ListSamples, 'Value' );

if ~isempty( MolList(1).DeriList(iSel).Samples ),

    if isempty( iSmp ),
        set( handles.ListSamples, 'Value', 1 );
        iSmp = 1;
    end
    
    for j=1:size( MolList(1).DeriList(iSel).MeasData, 2 ),
        ListMeas{j} = sprintf( '%5.2f:%11.1f', MolList(1).DeriList(iSel).MeasData(1,j), MolList(1).DeriList(iSel).MeasData(iSmp+1,j) );
    end
    
    set( handles.ListMeas, 'String', ListMeas );
    set( handles.ListMeas, 'Max', length( ListMeas ) );
    set( handles.ListMeas, 'Min', 1 );
    set( handles.ListMeas, 'Value', 1 );
    
else
    set( handles.ListMeas, 'String', {} );
    set( handles.ListMeas, 'Max', 1 );
    set( handles.ListMeas, 'Value', 0 );
end