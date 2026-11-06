function plot_pathologies(results, names)
% Figures comparing the conditions stored in results{1..nC}.
% results{1} is the Normal condition.
nC = numel(results);
colors = lines(nC);

%% Figure 1: random input and V(t), one panel per condition
figure('Color','w','Units','pixels','Position',[100 50 1100 850]);
tl = tiledlayout(nC+1, 1, 'TileSpacing','compact','Padding','compact');
title(tl, 'Membrane potential in each condition (same random input)', 'FontWeight','bold');
ax = gobjects(1, nC+1);
ax(1) = nexttile;
I = results{1}.Iext.get(1).Values;
plot(I.Time, I.Data, 'Color', [0.85 0.33 0.10], 'LineWidth', 1.2);
ylabel('I_{ext} (\muA/cm^2)'); title('Random input'); grid on;
ax(1).XTickLabel = [];
for c = 1:nC
    ax(c+1) = nexttile;
    V = results{c}.V.get(1).Values;
    plot(V.Time, V.Data, 'Color', colors(c,:), 'LineWidth', 1.3);
    ylabel('V (mV)'); title(names{c}); grid on;
    if c < nC, ax(c+1).XTickLabel = []; end
end
xlabel('Time (ms)');
linkaxes(ax, 'x');
linkaxes(ax(2:end), 'y');          % same V scale to compare amplitudes
drawnow;

%% Figure 2: V(t) overlay
figure('Color','w','Units','pixels','Position',[100 100 1100 450]);
hold on;
for c = 1:nC
    V = results{c}.V.get(1).Values;
    plot(V.Time, V.Data, 'Color', colors(c,:), 'LineWidth', 1.2);
end
hold off; grid on;
xlabel('Time (ms)'); ylabel('V (mV)');
title('Overlay of conditions (same random I_{ext})');
legend(names, 'Location', 'eastoutside');
drawnow;

%% Figure 3: V(t), Normal vs each pathology (one panel per pathology)
figure('Color','w','Units','pixels','Position',[100 50 1100 850]);
tlV = tiledlayout(nC-1, 1, 'TileSpacing','compact','Padding','compact');
title(tlV, 'Membrane potential: Normal vs each condition', 'FontWeight','bold');
axV = gobjects(1, nC-1);
VN = results{1}.V.get(1).Values;                 % Normal
for c = 2:nC
    axV(c-1) = nexttile; hold on;
    VP = results{c}.V.get(1).Values;             % pathology
    plot(VN.Time, VN.Data, 'Color', colors(1,:), 'LineWidth', 1.2);
    plot(VP.Time, VP.Data, 'Color', colors(c,:), 'LineWidth', 1.2);
    hold off; grid on;
    ylabel('V (mV)');
    title([names{1} ' vs ' names{c}]);
    legend({names{1}, names{c}}, 'Location', 'eastoutside');
    if c < nC, axV(c-1).XTickLabel = []; end
end
xlabel(axV(end), 'Time (ms)');
linkaxes(axV, 'xy');               % same time window and V scale
drawnow;

%% Figures 4...: currents (left) and gating variables (right), Normal vs each pathology
sig  = {'INa','m'; 'IK','h'; 'IL','n'};
lab  = {'I_{Na}','m'; 'I_K','h'; 'I_L','n'};

for c = 2:nC
    figure('Color','w','Units','pixels','Position',[100 50 1300 850]);
    tl3 = tiledlayout(3, 2, 'TileSpacing','compact','Padding','compact');
    title(tl3, ['Currents and gating variables: ' names{1} ' vs ' names{c}], ...
        'FontWeight','bold');
    ax3 = gobjects(3, 2);
    for r = 1:3
        for k = 1:2
            ax3(r,k) = nexttile((r-1)*2 + k); hold on;

            xN = results{1}.(sig{r,k}).get(1).Values;   % Normal
            xP = results{c}.(sig{r,k}).get(1).Values;   % pathology
            plot(xN.Time, xN.Data, 'Color', colors(1,:), 'LineWidth', 1.2);
            plot(xP.Time, xP.Data, 'Color', colors(c,:), 'LineWidth', 1.2);

            hold off; grid on; ylabel(lab{r,k});
            if r < 3, ax3(r,k).XTickLabel = []; else, xlabel('Time (ms)'); end
        end
    end
    legend(ax3(1,1), {names{1}, names{c}}, 'Location', 'best');
    linkaxes(ax3(:), 'x');
    drawnow;
end
end