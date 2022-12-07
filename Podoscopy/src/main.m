%% Wczytywanie danych
case_nr = 1; % wybierz case 1-4
[video_reader, left_leg_time, left_leg_data, right_leg_time, right_leg_data] = GetCaseData(case_nr);

% video_reader to obiekt do czytania plików wideo
% left_leg_time i right_leg_time to wektory czasu danych tensometrycznych

% left_leg_data i right_leg_data to dane tensometryczne. Są one mapami,
% którymi kluczami są Fy1, Fy2, Fz1, Fz2, Fz3, Fz4, Fx1, Fx2. Te dane
% zawierają to, co jest na rysunku 2 Measurement System (z
% pliku Dynamometric-Podoscope Platform.pdf).
%% Wizualizacja wszystkich parametrów związanych z czujnikami sił
leg = left_leg_data; % wybierz left_leg_data/right_leg_data

figure('units', 'normalized', 'outerposition', [0 0 1 1]); % Otwarcie wykresu na cały ekran
% Wykresy porównawcze mierzonych sił
subplot(2, 3, 1);
plot(leg('Fz1')); hold on;
plot(leg('Fz2'));
plot(leg('Fz3'));
plot(leg('Fz4'));
legend('Fz1', 'Fz2', 'Fz3', 'Fz4');
title('Siły wertykalne'); hold off;

subplot(2, 3, 2);
plot(leg('Fx1')); hold on;
plot(leg('Fx2'));
plot(leg('Fy1'));
plot(leg('Fy2'));
legend('Fx1', 'Fx2', 'Fy1', 'Fy2');
title('Siły horyzontalne'); hold off;

% Wykres siły reakcji podłoża
reaction_force = -Re(leg);
subplot(2, 3, 3)
plot(reaction_force(:, 1)); hold on;
plot(reaction_force(:, 2));
plot(reaction_force(:, 3));
legend('Fx', 'Fy', 'Fz');
title('GFR'); hold off;

% Wykres Center of Pressure
cop = COP(leg);
subplot(2, 3, 4)
plot(cop(:, 1)); hold on;
plot(cop(:, 2));
legend('x0', 'y0');
title('CoP'); hold off;

% Wykres momentów sił
torque = Torque(leg);
subplot(2, 3, 5)
plot(torque(:, 1)); hold on;
plot(torque(:, 2));
legend('Mx', 'My');
title('Momenty sił'); hold off;
%% Wizualizacja wszystkich parametrów związanych ze zdjęciami stóp
long_slices = [350 520; 1690 1930; 360 595; 545 700]; % fragment filmiku, w którym stopa ma kontakt z platformą
short_slices = [411 430; 1780 1830; 480 520; 620 632]; % fragment filmiku, w którym stopa jest najlepiej widoczna
aoe = [1 175 1 383; 79 246 208 570; 197 369 122 463; 81 258 72 455]; % położenia na filmach stóp
levels = [0.390 0.390 0.390 0.390]; % poziom binaryzacji
centroids = [184.35 65.9; 383.6 140.5; 294.8 318.4; 286.4 196.9]; % środki odcinków AB na filmikach wyznaczonych dzięki funkcji Plantocontourograph

range = short_slices(case_nr, 1):short_slices(case_nr, 2); % wybierz long_slices/short_slices
area = zeros(length(range), 1); % pole powierzchni przylegającej stopy
inertias = zeros(length(range), 3); % momenty bezwładności Ix i Iy i dewiacji Ixy (względem CoM)
inertias2 = zeros(length(range), 3); % momenty bezwładności Ix i Iy i dewiacji Ixy (względem środka odcinka AB)
p1 = zeros(length(range), 1); % tablica rezultatów funkcji Param1, której argumentem wejściowym są wartości tablicy inertias
p2 = zeros(length(range), 1); % tablica rezultatów funkcji Param1, której argumentem wejściowym są wartości tablicy inertias2

figure('units', 'normalized', 'outerposition', [0 0 1 1]); % Otwarcie wykresu na cały ekran
for i = range
    % Klatka obrazu
    subplot(2, 3, 1);
    frame = read(video_reader, i);
    frame = rgb2gray(frame);
    imshow(frame)
    title("Klatka nr " + int2str(i))
    
    % Obraz po binaryzacji, z nałożonymi, dwoma punktami (czerwony-> COM,
    % niebieski-> środek odcinka AB)
    subplot(2, 3, 2);
    Igray = read(video_reader, i);
    Ithresh = im2bw(Igray, levels(case_nr));
    Ithresh = ClearBinaryImage(Ithresh, aoe(case_nr, :)); % Skupienie się tylko na interesujących nas stopach
    % Punkt COM
    [com_x, com_y] = COM(Ithresh);
    % Środek odcinka AB na klatce filmiku wyznaczonego dzięki funkcji Plantocontourograph
    cen = centroids(case_nr, :);
    imshow(Ithresh); hold on;
    if 0 < com_x
        plot(com_x, com_y, 'r*');
    end
    plot(cen(1), cen(2), 'b*');
    legend('CoM', 'Środek AB');
    title('Obraz po przekształceniach'); hold off;

    % Pole powierzchni przylegającej stopy
    subplot(2, 3, 3);
    area(i+1-range(1)) = sum(sum(Ithresh));
    plot(area); hold on;
    title("Pole powierzchni przylegającej stopy"); hold off;

    % Moment bezwładności wyznaczony względem CoM
    subplot(2, 3, 4);
    [inertiaX, inertiaY, inertiaXY] = MomentOfInertia(Ithresh);
    inertias(i+1-range(1), :) = [inertiaX, inertiaY, inertiaXY];
    plot(inertias(:, 1)); hold on;
    plot(inertias(:, 2));
    plot(inertias(:, 3));
    legend('inertiaX', 'inertiaY', 'inertiaXY');
    title('Ix, Iy, Ixy względem CoM'); hold off;
    
    % Moment bezwładności wyznaczony względem środka odcinka AB
    subplot(2, 3, 5);
    [inertiaX, inertiaY, inertiaXY] = MomentOfInertia2(Ithresh, cen(1), cen(2));
    inertias2(i+1-range(1), :) = [inertiaX, inertiaY, inertiaXY];
    plot(inertias2(:, 1)); hold on;
    plot(inertias2(:, 2));
    plot(inertias2(:, 3));
    legend('inertiaX', 'inertiaY', 'inertiaXY');
    title('Ix, Iy, Ixy względem środka odcinka AB'); hold off;

    % Patrz dokumentacja funkcji Param1
    subplot(2, 3, 6);
    [inertiaX, inertiaY, inertiaXY] = MomentOfInertia(Ithresh);
    param1 = Param1(inertiaX, inertiaY, inertiaXY);
    p1(i+1-range(1)) = param1; % względem CoM
    [inertiaX, inertiaY, inertiaXY] = MomentOfInertia2(Ithresh, cen(1), cen(2));
    param1 = Param1(inertiaX, inertiaY, inertiaXY);
    p2(i+1-range(1)) = param1; % względem środka odcinka AB
    plot(p1); hold on;
    plot(p2);
    legend('CoM', 'Środek odcinka AB');
    title('$$\tan 2 \alpha$$', 'interpreter', 'latex'); hold off;
end
%% Plantokonturogram
% slices = [430 1830 520 632]; % ramka filmiku do rozważenia dla każdego przypadku
inpPath = "../res/images_to_dimension"; % ścieżka do folderu zawierającego wyłącznie (!) zdjęcia
outPath = "../res/results"; % ścieżka do folderu wynikowego (gdzie będą gromadzone zdjęcia z zaznaczonymi koordynatami)

listImg = dir(inpPath); % lista przechowująca ścieżki do zdjęć
footDim = zeros(length(listImg)-2, 5); % tabela przechowująca wyniki numeryczne
for i = 3:length(listImg) % 3, ponieważ pierwszy element to '.', drugi element to '..'
    listImg(i).name % rozważane zdjęcie
    fullInpPath = strcat(listImg(i).folder, '\', listImg(i).name);
    img = imread(fullInpPath);
    fullOutPath = strcat(outPath, '/', listImg(i).name); % ścieżka zdjęcia z zaznaczonymi koordynatami
    [clark, wejsflog, alfa, beta, gamma] = Plantocontourograph(img, fullOutPath);
    footDim(i-2, :) = [clark, wejsflog, alfa, beta, gamma];
end