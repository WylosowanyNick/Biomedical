function [clark, wejsflog, alfa, beta, gamma] = Plantocontourograph(img, filename)
%% Funkcja w sposób półautomatyczny pozwala na wyznaczanie parametrów
% anatomicznych stopy na podstawie danego jej zdjęcia (img). Do działania
% funkcji potrzebne jest zdjęcie "dimensioning.png", które powinno
% znajdować się w tym samym folderze, co ten skrypt. Zwracane parametry
% przez funkcję:
% -Wskaźnik Clarka [radiany]
% -Wskaźnik Wejsfloga [-]
% -Kąt koślawości palucha (kąt alfa) [radiany]
% -Kąt koślawości palca małego (kąt beta) [radiany]
% -Kąt piętowy (kąt gamma) [radiany]
%% Wyświetlanie sposobu wymiarowania i stopy do wymiarowania (img) w
% odpowiednich miejsach na ekranie.
screenSize = get(0, 'ScreenSize'); % wielkość ekranu 
wym = imread('dimensioning.png');       
figure('Position', [10 screenSize(4)/10 screenSize(3)/2.2 screenSize(4)/1.3]);
    imshow(wym, 'InitialMagnification', 'fit');
    title('Przykład ręcznego wymiarowania stopy');
fig = figure('Position',[screenSize(3)/2 screenSize(4)/10 screenSize(3)/2.2 screenSize(4)/1.3]);
    imshow(img, 'InitialMagnification', 'fit');
    title('Obraz roboczy. Należy zaznaczyć 6 punktów w kolejności: B, F, A, E, C, D, H, G, I');
hold on;
%% Zaznaczanie punktów na stopie (img)
% Punkty B i F
[x, y] = ginput(2); % pobranie zaznaczonych, dwóch koordynatów
xB = x(1); xF = x(2);
yB = y(1); yF = y(2);

plot(x, y, 'bx-', 'linewidth', 1); % wyświetlanie linii łączącej dwa punkty
text(xB-10, yB+5, 'B'); % etykieta punktu
text(xF+10, yF+5, 'F'); % etykieta punktu

% Punkty A i E
[x, y] = ginput(2); % pobranie zaznaczonych, dwóch koordynatów
xA = x(1); xE = x(2);
yA = y(1); yE = y(2);

plot(x, y, 'bx-', 'linewidth', 1); % wyświetlanie linii łączącej dwa punkty
text(xA-10, yA-5, 'A'); % etykieta punktu
text(xE+10, yE-5, 'E'); % etykieta punktu

% Punkty C i D
[x, y] = ginput(2); % pobranie zaznaczonych, dwóch koordynatów
xC = x(1); xD = x(2);
yC = y(1); yD = y(2);

plot(x, y, 'bx-', 'linewidth', 1); % wyświetlanie linii łączącej dwa punkty
text(xC-10, yC-5, 'C'); % etykieta punktu
text(xD+10, yD-5, 'D'); % etykieta punktu

% Punkty H i G
[x, y] = ginput(2); % pobranie zaznaczonych, dwóch koordynatów
xH = x(1); xG = x(2);
yH = y(1); yG = y(2);

plot(x, y, 'bx-', 'linewidth', 1); % wyświetlanie linii łączącej dwa punkty
text(xH-10, yH-5, 'H'); % etykieta punktu
text(xG+10, yG-5, 'G'); % etykieta punktu

% Punkt I
[xI, yI] = ginput(1); % pobranie koordynatu I

plot(xI, yI, 'bx-', 'linewidth', 1); % wyświetlanie punktu
text(xI+10, yI-5, 'I'); % etykieta punktu    
%% Współrzędne punktów na ekranie
B = [xB, yB];
A = [xA, yA];
F = [xF, yF];
E = [xE, yE];
C = [xC, yC];
D = [xD, yD];
H = [xH, yH];
G = [xG, yG];
I = [xI, yI];
%% Parametry anatomiczne stopy
clark = acos(dot(I-A, E-A)/(norm(I-A)*norm(E-A)));
wejsflog = norm(D-C)/norm(B-A);
alfa = acos(dot(A-E, G-A)/(norm(A-E)*norm(G-A)));
beta = acos(dot(B-F, H-B)/(norm(B-F)*norm(H-B)));
gamma = acos(dot(A-E, B-F)/(norm(A-E)*norm(B-F)));
%% Obsługa wykresów i zwracanie wyników
[clark, wejsflog, alfa, beta, gamma]
saveas(fig, filename);
close all;
end
