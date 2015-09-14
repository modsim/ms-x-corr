
for i=1:20,
   chi2mat(i,1) = chi2inv(0.9,i-1);
end

for i=1:20,
   chi2mat(i,2) = chi2inv(0.95,i-1);
end

for i=1:20,
   chi2mat(i,3) = chi2inv(0.99,i-1);
end

save( 'chi2mat.mat', 'chi2mat', '-mat' );
