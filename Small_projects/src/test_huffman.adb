with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with arbre; use arbre;
with memoire; use memoire;
with fichier;
with code;
with Affichage ; use Affichage;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with decode;

procedure test_huffman is
	
	file_name_in : constant string := "exemple_huff.txt";
	file_name_code_out : constant string := "exemple_fichier.code.out";
	file_name_decode_out : constant string := "exemple_fichier.decode.out";

		

	---- Valeurs attendues ----
	
	a_nb_carac_unique : constant integer := 10;
	a_file_size : constant integer := 40;
	a_lng_parcours_infixe : constant integer := 20;

	---------------------------


	package fichier_1 is new fichier(size => 1);
	length : integer := fichier_1.Taille("exemple_huff.txt");
	
	package fichier_length is new fichier(size => length);
	use fichier_length;

	package code_0 is new code(file_size => length, nbu_byte => 0);
	
	package code_length is new code(file_size => length, nbu_byte => code_0.nb_caractere_unique("exemple_huff.txt"));
	use code_length;
	


	tab_branche : T_tab_branche;
	arbre : T_arbre;
	tab_code : T_tab_code;
	c_code : T_code;
	c_code_l : integer := 0;
	c : integer := 0;
	pi : T_pi;
	bpi : T_bpi;
	ipi : integer := 0;
	ibpi : integer := 0;
	e : integer := 0;
	nb_carac_unique : integer;
	Est_Gauche : boolean := False;
	indent : Unbounded_String := To_Unbounded_String("");
	val : T_code;
	len : integer;


	file_in		: Ada.Streams.Stream_IO.File_Type		;
	S_in		: Stream_Access					;
	file_decode_out	: Ada.Streams.Stream_IO.File_Type		;
	S_decode_out	: Stream_Access					;

	

	package decode_i is new decode(lng_parcours_infixe => 0, lng_tab_feuilles => 0);

	nbu_byte : integer;
	lng_parcours_infixe : integer;
	byte_ff : T_byte;
	noeud : T_arbre;
	lng_tab_feuilles : integer;




		package decode_tailles is new decode(lng_parcours_infixe 	=> lng_parcours_infixe,
						     lng_tab_feuilles 		=> nbu_byte	      );
		use decode_tailles;

		parcours_infixe : T_parcours_infixe;
		tab_feuilles : T_tab_feuilles;
		i : integer := 1;
		f : integer := 1;
		rff : boolean := True;

	

	
		
	
		

	
begin
	New_Line;
	Put_Line("===========================");
	Put_Line("||    Début des tests    ||");
	Put_Line("===========================");
	New_Line;

	New_Line;
	Put("-------- Tests de la compression --------");
	New_Line;

	New_Line;
	nb_carac_unique := nb_caractere_unique(file_name_in);
	Put("Le nombre de caractère unique du fichier est : "); Put(nb_carac_unique, 0);
	New_Line;
	Pragma Assert(nb_carac_unique = a_nb_carac_unique);
	Put_Line("Ce nombre est CORRECT.");
	New_Line;



	New_Line;
	Put_Line("Execution de Premiere_branche.");
	Premiere_branche(file_name_in, tab_branche);
	for i in 1..256 loop
		Acces_tab_branche(tab_branche, i, noeud);
		if La_freq(noeud) <= a_file_size then
			Pragma Assert (Le_byte(noeud) = 10 or
				       Le_byte(noeud) = Character'Pos(' ') or
				       Le_byte(noeud) = Character'Pos(':') or
				       Le_byte(noeud) = Character'Pos('d') or
				       Le_byte(noeud) = Character'Pos('e') or
				       Le_byte(noeud) = Character'Pos('l') or
				       Le_byte(noeud) = Character'Pos('m') or
				       Le_byte(noeud) = Character'Pos('p') or
				       Le_byte(noeud) = Character'Pos('t') or
				       Le_byte(noeud) = Character'Pos('x'));
		end if;
		Pragma Assert (Terminal(noeud));
	end loop;
	
	Acces_tab_branche(tab_branche, 0, noeud);
	Pragma Assert (Est_ff(noeud));
	Acces_tab_branche(tab_branche, Character'Pos('x'), noeud);
	Pragma Assert(La_freq(noeud) = 4);
	Acces_tab_branche(tab_branche, Character'Pos('m'), noeud);
	Pragma Assert(La_freq(noeud) = 4);
	Acces_tab_branche(tab_branche, Character'Pos('l'), noeud);
	Pragma Assert(La_freq(noeud) = 2);
	Acces_tab_branche(tab_branche, Character'Pos(':'), noeud);
	Pragma Assert(La_freq(noeud) = 1);
	Acces_tab_branche(tab_branche, 0, noeud);
	Pragma Assert(La_freq(noeud) = 0);
	Acces_tab_branche(tab_branche, Character'Pos('d'), noeud);
	Pragma Assert(La_freq(noeud) = 1);
	Acces_tab_branche(tab_branche, Character'Pos('t'), noeud);
	Pragma Assert(La_freq(noeud) = 5);
	Acces_tab_branche(tab_branche, Character'Pos(' '), noeud);
	Pragma Assert(La_freq(noeud) = 5);
	Acces_tab_branche(tab_branche, 10, noeud);
	Pragma Assert(La_freq(noeud) = 2);
	Acces_tab_branche(tab_branche, Character'Pos('p'), noeud);
	Pragma Assert(La_freq(noeud) = 3);
	Acces_tab_branche(tab_branche, Character'Pos('e'), noeud);
	Pragma Assert(La_freq(noeud) = 15);

	Put_Line("Le resultat de la procedure Premiere_branche est CORRECT.");
	New_Line;



	New_Line;
	Put_Line("Execution de ArbreH.");
	ArbreH(tab_branche, arbre);
	Put_Line("Execution de ArbreH terminée.");
	Put_Line("Veuillez vérifier l'arbre : ");
	New_Line;
	Afficher_arbreH(arbre, indent, Est_Gauche);
	New_Line;



	New_Line;
	Put_Line("Execution de Tableau_code.");
	Initialiser_tab_code(tab_code);
	Tableau_code(arbre, tab_code, c_code, c_code_l, pi, bpi, ipi, ibpi);
	Acces_tab_code(tab_code, 0, val, len);
	Pragma Assert (len = 6 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 1
			       and Acces_code(val, 3) = 0
			       and Acces_code(val, 4) = 1
			       and Acces_code(val, 5) = 1
			       and Acces_code(val, 6) = 0);
	Acces_tab_code(tab_code, 11, val, len);
	Pragma Assert (len = 4 and Acces_code(val, 1) = 1
			       and Acces_code(val, 2) = 0
			       and Acces_code(val, 3) = 1
			       and Acces_code(val, 4) = 0);
	Acces_tab_code(tab_code, Character'Pos(' ') + 1, val, len);
	Pragma Assert (len = 3 and Acces_code(val, 1) = 1
			       and Acces_code(val, 2) = 0
			       and Acces_code(val, 3) = 0);
	Acces_tab_code(tab_code, Character'Pos(':') + 1, val, len);
	Pragma Assert (len = 5 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 1
			       and Acces_code(val, 3) = 0
			       and Acces_code(val, 4) = 1
			       and Acces_code(val, 5) = 0);
	Acces_tab_code(tab_code, Character'Pos('d') + 1, val, len);
	Pragma Assert (len = 6 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 1
			       and Acces_code(val, 3) = 0
			       and Acces_code(val, 4) = 1
			       and Acces_code(val, 5) = 1
			       and Acces_code(val, 6) = 1);
	Acces_tab_code(tab_code, Character'Pos('e') + 1, val, len);
	Pragma Assert (len = 2 and Acces_code(val, 1) = 1
			       and Acces_code(val, 2) = 1);
	Acces_tab_code(tab_code, Character'Pos('l') + 1, val, len);
	Pragma Assert (len = 4 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 1
			       and Acces_code(val, 3) = 0
			       and Acces_code(val, 4) = 0);
	Acces_tab_code(tab_code, Character'Pos('m') + 1, val, len);
	Pragma Assert (len = 3 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 0
			       and Acces_code(val, 3) = 1);
	Acces_tab_code(tab_code, Character'Pos('p') + 1, val, len);
	Pragma Assert (len = 4 and Acces_code(val, 1) = 1
			       and Acces_code(val, 2) = 0
			       and Acces_code(val, 3) = 1
			       and Acces_code(val, 4) = 1);
	Acces_tab_code(tab_code, Character'Pos('t') + 1, val, len);
	Pragma Assert (len = 3 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 1
			       and Acces_code(val, 3) = 1);
	Acces_tab_code(tab_code, Character'Pos('x') + 1, val, len);
	Pragma Assert (len = 3 and Acces_code(val, 1) = 0
			       and Acces_code(val, 2) = 0
			       and Acces_code(val, 3) = 0);

	Pragma Assert (Acces_pi(pi, 1) = 0 and
		       Acces_pi(pi, 2) = 0 and
		       Acces_pi(pi, 3) = 0 and
		       Acces_pi(pi, 4) = 1 and
		       Acces_pi(pi, 5) = 1 and
		       Acces_pi(pi, 6) = 0 and
		       Acces_pi(pi, 7) = 0 and
		       Acces_pi(pi, 8) = 1 and
		       Acces_pi(pi, 9) = 0 and
		       Acces_pi(pi, 10) = 1 and
		       Acces_pi(pi, 11) = 0 and
		       Acces_pi(pi, 12) = 1 and
		       Acces_pi(pi, 13) = 1 and
		       Acces_pi(pi, 14) = 1 and
		       Acces_pi(pi, 15) = 0 and
		       Acces_pi(pi, 16) = 0 and
		       Acces_pi(pi, 17) = 1 and
		       Acces_pi(pi, 18) = 0 and
		       Acces_pi(pi, 19) = 1 and
		       Acces_pi(pi, 20) = 1);

	Pragma Assert (Acces_bpi(bpi, 0) = 5 and
		       Acces_bpi(bpi, 1) = Character'Pos('x') and
		       Acces_bpi(bpi, 2) = Character'Pos('m') and
		       Acces_bpi(bpi, 3) = Character'Pos('l') and
		       Acces_bpi(bpi, 4) = Character'Pos(':') and
		       Acces_bpi(bpi, 5) = Character'Pos('d') and
		       Acces_bpi(bpi, 6) = Character'Pos('t') and
		       Acces_bpi(bpi, 7) = Character'Pos(' ') and
		       Acces_bpi(bpi, 8) = 10 and
		       Acces_bpi(bpi, 9) = Character'Pos('p') and
		       Acces_bpi(bpi, 10) = Character'Pos('e'));
	Put_Line("Le résultat de la procédure Tableau_code est CORRECT.");
	New_Line;



	New_Line;
	Put_Line("Execution de Traduire.");
	Traduire (file_name_in, file_name_code_out, tab_code, pi, bpi);
	Put_Line("Execution de Traduire terminée.");
	New_Line;

	

	New_Line;
	Put_Line("Execution de Free.");
	Free(arbre, tab_branche);
	Put_Line("Execution de Free terminée.");
	New_Line;
	

------------------------------------------------------------------------------------------------
	New_Line;
	Put("-------- Tests de la décompression --------");
	New_Line;
	

	New_Line;
	Put_Line("Execution de Tailles");
	decode_i.Tailles(file_name_code_out, lng_tab_feuilles, lng_parcours_infixe, byte_ff);
	Pragma Assert (lng_tab_feuilles = a_nb_carac_unique);
	Pragma Assert (lng_parcours_infixe = a_lng_parcours_infixe);
	Pragma Assert (byte_ff = 5);
	Put_Line("Le résultat de la procédure Tailles est CORRECT.");
	New_Line;



	New_Line;
	Put_Line("Execution de Lire.");
	Lire(file_name_code_out, parcours_infixe, tab_feuilles);
	for i in 1..lng_parcours_infixe loop
		Pragma Assert (Acces_pi(pi, i) = Acces_parcours_infixe(parcours_infixe, i));
	end loop;
	for i in 1..lng_tab_feuilles loop
		Pragma Assert (Acces_bpi(bpi, i) = Acces_tab_feuilles( tab_feuilles, i));
	end loop;
	Put_Line("Le résultat de la procédure Lire est CORRECT.");
	New_Line;



	New_Line;
	Put_Line("Execution de ReconstruireH.");
	ReconstruireH (parcours_infixe, tab_feuilles, byte_ff, arbre, i, f, rff);
	Put_Line("Execution de ReconstruireH terminée.");
	Put_Line("Veuillez vérifier l'arbre.");
	New_Line;
	Afficher_arbreH(arbre, indent, Est_Gauche);
	New_Line;



	New_Line;
	Put_Line("Execution de Decoder.");
	Decoder(file_name_in, file_name_decode_out, arbre);
	Put_Line("Execution de Decoder terminée.");
	New_Line;
	New_Line;
	New_Line;



	Open(file_in, In_File, file_name_in);
	Open(file_decode_out, Out_File, file_name_decode_out);
	S_in := Stream(file_in);
	S_decode_out := Stream(file_decode_out);
	loop
		Pragma Assert (T_byte'Input(S_in) = T_byte'Input(S_decode_out));
		exit when End_Of_File(file_in) and End_Of_File(file_decode_out);
	end loop;
	Close(file_in);
	Close(file_decode_out);
	Put_Line("Le fichier décompressé est bien identique au fichier d'origine.");
	New_Line;



	New_Line;
	Put_Line("===========================");
	Put_Line("||   Succes des tests    ||");
	Put_Line("===========================");
	New_Line;

end test_huffman;
