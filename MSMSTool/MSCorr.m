%     MSCorr - Tool to correct MS/MS measurement data for the influence of natural isotopes
%    Copyright (C) 2015  S.A. Wahl
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, version 3 of the License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

function MSCorr

global MolList AtomList ValPer eMolList


getMolList;


% Setzen der stabilen Isotopenwahrscheinlichkeitsmatrizen (ID)
getAtomList;

newMask;

function vargout = getMolList( vargin )

global MolList eMolList

eMolList = struct( 'Name', {''}, ...
                   'MotherIon', {''}, ...
                   'FragmentIon', {''}, ...
                   'DataFile', {''}, ...
                   'DataPath', {''}, ...
                   'Samples', {''}, ...
                   'MeasData', {''} );

eMolList(1).FragmentIon = struct( 'Name', {''}, ...
                                  'SepForm', {''}, ...
                                  'SumForm', {''}, ...
                                  'nChain', {''}, ...
                                  'm0', {''}, ...
                                  'iC', {''}, ...
                                  'nC', {''}, ...
                                  'nH', {''}, ...
                                  'nO', {''}, ...
                                  'nN', {''}, ...
                                  'nS', {''}, ...
                                  'nP', {''}, ...
                                  'nSi', {''} );

                           
eMolList(1).MotherIon = struct( 'SumForm', {''}, ...
                                'DerForm', {''}, ...
                                'm0', {''}, ...
                                'iC', {''}, ...
                                'nC', {''}, ...
                                'nH', {''}, ...
                                'nO', {''}, ...
                                'nN', {''}, ...
                                'nS', {''}, ...
                                'nP', {''}, ...
                                'nSi', {''} );


MolList = eMolList;

return
