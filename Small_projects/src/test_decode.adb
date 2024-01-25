with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with arbre; use arbre;
with memoire; use memoire;
with fichier;
with decode;
with Ada.strings.Unbounded; use Ada.Strings.Unbounded;
with Affichage; use Affichage;

procedure test_decode is

	package fichier_1 is new fichier(size => 1);
	length : integer := fichier_1.Taille("exemple_huff.txt");
	
	package fichier_length is new fichier(size => length);
	use fichier_length;

	package decode_i is new decode(lng_parcours_infixe => 0, lng_tab_feuilles => 0);

	file_name_in : string := "exemple_fichier.code.out";
	file_name_out : string := "exemple_fichier.decode.out";
	nbu_byte : integer;
	lng_parcours_infixe : integer;
	byte_ff : T_byte;
	arbre : T_arbre;
	Est_Gauche : boolean;
	indent : Unbounded_String := To_Unbounded_String("");
	bavard : boolean := True;




	procedure decompression(file_name_in : in string ; file_name_out : in string ; nbu_byte : in integer ; lng_parcours_infixe : in integer ; byte_ff : in T_byte) is

		package decode_tailles is new decode(lng_parcours_infixe 	=> lng_parcours_infixe,
						     lng_tab_feuilles 		=> nbu_byte	      );
		use decode_tailles;

		parcours_infixe : T_parcours_infixe;
		tab_feuilles : T_tab_feuilles;
		i : integer := 1;
		f : integer := 1;
		rff : boolean := True;
	begin
		Lire(file_name_in, parcours_infixe, tab_feuilles);
		Put("Lire OK");
		ReconstruireH (parcours_infixe, tab_feuilles, T_byte(byte_ff), arbre, i, f, rff);
		Put("ReconstruireH OK");
		Afficher_arbreH(arbre, indent, Est_Gauche);
		--Put(Taille(arbre));
		Decoder(file_name_in, file_name_out, arbre);
		Put("Decoder OK");
	end decompression;

begin
	Put("Début");
	decode_i.Tailles(file_name_in, nbu_byte, lng_parcours_infixe, byte_ff);
	Put("Taille OK");
	decompression(file_name_in, file_name_out, nbu_byte, lng_parcours_infixe, T_byte(byte_ff));
		put(lng_parcours_infixe);
		put(nbu_byte);
		put(nbu_byte*8);

end test_decode;
