% --------------------------------------------------------------------
function count = parse( formula )

global AtomList

% Start parsing ( 'Ö'-Parser )

formula = [ formula 'Ö' ];
emptPos = findstr( formula, ' ' );	% Leerzeichen ersetzen

for i=1:length(emptPos),
   formula(emptPos(i))='Ö';
end

MW = 0;     % molar weight of molecule

count = struct( 'MW', 0, 'nC', 0, 'nH', 0, 'nP', 0, 'nN', 0, 'nS', 0, 'nO', 0, 'nSi', 0 );

for j=1:length(AtomList)
   parseAtoms{j} = AtomList(j).Symbol;
end

for p = 1:length(parseAtoms),
   
   Atom = parseAtoms{p};
   
   nAtom = 0;
   wAtom = AtomList(p).Mass;
   
   iPos = findstr( formula, Atom );
   
   if ~isempty( iPos ),
      
      cAt = length(Atom);
      iPos = iPos + repmat( cAt, 1, length( iPos ) );
      
      for j=1:length( iPos ),
         i = 0;
         if ~isletter( formula( iPos(j) ) ),
            while ~isempty( str2num( formula( iPos(j):iPos(j)+i ) ) ) & i + iPos(j) < length( formula ),
               i = i + 1;
            end
            nAtom = nAtom + str2num( formula( iPos(j):iPos(j)+i-1 ) );
            formula( iPos(j)-cAt:iPos(j)+i-1 ) = repmat( 'Ö', 1, i+cAt );
         else
            nAtom = nAtom + 1;
            formula( iPos(j)-cAt:iPos(j)-1 ) = repmat( 'Ö', 1, cAt );
         end
      end
   end
   
   count = setfield( count, ['n' Atom], nAtom );
   
   MW = MW + wAtom * nAtom;
   
end

count = setfield( count, 'MW', MW );