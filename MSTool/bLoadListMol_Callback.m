function varagout = bLoadListMol_Callback

global MolList handles

[fname, pname] = uigetfile( '*.mat', 'Load Molecule List' );

if ~isempty( fname )
   
   load( [pname fname],'-mat' );
   
   name = {};
   
   for j=1:length(MolList(1).DeriList)
      name{j} = MolList(1).DeriList(j).Name;
   end
   
   set( handles.ListMol, 'String', name );
   set( handles.tFListMol, 'String', [pname fname] );
   
   ListMol_Callback;
   
end