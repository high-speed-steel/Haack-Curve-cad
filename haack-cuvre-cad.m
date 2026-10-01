%% Haack 曲線點位擷取
clear; clc;

% ==================== 參數輸入區 ====================

d = 140.0          % 外徑 (mm)
L = []             % 總長度 (mm)，若使用 r 設為 [] 或 NaN
r = []             % 長徑比 (L/d)，若使用 L 設為 [] 或 NaN

C = 1/3            % 0 = Von Kármán, 1/3 = LV-Haack
N = 150            % 取樣點數 [100-200]

% ===================================================

%  # Solidworks → 特徵 / 曲線 / 穿越XYZ曲線 → 瀏覽 → 選取txt檔 → 儲存
%  # 選取草圖平面 → 草圖 / 參考圖元 → 選擇曲線 → √

% ===================================================

if isempty(d) || isnan(d) || d <= 0
    error('參數錯誤');
end

has_L = ~isempty(L) && ~isnan(L);
has_r = ~isempty(r) && ~isnan(r);

if has_L && has_r
    error('參數衝突');
elseif ~has_L && ~has_r
    error('缺少參數');
end

R_base = d / 2.0;

if has_L
    if L <= 0
        error('數值錯誤');
    end
    r_val = L / d;
else
    if r <= 0
        error('數值錯誤');
    end
    L = r * d;
    r_val = r;
end

theta = linspace(0, pi, N);
x = (L / 2.0) * (1.0 - cos(theta));

radicand = max(theta - sin(2.0 * theta) / 2.0 + C * (sin(theta).^3), 0);
y = (R_base / sqrt(pi)) * sqrt(radicand);

x(1) = 0.0;   y(1) = 0.0;
x(end) = L;   y(end) = R_base;

points = [x(:), y(:), zeros(N, 1)]
writematrix(points, 'haack_points.txt', 'Delimiter', '\t');

fprintf('[計算成功]\n直徑 d = %.2f mm \n長度 L = %.2f mm \n長徑比 = %.2f \nShape Parameter = %.3f \n已匯出 %d 個點至 haack_points.txt\n', ...
    d, L, r_val, C, N);