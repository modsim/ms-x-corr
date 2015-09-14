function bSetPathGl_Callback( varagin )

global handles MolList

Path = get( handles.edPMeas, 'String' );

for i=1:length( MolList )
   MolList(i).DataPath = Path;
end

return
