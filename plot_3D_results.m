function plot_3D_results()
% PLOT_3D_RESULTS
% Run the Simulink model first, then run:
%   plot_3D_results

required = {'Rt_log','Rm_log','Vt_log','Vm_log','Hit_log'};

for k = 1:numel(required)
    if ~evalin('base',sprintf('exist(''%s'',''var'')',required{k}))
        error(['Missing variable: ' required{k} ...
               '. Run the Simulink model first.']);
    end
end

RtData  = evalin('base','Rt_log');
RmData  = evalin('base','Rm_log');
VtData  = evalin('base','Vt_log');
VmData  = evalin('base','Vm_log');
HitData = evalin('base','Hit_log');

Rt = makeNby3(RtData.signals.values,'Rt_log');
Rm = makeNby3(RmData.signals.values,'Rm_log');
Vt = makeNby3(VtData.signals.values,'Vt_log');
Vm = makeNby3(VmData.signals.values,'Vm_log');

t = RtData.time(:);
hit = HitData.signals.values(:);

n = min([size(Rt,1),size(Rm,1),size(Vt,1),size(Vm,1),numel(t),numel(hit)]);

Rt = Rt(1:n,:);
Rm = Rm(1:n,:);
Vt = Vt(1:n,:);
Vm = Vm(1:n,:);
t = t(1:n);
hit = hit(1:n);

distance = sqrt(sum((Rt-Rm).^2,2));
[minDistance,idxClosest] = min(distance);

idxHit = find(hit >= 1,1,'first');

if ~isempty(idxHit)
    interceptionFound = true;
    interceptionTime = t(idxHit);
    interceptionPoint = Rm(idxHit,:);
else
    interceptionFound = false;
    interceptionTime = NaN;
    interceptionPoint = Rm(idxClosest,:);
end

% ================================================================
% 1. 3-D POSITION
% ================================================================
figure('Name','3-D Position - Target and Missile','NumberTitle','off');
plot3(Rt(:,1),Rt(:,2),Rt(:,3),'LineWidth',2);
hold on;
plot3(Rm(:,1),Rm(:,2),Rm(:,3),'LineWidth',2);
grid on;
axis equal;
xlabel('North Position (m)');
ylabel('East Position (m)');
zlabel('Down Position (m)');
title('3-D Position: Target vs Missile');
legend('Target','Missile','Location','best');
view(3);

% ================================================================
% 2. 3-D VELOCITY
% ================================================================
figure('Name','3-D Velocity - Target and Missile','NumberTitle','off');
plot3(Vt(:,1),Vt(:,2),Vt(:,3),'LineWidth',2);
hold on;
plot3(Vm(:,1),Vm(:,2),Vm(:,3),'LineWidth',2);
grid on;
xlabel('North Velocity (m/s)');
ylabel('East Velocity (m/s)');
zlabel('Down Velocity (m/s)');
title('3-D Velocity: Target vs Missile');
legend('Target','Missile','Location','best');
view(3);

% ================================================================
% 3. 3-D INTERCEPTION
% ================================================================
figure('Name','3-D Interception - Target and Missile','NumberTitle','off');
plot3(Rt(:,1),Rt(:,2),Rt(:,3),'LineWidth',2);
hold on;
plot3(Rm(:,1),Rm(:,2),Rm(:,3),'LineWidth',2);

if interceptionFound
    plot3(interceptionPoint(1),interceptionPoint(2),interceptionPoint(3),...
          'o','MarkerSize',10,'LineWidth',2);
    text(interceptionPoint(1),interceptionPoint(2),interceptionPoint(3),...
         sprintf('  INTERCEPTION (t = %.3f s)',interceptionTime));
    legend('Target','Missile','Interception Point','Location','best');
    title(sprintf('3-D Interception: t = %.3f s',interceptionTime));
else
    plot3(interceptionPoint(1),interceptionPoint(2),interceptionPoint(3),...
          'o','MarkerSize',10,'LineWidth',2);
    text(interceptionPoint(1),interceptionPoint(2),interceptionPoint(3),...
         sprintf('  Closest approach = %.3f m',minDistance));
    legend('Target','Missile','Closest Approach','Location','best');
    title(sprintf('3-D Interception: No Hit, Closest = %.3f m',minDistance));
end

grid on;
axis equal;
xlabel('North Position (m)');
ylabel('East Position (m)');
zlabel('Down Position (m)');
view(3);

% ================================================================
% RESULT IN COMMAND WINDOW
% ================================================================
fprintf('\n====================================================\n');

if interceptionFound
    fprintf('              INTERCEPTION DETECTED\n');
    fprintf('====================================================\n');
    fprintf('Interception time : %.3f s\n',interceptionTime);
    fprintf('North             : %.3f m\n',interceptionPoint(1));
    fprintf('East              : %.3f m\n',interceptionPoint(2));
    fprintf('Down              : %.3f m\n',interceptionPoint(3));
else
    fprintf('              NO INTERCEPTION DETECTED\n');
    fprintf('====================================================\n');
    fprintf('Closest distance  : %.3f m\n',minDistance);
    fprintf('Closest time      : %.3f s\n',t(idxClosest));
end

fprintf('====================================================\n\n');

end

function X = makeNby3(X,name)
X = squeeze(X);

if isvector(X)
    error('%s does not contain a 3-component vector.',name);
end

if size(X,2) == 3
    return;
elseif size(X,1) == 3
    X = X.';
else
    error('%s must contain exactly 3 components per sample.',name);
end
end
