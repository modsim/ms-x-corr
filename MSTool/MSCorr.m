%    MSCorr - Tool to correct MS measurement data for the influence of natural isotopes
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

eMolList = struct( 'Name', {''}, 'DataFile', {''}, 'DataPath', {''} );

eMolList(1).DeriList = struct( 'MolSumForm', {''}, 'Name', {''}, 'SepForm', {''}, 'nChain', {''}, 'SumForm', {''}, 'm0', {''}, 'StM0', {''}, 'nBack',{''}, 'nForw',{''}, ...
   									'nC', {''}, 'nH', {''}, 'nO', {''}, 'nN', {''}, 'nS', {''}, 'nP', {''}, 'nSi', {''}, 'iC', {''}, 'MeasData', {''}, 'Bias', 0, 'StdDev', '', 'Samples', '' );
                           
MolList = eMolList;

return