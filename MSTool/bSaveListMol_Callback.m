function varagout = bSaveListMol_Callback

global MolList handles

[fname, pname] = uiputfile( '*.mat', 'Save Molecule List' );

if ~isempty( fname )
   save( [pname fname], 'MolList', '-mat' );
	set( handles.tFListMol, 'String', [pname fname] );
end