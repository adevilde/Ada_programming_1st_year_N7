with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Arbre is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_noeud, Name => T_arbre);


	procedure Initialiser(arbre: out T_arbre) is
	begin
        arbre := null;
    end Initialiser; 


	function Est_Vide (arbre : T_arbre) return Boolean is
	begin
        if arbre = null then
            return True;
        end if;
            return False;
	end Est_Vide;


	function Terminal (arbre : T_arbre) return Boolean is
	begin
		if Est_Vide(arbre.all.branche_g) and Est_Vide(arbre.all.branche_d) then
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
			    byte 	: 	in 	T_abyte 		:= T_abyte(0) 	; 
			    freq 	: 	in 	integer 			;
			    branche_g 	: 	in 	T_arbre 			;
			    branche_d 	: 	in 	T_arbre 			) is
	begin
                if Est_Vide(arbre) then
			arbre := new T_noeud;
       		end if;
		arbre.all.byte := T_byte(byte);
                arbre.all.freq := freq;
		arbre.all.branche_g := branche_g;
		arbre.all.branche_d := branche_d;
	end Affecter;


	function Branche_g (arbre : in T_arbre) return T_arbre is
	begin
		return arbre.all.branche_g;
	end Branche_g;


	function Branche_d (arbre : in T_arbre) return T_arbre is 
	begin
		return arbre.all.branche_d;
	end Branche_d;


	function Byte_present (arbre : in T_arbre ; byte : in T_byte) return Boolean is
        tmp : T_arbre := arbre;
	begin
		if Est_Vide(arbre) then
			return False;
		elsif arbre.all.byte = byte then
			return True;
		end if;
		return Byte_present(arbre.all.branche_g, byte) or Byte_present(arbre.all.branche_d, byte);
	end Byte_present;


	function La_freq (arbre : in T_arbre) return integer is
        tmp : T_arbre := arbre;
	begin
		if not Est_Vide(arbre) then
			return arbre.all.freq;
		else
			return 0;
		end if;
		--if Est_Vide(arbe) then 
		--	return 0;
		--elsif arbre.all.byte = byte then
		--	return arbre.all.freq;
		--end if;
		--return La_freq(arbre.all.branche_g) + La_freq(arbre.all.branche_d);
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
