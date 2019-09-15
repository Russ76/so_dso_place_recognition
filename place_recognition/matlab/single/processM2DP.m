function [diff_m_ci, diff_m_c, diff_m_i] = processM2DP(hist, start_idx, end_idx, mask_width)
    hist = hist(4*start_idx+1:size(hist,1)-4*end_idx, :);
    hist_t = hist(:,1:size(hist,2)/2);
    hist_i = hist(:,size(hist,2)/2+1:end);

    diff_m_c = process(hist_t, mask_width);
    diff_m_i = process(hist_i, mask_width);

    % weight dist
    w_c = std2(diff_m_c);
    w_i = std2(diff_m_i);
    diff_m_ci = (normalize(diff_m_c,2)*w_c + normalize(diff_m_i,2)*w_i)/(w_c+w_i);
end

function [res, idx] = process(hist, mask_width)
    m = size(hist,1)/4;
    res_full = (2-hist*hist')/4;
    res = ones(m,m);
    idx = ones(m,m);
    for i=1:m
        for j=1:m
            if(abs(i-j)>mask_width)
                temp = res_full(4*i-3:4*i, 4*j-3:4*j);
                temp = temp(:);
                [res(i,j), idx(i,j)] = min(temp);
            end
        end
    end
end