with arbre; use arbre;
with memoire; use memoire;
with fichier;

generic
	lng_parcours_infixe 	: integer;
	lng_tab_feuilles 	: integer;


package decode is
	
	package fichier_0 is new fichier (size => 1);
	
	type T_parcours_infixe 	is limited private;
	type T_tab_feuilles 	is limited private;
	--type T_parcours_infixe 	is array (1..lng_parcours_infixe + 1) 	of T_bit;
	--type T_tab_feuilles 	is array (1..lng_tab_feuilles) 		of T_byte;


	Procedure Tailles (file_name 		: in string 	;
			   nbu_byte 	 	: out integer 	;
			   lng_parcours_infixe 	: out integer	;
			   byte_ff 		: out T_byte 	);


	Procedure Lire (file_name 		: in 	string 			;
			parcours_infixe 	: out 	T_parcours_infixe 	;
			tab_feuilles 		: out 	T_tab_feuilles 		);


	Procedure ReconstruireH (parcours_infixe 	: in 	T_parcours_infixe	;
				 tab_feuilles 		: in 	T_tab_feuilles 		;
				 byte_ff 		: in 	T_byte 			;
				 arbre 			: out 	T_arbre			;
				 i 			: in out integer 		;
				 f 			: in out integer 		;
				 rff 			: in out boolean 		);


	Procedure Decoder (file_name_in : in string ; file_name_out : in string ; arbre : in T_arbre);


	Function Acces_parcours_infixe (parcours_infixe : in T_parcours_infixe ; i : in integer) return integer;


	Function Acces_tab_feuilles (tab_feuilles : in T_tab_feuilles ; i : in integer) return integer;


private
	type T_parcours_infixe 	is array (1..lng_parcours_infixe + 1) 	of T_bit;
	type T_tab_feuilles 	is array (1..lng_tab_feuilles) 		of T_byte;

end decode;
