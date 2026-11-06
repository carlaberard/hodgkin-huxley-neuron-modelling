function plot_input_responses(out, name)
% Plots one figure for one input:
%   left column : V(t), I_Na/I_K/I_L, I_L zoom
%   right column: m(t), h(t), n(t)

% Data
V   = out.V.get(1).Values;
IL  = out.IL.get(1).Values;
INa = out.INa.get(1).Values;
IK  = out.IK.get(1).Values;
m   = out.m.get(1).Values;
h   = out.h.get(1).Values;
n   = out.n.get(1).Values;

f = figure('Color','w','Name',name,'Units','pixels','Position',[100 100 1300 750]);
tl = tiledlayout(f, 3, 2, 'TileSpacing','compact','Padding','compact');
title(tl, name, 'FontWeight','bold');

% Tiles are numbered by row: left column = 1,3,5; right column = 2,4,6

% ---- Left column ----
a1 = nexttile(1);
plot(V.Time, V.Data, 'b', 'LineWidth', 1.5);
ylabel('V (mV)'); title('Potential V(t)'); grid on;

a2 = nexttile(3);
plot(INa.Time, INa.Data, 'r', 'LineWidth', 1.5); hold on;
plot(IK.Time,  IK.Data,  'm', 'LineWidth', 1.5);
plot(IL.Time,  IL.Data,  'g', 'LineWidth', 1.5); hold off;
ylabel('Intensitat'); title('Currents I_{Na}, I_K, I_L');
legend('I_{Na}','I_K','I_L','Location','best'); grid on;

a3 = nexttile(5);
plot(IL.Time, IL.Data, 'g', 'LineWidth', 1.5);
ylabel('I_L'); xlabel('Time (ms)'); title('Leak current I_L (zoom)'); grid on;

% ---- Right column ----
b1 = nexttile(2);
plot(m.Time, m.Data, 'k', 'LineWidth', 1.5);
ylabel('m'); title('Activation m(t)'); grid on;

b2 = nexttile(4);
plot(h.Time, h.Data, 'c', 'LineWidth', 1.5);
ylabel('h'); title('Inactivation h(t)'); grid on;

b3 = nexttile(6);
plot(n.Time, n.Data, 'r', 'LineWidth', 1.5);
ylabel('n'); xlabel('Time (ms)'); title('Activation n(t)'); grid on;

% Hide x tick labels except on the bottom row
a1.XTickLabel = []; a2.XTickLabel = [];
b1.XTickLabel = []; b2.XTickLabel = [];

% Zoom/pan all panels together
linkaxes([a1 a2 a3 b1 b2 b3], 'x');

drawnow;
end