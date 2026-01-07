Interpreter podzbioru basha napisany w javie używając generatora paresrów CUP oraz lexera JFLEX

Kompilacja przebiega używająć make (./make)

Po wpisaniu zestawu komend jego pracę można zakończyć używająć Ctrl + D i otrzymać wynik w konsoli

Zostały zrealizowane wymagania bazowe oraz rozszeszenia R1, R2, R3, R6 i R7.

W pliku test_commands znajdują sie komendy testujące wyrażenia tych funkcjonalności (wzięte ze specyfikacji projektu).

Poniżej znajdują sie przemyślenia:



Głównymi nieterminalami parsera są wyrażenie, lista wyrażeń, argument i argumenty (oraz terminator komendy). 
Taka architektura pozwala na zrealizowanie powyższych funkcjonalności, ale ma problem z dodaniem ich większej ilości.
Obecnie wyrażenie zwraca funkcję (Supplier) która zwraca wynik tekstowy, oraz czy informację czy wynik jest błędem. Argument oraz argumenty zwracają funkcję zwracającą String. Obecnie for jest wyrażeniem.

Gdybym pisał projekt od nowa nieterminale byłyby podzielone na wyrażenia indykowane słowem kluczowym "echo" bądź "cat" lub znakiem ">" czy ">>" (tak jak jest teraz), przyjmujące argumenty
(np echo "test", cat x > y), oraz instrukcję. Instruckja mogłabybyć jednym wyrażeniem zakończonym średnikiem (np. echo x > y >> a;), instrukcją for
która sama w sobie przyjmuję instrukcje albo instrukcją złożoną która zawierałaby więcej instrukcji. W takim wypadku dużo łatwiejszy byłby dalszy rozwór projektu.
Dużo ułatwiłoby też zamiana Abstrakcyjnego Drzewa Sematycznego na formę pośrednią, aczkolwiek nie wiem czy jest to możliwe używając CUPa.


Uwaga: z niewiadomych przyczyn plugin Intellija do CUPa pokazuje tą instrukcję jako błąd, ale wszystko działa

non terminal List<Supplier<Resiult>> expr_list;
