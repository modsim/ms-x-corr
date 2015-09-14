function loadMeasData( fName )

global MolList

%fName = 'measurements.xls';

if ~exist( fName, 'file' ),
  return
end

[pathstr, name, ext] = fileparts(fName);

%%
[num, header, raw] = xlsread( fName );

assignin( 'base', 'xls_num', num );
assignin( 'base', 'xls_header', header );
assignin( 'base', 'xls_raw', raw );
%%
for i=1:length( MolList(1).DeriList ),

    fprintf( '%s - looking for data\n', MolList(1).DeriList(i).Name );

	MolList(1).DeriList(i).MeasData = [];
    MolList(1).DeriList(i).Samples = {};
    MolList(1).DeriList(i).DataPath = '';
    MolList(1).DeriList(i).DataFile = '';
    
    nn = strcmp( header(1,:), MolList(1).DeriList(i).Name );
    nn = find( nn );

    if ~isempty( nn ),
        fprintf( 'match %s - at pos %d ', header{1,nn}, nn  );
        
        % check for size
        
        tmp = strcmp( header(1,nn+1:end), '' );
        nn2 = find( tmp == 0, 1, 'first' );
        
        if isempty( nn2 ), % last entry?
        	nn2 = length( tmp );
        	fprintf( 1, '%d - last entry\n', nn2+nn );
        else
          nn2 = nn2 - 1;
        	fprintf( 1, '%d \n', nn2+nn );
		end        	
        
        % find what fragments are in the measurements - find the two numbers
        m = []; c=0;
        
        for ii=nn:nn2+nn,
            c = c+1;
        	frag = raw{2,ii};
%        	[a,e] = regexp( frag, '[0-9\.]*' );
            if isnumeric( frag ),
                m(c,1) = frag;
            else
                m(c,1) = str2double( frag );
            end
%    		  m(ii-nn+1,2) = str2double( frag( a(2):e(2) ) );
    	  end
    	
    	disp( m );
        
        % fill with resp. data:
        
        MolList(1).DeriList(i).MeasData(1,:) = m';
        for kk=1:size( raw, 1 )-2,
            MolList(1).DeriList(i).MeasData( 1+kk, : ) = cell2mat( raw(2+kk, nn:nn2+nn ) );
        end
        
        MolList(1).DeriList(i).Samples = { raw{3:end,1} };
        

    else
        MolList(1).DeriList(i).MeasData = [];
        MolList(1).DeriList(i).Samples = {};
    end

end