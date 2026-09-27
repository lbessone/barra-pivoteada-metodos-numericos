%% =====================================================================
%  TRACKEO MANUAL DE LA BARRA CON TIMESTAMPS REALES (iPhone .MOV 240fps)
%  ---------------------------------------------------------------------
%  - Extrae el timestamp EXACTO de cada frame con ffprobe (no asume dt fijo),
%    porque el iPhone descarta frames al guardar el .MOV en cámara lenta.
%  - Permite marcar el PIVOTE una sola vez y el EXTREMO cuadro a cuadro.
%  - Calcula el ángulo respecto al piso igual que el pipeline de Python/MATLAB
%    previo (angv = atan2 trig, ang = 180 - angv, angrad = deg2rad(ang)).
%  - Exporta un .csv con columnas  t;x;y;angv;ang;angrad  y un respaldo .mat.
%
%  REQUISITOS:
%    * ffprobe accesible desde el sistema (viene con ffmpeg). Ver RUTA_FFPROBE.
%    * El .MOV en la carpeta de trabajo.
%
%  USO:
%    1) Ajustar videoFile y (si hace falta) RUTA_FFPROBE abajo.
%    2) Correr el script. Click en el pivote, luego un click por frame en el
%       extremo. Tecla S o barra espaciadora = saltar ese frame sin marcarlo.
%       Tecla Q o Esc (o cerrar la ventana) = terminar el marcado.
%       Enter sin click o cerrar la ventana = terminar antes.
%  =====================================================================

clear; clc; close all;

videoFile = 'IMG_7641.MOV';  % <-- tu video .MOV
[~, nombreBase, ~] = fileparts(videoFile);
videoFile_h264 = sprintf('%s_h264.mp4', nombreBase);
if exist(videoFile_h264, 'file') ~= 2
    cmd = sprintf('ffmpeg -y -i "%s" -c:v libx264 -preset veryfast -crf 12 -pix_fmt yuv420p -an "%s"', ...
                   videoFile, videoFile_h264);
    system(cmd);
end
videoFile = videoFile_h264;

% ------------------------- CONFIGURACIÓN -----------------------------
RUTA_FFPROBE  = 'ffprobe';        % si no está en el PATH, poné la ruta completa
                                  % p.ej. 'C:\ffmpeg\bin\ffprobe.exe'
recorte       = [];               % [] = todos los frames. O bien [ini fin]
                                  % (1-based, sobre el video ORIGINAL) para
                                  % procesar solo ese rango. Ver nota abajo.
paso_frames   = 1;                % 1 = todos los frames del rango.
                                  % 2 = uno de cada dos, 3 = uno de cada tres...
                                  % Útil si 240 fps es más resolución de la
                                  % necesaria; el timestamp real de cada frame
                                  % marcado se conserva igual.
mostrar_traza = true;             % dibuja la traza acumulada del extremo
% ---------------------------------------------------------------------
%
% POR QUÉ NO RECORTAR EL VIDEO PRIMERO:
%   Recortar/re-encodear el .MOV re-basea los PTS a cero y suele "rellenar"
%   los frames que el iPhone descartó, con lo que se pierde el timestamp real
%   (que es justo lo que necesitamos). Trabajando sobre el ORIGINAL y saltando
%   frames con 'recorte'/'paso_frames', cada frame marcado conserva su PTS
%   exacto obtenido por ffprobe.
% ---------------------------------------------------------------------


% =====================================================================
% 1. TIMESTAMPS REALES POR FRAME (ffprobe)
% =====================================================================
% best_effort_timestamp_time da el PTS real de cada frame decodificado.
% Si el iPhone descartó frames, los saltos quedan reflejados acá y NO se
% asume un dt constante.
%
% (Se hace inline y no como función local para ser compatible con MATLAB
%  2015, que no permite definir funciones dentro de un script.)
t_all = [];
okTS  = false;

if exist(videoFile, 'file') ~= 2
    error('No se encuentra el video: %s', videoFile);
end

cmd = sprintf(['%s -v error -select_streams v:0 ', ...
               '-show_entries frame=best_effort_timestamp_time ', ...
               '-of csv=p=0 "%s"'], RUTA_FFPROBE, videoFile);
[status, out] = system(cmd);

if status ~= 0 || isempty(strtrim(out))
    warning('ffprobe falló (status=%d). Revisar RUTA_FFPROBE.', status);
else
    % El formato csv=p=0 puede dejar una coma final pegada a algún token
    % (p.ej. "0.000000,"). Sin limpiarla, str2double la vuelve NaN y se
    % perdería ese frame, desalineando TODA la serie tiempo<->frame.
    out  = strrep(out, ',', ' ');
    toks = regexp(strtrim(out), '\s+', 'split');
    vals = str2double(toks);

    if any(isnan(vals))
        idxNaN = find(isnan(vals));
        idxOK  = find(~isnan(vals));
        if numel(idxOK) >= 2
            vals(idxNaN) = interp1(idxOK, vals(idxOK), idxNaN, 'linear', 'extrap');
            warning('%d frame(s) sin PTS: timestamp interpolado.', numel(idxNaN));
        else
            warning('Demasiados frames sin PTS; timestamps poco confiables.');
        end
    end

    if ~isempty(vals) && all(~isnan(vals))
        t_all = vals(:);
        okTS  = true;
    end
end

v   = VideoReader(videoFile);
fps = v.FrameRate;

if ~okTS
    warning(['No se pudieron leer timestamps con ffprobe. ', ...
             'Se usará dt = 1/FrameRate como respaldo (menos preciso).']);
    % respaldo: se completa más abajo, frame a frame, con (idx-1)/fps
end


% =====================================================================
% 2. SELECCIÓN DEL PIVOTE (una sola vez, sobre el primer frame a usar)
% =====================================================================
if isempty(recorte)
    frameIni = 1;  frameFin = Inf;
else
    frameIni = recorte(1);  frameFin = recorte(2);
end

% avanzar hasta el primer frame del recorte.
% Salto rápido por tiempo para no decodificar todo lo anterior en videos largos;
% el tiempo del frame i (1-based) es t_all(i) si hay timestamps, o (i-1)/fps.
if frameIni > 1
    if okTS && frameIni <= numel(t_all)
        v.CurrentTime = max(0, t_all(frameIni) - 0.5/fps);
    else
        v.CurrentTime = max(0, (frameIni-1)/fps - 0.5/fps);
    end
end
idx = frameIni - 1;
frame = [];
while hasFrame(v)
    idx = idx + 1;
    f = readFrame(v);
    if idx >= frameIni
        frame = f;
        break;
    end
end
if isempty(frame)
    error('No se alcanzó el frame inicial del recorte.');
end

fig = figure('Name', 'Trackeo manual de la barra', 'Color', 'w', ...
             'NumberTitle', 'off');
imshow(frame);
title('PASO 1: clic en el PIVOTE (eje fijo de rotación)', ...
      'FontSize', 13, 'FontWeight', 'bold');
[x_pivote, y_pivote] = ginput(1);
if isempty(x_pivote)
    error('No se marcó el pivote.');
end
hold on;
plot(x_pivote, y_pivote, 'g+', 'LineWidth', 2, 'MarkerSize', 14);
hold off;


% =====================================================================
% 3. MARCACIÓN DEL EXTREMO, CUADRO A CUADRO
% =====================================================================
% Preasignación generosa
Nest = numel(t_all);
if Nest == 0, Nest = round(v.Duration * fps) + 10; end

t_exp    = nan(Nest,1);
x_exp    = nan(Nest,1);
y_exp    = nan(Nest,1);
angv_deg = nan(Nest,1);   % ángulo "trigonométrico" (atan2)
ang_deg  = nan(Nest,1);   % ángulo respecto al piso = 180 - angv
angrad   = nan(Nest,1);

% salto rápido al primer frame del recorte (no decodifica todo lo previo)
if frameIni > 1
    if okTS && frameIni <= numel(t_all)
        v.CurrentTime = max(0, t_all(frameIni) - 0.5/fps);
    else
        v.CurrentTime = max(0, (frameIni-1)/fps - 0.5/fps);
    end
    idx = frameIni - 1;
else
    v.CurrentTime = 0;
    idx = 0;         % índice absoluto de frame en el video
end
k   = 0;         % contador de frames efectivamente marcados

fprintf('Marcá el EXTREMO con clic. Submuestreo: 1 de cada %d frames.\n', paso_frames);
fprintf('  S / espacio = saltar este frame   |   Q / Esc = terminar   |   ');
fprintf('Cerrar la ventana o Enter sin clic = terminar.\n');

while hasFrame(v)
    idx = idx + 1;
    f = readFrame(v);

    if idx < frameIni,  continue;  end
    if idx > frameFin,  break;     end

    % submuestreo: solo se marca 1 de cada 'paso_frames' dentro del rango
    if mod(idx - frameIni, paso_frames) ~= 0
        continue;
    end

    if ~ishandle(fig)   % el usuario cerró la ventana
        break;
    end

    imshow(f); hold on;
    plot(x_pivote, y_pivote, 'g+', 'LineWidth', 2, 'MarkerSize', 14);
    if mostrar_traza && k >= 1
        plot(x_exp(1:k), y_exp(1:k), 'r.-', 'LineWidth', 1, 'MarkerSize', 8);
    end

    % tiempo real del frame (o respaldo por fps)
    if okTS && idx <= numel(t_all)
        t_frame = t_all(idx);
    else
        t_frame = (idx-1)/fps;
    end

    title(sprintf(['Frame abs %d  |  t = %.5f s  |  clic = marcar extremo\n', ...
                   '(tecla S o barra espaciadora = SALTAR este frame  |  ', ...
                   'Q o Esc = terminar)'], idx, t_frame), 'FontSize', 11);

    [xe, ye, boton] = ginput(1);
    hold off;

    % --- terminar sesión: ventana cerrada, Enter vacío, Q o Esc ---
    esTerminar = isempty(xe) || ...
                 (~isempty(boton) && any(boton == [27, double('q'), double('Q')]));
    if esTerminar
        break;
    end

    % --- saltar SOLO este frame (S, s, o barra espaciadora) ---
    esSaltar = ~isempty(boton) && any(boton == [32, double('s'), double('S')]);
    if esSaltar
        fprintf('  (frame %d salteado)\n', idx);
        continue;   % no guarda nada de este frame, sigue con el próximo
    end

    % --- click normal: registrar el punto ---
    dx = xe - x_pivote;
    dy = y_pivote - ye;            % invierte el eje Y (imagen -> cartesiano)
    a_trig = atan2(dy, dx);        % rad
    a_trig_d = rad2deg(a_trig);
    a_piso_d = 180 - a_trig_d;     % ángulo respecto al piso

    k = k + 1;
    t_exp(k)    = t_frame;
    x_exp(k)    = xe;
    y_exp(k)    = ye;
    angv_deg(k) = a_trig_d;
    ang_deg(k)  = a_piso_d;
    angrad(k)   = deg2rad(a_piso_d);
end

if ishandle(fig), close(fig); end

% recortar a lo efectivamente marcado
t_exp    = t_exp(1:k);
x_exp    = x_exp(1:k);
y_exp    = y_exp(1:k);
angv_deg = angv_deg(1:k);
ang_deg  = ang_deg(1:k);
angrad   = angrad(1:k);

if k == 0
    error('No se marcó ningún frame.');
end

% opcional: recolocar el origen de tiempo en el primer frame marcado
t_exp = t_exp - t_exp(1);


% =====================================================================
% 4. EXPORTAR CSV Y MAT  (mismo formato: t;x;y;angv;ang;angrad)
% =====================================================================
[~, base, ~] = fileparts(videoFile);

tabla = table(t_exp, x_exp, y_exp, angv_deg, ang_deg, angrad, ...
    'VariableNames', {'t','x','y','angv','ang','angrad'});

csvName = sprintf('%s_datos.csv', base);
% writetable usa coma por defecto; el pipeline previo usa ';'
writetable(tabla, csvName, 'Delimiter', ';');

matName = sprintf('%s_datos.mat', base);
save(matName, 't_exp','x_exp','y_exp','angv_deg','ang_deg','angrad', ...
     'x_pivote','y_pivote','fps');

fprintf('\nGuardado:\n  %s\n  %s\n', csvName, matName);
fprintf('Frames marcados: %d\n', k);


% =====================================================================
% 5. GRÁFICO DE CONTROL
% =====================================================================
figure('Color','w','Name','theta(t)');
plot(t_exp, ang_deg, 'bo-', 'LineWidth', 1.4, 'MarkerSize', 6, ...
     'MarkerFaceColor', 'b');
grid on;
xlabel('t (s)');
ylabel('\theta respecto al piso (^\circ)');
title(sprintf('Trayectoria angular experimental  (\\theta_0 = %.1f^\\circ)', ang_deg(1)));
