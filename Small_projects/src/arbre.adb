with Ada.Unchecked_Deallocation;


package body Arbre is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_noeud, Name => T_arbre);


	procedure Initialiser(arbre: out T_arbre) is
	begin
        	arbre := null;
    	end Initialiser; 


	procedure Remplire (arbre : out T_arbre) is
	begin
		arbre := new T_noeud;
	end Remplire;


	function Est_Vide (arbre : T_arbre) return Boolean is
	begin
        if arbre = null then
            return True;
        end if;
            return False;
	end Est_Vide;


	function Terminal (arbre : T_arbre) return Boolean is
	begin
		if Est_Vide(arbre) then 
			return True;
		elsif Est_Vide(arbre.all.branche_g) and Est_Vide(arbre.all.branche_d) then
			return True;
		end if;
		return False;
	end Terminal;


	function Taille (arbre : in T_arbre) return Integer is
	begin
        if Est_Vide(arbre) then
            return 0;
        end if;
        return 1 + Taille(arbre.all.branche_g) + Taille(arbre.all.branche_d);
	end Taille;

	
	procedure Affecter (arbre 	: 	in out 	T_arbre 			; 
			    byte 	: 	in 	T_byte 		:= T_byte(0) 	; 
			    freq 	: 	in 	integer 			;
			    branche_g 	: 	in 	T_arbre 			;
			    branche_d 	: 	in 	T_arbre 			) is
	begin
		
         if Est_Vide(arbre) then
			arbre := new T_noeud;
		end if;
		
		arbre.all.byte := byte;
         arbre.all.freq := freq;
		arbre.all.branche_g := branche_g;
		arbre.all.branche_d := branche_d;
		arbre.all.ff := False;
	end Affecter;


	procedure Devient_ff (arbre : out T_arbre) is
	begin
		if Est_Vide(arbre) then
			arbre := new T_noeud;
		end if;
		arbre.all.ff := True;
	end Devient_ff;


	function Est_ff (arbre : in T_arbre) return Boolean is
	begin
		if Est_Vide(arbre) then
			return False;
		end if;
		return arbre.all.ff;
	end Est_ff;


	function Branche_g (arbre : in out T_arbre) return T_arbre is
	begin
		if Est_Vide(arbre) then
			arbre := new T_noeud;
		end if;
		return arbre.all.branche_g;
	end Branche_g;


	function Branche_d (arbre : in out T_arbre) return T_arbre is 
	begin
		if Est_Vide(arbre) then
			arbre := new T_noeud;
		end if;
		return arbre.all.branche_d;
	end Branche_d;


	function Byte_present (arbre : in T_arbre ; byte : in T_byte) return Boolean is
	begin
		if Est_Vide(arbre) then
			return False;
		elsif arbre.all.byte = byte then
			return True;
		end if;
		return Byte_present(arbre.all.branche_g, byte) or Byte_present(arbre.all.branche_d, byte);
	end Byte_present;


	function La_freq (arbre : in T_arbre) return integer is
	begin
		if not Est_Vide(arbre) then
			return arbre.all.freq;
		else
			return 0;
		end if;
		return La_freq(arbre.all.branche_g) + La_freq(arbre.all.branche_d);
	end La_freq;


	function Le_byte (arbre : in T_arbre) return T_byte is
	begin
		if not Est_Vide(arbre) then
			return arbre.all.byte;
		else
			return T_byte(0);
		end if;
	end Le_byte;


	procedure Vider (arbre : in out T_arbre) is
	begin
                if not Est_Vide(arbre) then
                        Vider(arbre.all.branche_g); 
                        Vider(arbre.all.branche_d); 
                        Free(arbre);
                end if;
	end Vider;

end Arbre;
