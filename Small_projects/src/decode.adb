with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

package body decode is
	
	Procedure Tailles (file_name 		: in string 	;
			   nbu_byte 	 	: out integer 	;
			   lng_parcours_infixe 	: out integer	;
			   byte_ff 		: out T_byte 	) is

		file	: Ada.Streams.Stream_IO.File_Type		;
		S	: Stream_Access					;
		byte	: T_byte					;
		previous_byte	: T_byte					;
		i 	: integer				:= 1	;
		nb_ones : integer 				:= 0	;
		bits 	: T_bits 					;
	begin
		nbu_byte := 0;
		lng_parcours_infixe := 0;

		Open(file, In_File, file_name);
		S := Stream(file);
		byte_ff := T_byte'Input(S);
		byte_ff := T_byte(integer'val(byte_ff));
		byte := T_byte'Input(S);
		loop
			previous_byte := byte;
			byte := T_byte'Input(S);
			nbu_byte := nbu_byte + 1;
			exit when End_Of_File(file) or previous_byte = byte;
		end loop;
		loop
			bits := To_bits(T_byte'Input(S));
			loop 
				if bits(i) = 1 then
					nb_ones := nb_ones + 1;
				end if;
				lng_parcours_infixe := lng_parcours_infixe + 1;
				i := i + 1;
				exit when i = 9 or nb_ones = nbu_byte;
			end loop;
			i := 1;
			exit when End_Of_File(file) or nb_ones = nbu_byte;
		end loop;
		Close (file);
	end Tailles;


	Procedure Lire (file_name 		: in 	string 			;
			parcours_infixe 	: out 	T_parcours_infixe 	;
			tab_feuilles 		: out 	T_tab_feuilles 		) is

		file	: Ada.Streams.Stream_IO.File_Type		;
		S	: Stream_Access					;
		byte	: T_byte					;
		bits 	: T_bits 					;

	begin
		Open(file, In_File, file_name);
		S := Stream(file);
		byte := T_byte'Input(S);
		for i in 1..lng_tab_feuilles loop
			byte := T_byte'Input(S);
			tab_feuilles(i) := byte;
		end loop;
		byte := T_byte'Input(S);
		for i in 0..(lng_parcours_infixe / 8) - 1 loop
			bits := To_bits(T_byte'Input(S));
			for j in 1..8 loop
				parcours_infixe(i * 8 + j) := bits(j);
			end loop;
		end loop;
		bits := To_bits(T_byte'Input(S));
		for i in lng_parcours_infixe - lng_parcours_infixe mod 8 + 1..lng_parcours_infixe loop
			parcours_infixe(i) := bits(i + 1 - lng_parcours_infixe + lng_parcours_infixe mod 8 - 1);
		end loop;
		parcours_infixe(lng_parcours_infixe + 1) := 1;
		Close (file);
	end Lire;



	Procedure ReconstruireH (parcours_infixe 	: in 	T_parcours_infixe	;
				 tab_feuilles 		: in 	T_tab_feuilles 		;
				 byte_ff 		: in 	T_byte 			;
				 arbre 			: out 	T_arbre			;
				 i			: in out integer 		;
				 f 			: in out integer 		;
				 rff 			: in out boolean 		) is
		
		neant : T_arbre;
		bg : T_arbre ;
		bd : T_arbre ;
	begin
		Initialiser(neant);
		Initialiser(arbre);
		if Integer'Val(parcours_infixe(i)) = 1 then
			if f = Integer'Val(byte_ff) and rff then
				Devient_ff(arbre);
				rff := False;
			else
				Affecter(arbre, tab_feuilles(f), 0, neant, neant);
				f := f + 1;
			end if;
		else
			i := i + 1;
			bg := Branche_g(arbre);
			ReconstruireH(parcours_infixe, tab_feuilles, byte_ff, bg, i, f, rff);
			i := i + 1;
			bd := Branche_d(arbre);
			ReconstruireH(parcours_infixe, tab_feuilles, byte_ff, bd, i, f, rff);
			Affecter(arbre, T_byte(0), 0, bg, bd);
		end if;
	end ReconstruireH;


	Procedure Decoder (file_name_in : in string ; file_name_out : in string ; arbre : in T_arbre) is
		file_out	: Ada.Streams.Stream_IO.File_Type		;
		S_out		: Stream_Access					;
		file_in		: Ada.Streams.Stream_IO.File_Type		;
		S_in		: Stream_Access					;
		bits 		: T_bits 					;
		noeud_courant 	: T_arbre 				:= arbre;
		byte 		: T_byte					;
		fin_fichier 	: boolean 				:= False;
	begin
		--Initialiser(noeud_courant);
		noeud_courant := arbre;

		Create (file_out, Out_file, file_name_out);
		S_out := Stream (file_out);
		Open (file_in, In_File, file_name_in);
		S_in := Stream (file_in);

		for i in 1..lng_tab_feuilles + lng_parcours_infixe / 8 + 2 loop
			byte := T_byte'Input(S_in);
		end loop;

		bits := To_bits(T_byte'Input(S_in));
		for i in lng_parcours_infixe mod 8 + 1..8 loop
			if Terminal(noeud_courant) then
				byte := Le_byte(noeud_courant);
				T_byte'Write(S_out, byte);
				noeud_courant := arbre;
			end if;
			if bits(i) = 0 then
				noeud_courant := Branche_g(noeud_courant);
			else
				noeud_courant := Branche_d(noeud_courant);
			end if;
		end loop;

		loop
			bits := To_bits(T_byte'Input(S_in));
			for i in 1..8 loop
				if Terminal(noeud_courant) then
					if Est_ff(noeud_courant) then
						fin_fichier := True;
					elsif not fin_fichier then
						byte := Le_byte(noeud_courant);
						T_byte'Write(S_out, byte);
					end if;
					noeud_courant := arbre;
				end if;
				if bits(i) = 0 then
					noeud_courant := Branche_g(noeud_courant);
				else
					noeud_courant := Branche_d(noeud_courant);
				end if;
			end loop;
			exit when End_Of_File(file_in) or fin_fichier;
		end loop;

		Close(file_in);
		Close(file_out);
	end Decoder;



	Function Acces_parcours_infixe (parcours_infixe : in T_parcours_infixe ; i : in integer) return integer is
	begin
		return Integer'Val(parcours_infixe(i));
	end Acces_parcours_infixe;



	Function Acces_tab_feuilles (tab_feuilles : in T_tab_feuilles ; i : in integer) return integer is
	begin
		return Integer'Val(tab_feuilles(i));
	end Acces_tab_feuilles;
end decode;
