function loadMeasData_csv( fName )

global MolList

fMeasData = fopen( fName );

% Following format:
% 1. line headers for fragments (in correspondence to fragment-list)
% 2. line - measured masses
% 3-n data, seperated by ';'

if fMeasData == -1
    return
end

tmp = fgetl( fMeasData );

% get first line - determine number of columns, assume ';' as seperator
[m, e] = regexp( deblank( tmp ), ';', 'split' );

nf=1;
for i=1:length( m ),
    if ~isempty( m{i } ),
        frag(nf).Name = m{i};
        frag(nf).pos = i;
        nf = nf+1;
    end
end

frag(nf).pos = length( m );

fprintf( 1, 'found %d fragments\n', nf-1 );

% 2. line.. the masses
tmp = fgetl( fMeasData );
[m, e] = regexp( deblank( tmp ), ';', 'split' );

nMasses = [];

for i=2:length( m ),
    if ~isempty( m{ i } ),
        nMasses(1,i-1) = str2num( m{ i } );
    end
end

disp( nMasses );

% now data..
% first column .. sample name, thereafter data

l = 2;

while ~isempty( tmp )
    tmp = fgetl( fMeasData );

    if ~ischar( tmp ),
        break
    end
    
    [m, e] = regexp( deblank( tmp ), ';', 'split' );
    
    sSample{l-1} = m{1};

    assignin( 'base', 'm', m );
    for i=2:length( m ),
        if ~isempty( m{i} ),
            nMasses(l,i-1) = str2double( m{ i } );
        else
            nMasses(l,i-1) = NaN;
        end
    end
    l = l+1;
end

fclose( fMeasData );

% now place data into structure array:

for i=1:length( MolList(1).DeriList ),
    
    fprintf( '%s - looking for data\n', MolList(1).DeriList(i).Name );
    
    nn = strcmp( MolList(1).DeriList(i).Name, {frag.Name} );
    nn = find( nn );
    
    if ~isempty( nn ),
        fprintf( 'match %s - at pos %d - %d\n', frag(nn).Name, frag(nn).pos, frag(nn+1).pos );
        % fill with resp. data:
        MolList(1).DeriList(i).MeasData = nMasses( :, frag(nn).pos-1:frag(nn+1).pos-2 );
        MolList(1).DeriList(i).Samples = sSample;
        
        %MolList(1).DeriList(i).MeasData
    else
        MolList(1).DeriList(i).MeasData = [];
        MolList(1).DeriList(i).Samples = {};
    end
end