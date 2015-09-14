function Y = calcMS( IDV, omega )

global MS_Measure

Y = [];

for group = 1:length( MS_Measure ),

    switch upper( MS_Measure{ group } )

        case 'F12 ',
%                    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
            MMMi = [ 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0; ...
                     0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0; ...
                     0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 ];
                     
        case 'F123',
            MMMi = [ 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                     0 0 1 1 1 1 0 0 1 1 0 0 0 0 0 0; ...
                     0 0 0 0 0 0 1 1 0 0 1 1 1 1 0 0; ...
                     0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 ];

        case 'F234',
            MMMi = [ 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0; ...
                     0 1 1 0 1 0 0 0 0 1 1 0 1 0 0 0; ...
                     0 0 0 1 0 1 1 0 0 0 0 1 0 1 1 0; ...
                     0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 ];

        case '1234',
            MMMi = [ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                     0 1 1 0 1 0 0 0 1 0 0 0 0 0 0 0; ...
                     0 0 0 1 0 1 1 0 0 1 1 0 1 0 0 0; ...
                     0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0; ...
                     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ];
    end

    Yi = omega(group) * MMMi * IDV;
    Y  = [ Y; Yi ];
    
end

return