with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with memoire; use memoire;
with fichier;

procedure test_fichier is

	package fichier_0 is new fichier(size => 0);
	Taille : integer := fichier_0.Taille("exemple_huff.txt");
	package fichier_taille is new fichier(size => Taille);
	tab : fichier_taille.T_tab_bit;
	tab_byte : fichier_taille.T_tab_byte;

	package fichier_1 is new fichier(size => 1);
	--zero : T_bit := integerTbit(0);
	--un : T_bit := integerTbit(1);
	--tab2 : fichier_1.T_tab := (un, zero, un, zero, un, zero, un, zero);
	--tab3 : fichier_1.T_tab;

begin
	fichier_taille.Lire_bit("exemple_huff.txt", tab);
	fichier_taille.Ecrire("exemple_fichier.out", tab);
	fichier_taille.Lire_byte("exemple_huff.txt", tab_byte);
	fichier_taille.Creer("exemple_fichier.iteratif.out");
	for i in 1..Taille loop
		fichier_taille.Ajouter("exemple_fichier.iteratif.out", To_bits(T_byte(tab_byte(i))));
	end loop;
end test_fichier;
