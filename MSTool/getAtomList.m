function vargout = getAtomList( vargin )

global AtomList

AtomList = struct( 'Symbol', {}, 'Mass', {}, 'IsoTable', {} );

AtomList(1).Symbol = 'C';
AtomList(1).Mass = 12;
AtomList(1).IsoTable = [ 0.9893    0 ;
                         0.0107 0.9893 ];

AtomList(2).Symbol = 'O';
AtomList(2).Mass = 16;
AtomList(2).IsoTable = [.99757    0      0;
                        .00038 .99757    0;
                        .00205 .00038 .99757 ];

AtomList(3).Symbol = 'H';
AtomList(3).Mass = 1;
AtomList(3).IsoTable = [.999885     0;
                        .000115 .999885 ];
    
AtomList(4).Symbol = 'N';
AtomList(4).Mass = 14;
AtomList(4).IsoTable = [.99632    0;
                        .00368 .99632];

AtomList(5).Symbol = 'P';
AtomList(5).Mass = 31;
AtomList(5).IsoTable = [ 1 ];

AtomList(6).Symbol = 'Si';
AtomList(6).Mass = 28;
AtomList(6).IsoTable = [ .922297     0      0;
                         .046832 .922297    0;
                         .030872 .046832 .922297];

AtomList(7).Symbol = 'S';
AtomList(7).Mass = 32;
AtomList(7).IsoTable = [.9493    0    0     0    ;
                        .0076 .9493   0     0    ;
                        .0429 .0076 .9493   0    ;
                        .0002 .0429 .0076 .9493];

return
