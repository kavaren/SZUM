%% Połączenie z rosem
%rosinit('82.145.80.221', 11311) 

%% Tworzenie subskrybenta (odczytywanie)
pozycja = rossubscriber('/turtle1/pose');

%% Odczytywanie i wizualizacja pozycji
figure(1)

axis equal
ylim([0 11.088889122009277]) % Dokładny wymiar przestrzeni turtle1
xlim([0 11.088889122009277])
axis square
while 1
    plot(pozycja.LatestMessage.X, pozycja.LatestMessage.Y,'.')
    pozycjaKon = receive(pozycja,2);
    hold on
    drawnow
    pause(0.01)
    disp('x: ')
    disp(pozycjaKon.X)
    disp('y: ')
    disp(pozycjaKon.Y)
    disp('theta: ')
    disp(pozycjaKon.Theta/(2*pi)*360+180)
end

%% Tworzenie Publisher'a (wysyłanie)
[pub,msg] = rospublisher('/turtle1/cmd_vel/','geometry_msgs/Twist');

%% Wysyłanie prędkości i rotacji
msg.Linear.X = 50;  % Przód - Tył
msg.Angular.Z = pi; % Rotacja
send(pub,msg);

%% Resetowanie pozycji : tworzenie serwisu
% warto pamiętać żeby czyścić message przed resetem
% (przy resecie zachowywane i wykonywana jest ostatnia wiadomość)
msg.Linear.X = 0;
msg.Angular.Z = 0; 
send(pub,msg);
% Tworzenie klienta (z funkcją reset)
client = rossvcclient('/reset');

% Stworzenie pustego requesta
req = rosmessage(client);

% Odwołanie się do serwisu
resp = call(client,req);



