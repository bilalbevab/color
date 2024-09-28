function [outliers, count] = find_outliers(sum_matrix, n_clusters)
    close all;
    [r,c] = size(sum_matrix);
    %Create a histogram of the sum_matrix's values
    sHist = sum_matrix(:);
    
    %I need to now apply Kmeans clustering onto the sum matrix
    labels = kmeans(sHist, n_clusters);

    %I now need to find the highest mean-valued cluster
    outliers = false(size(sum_matrix));
    
    mean_vals = arrayfun(@(i) mean(sHist(labels == i)), 1:n_clusters);
    [~, highest_cluster_idx] = max(mean_vals);
    
    % Find the indices of the outliers
    outlier_indices = find(labels == highest_cluster_idx);
    % n = length(outlier_indices);
    % perm = randperm(n);
    % outlier_indices = sort(outlier_indices(perm(1:20)));
    count = numel(outlier_indices);

    %I now need to get the indices of the outliers
    outliers = outliers(:);
    outliers(outlier_indices) = true;
    outliers = reshape(outliers, [r c]);

end
