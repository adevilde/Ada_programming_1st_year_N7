generic
	type T_message is limited private;

    
package types is

type T_trad is limited private;	
type T_tab_code is limited private;
type T_tab_branche is limited private;
type T_arbre is limited private;


procedure Initialiser_code (tab_code : out T_tab_code) with
        Post => Est_Vide (tab_code);


function Est_Vide (tab_code : T_tab_code) return Boolean;

        
procedure Changer (tab_code : in T_tab_code ; valeur : in T_trad ; indice : in Integer) with
        Pre => indice >= 1 and indice <= 256,
        Post => tab_code(indice , : ) = valeur and tab_code(indice , : )'Old /= tab_code(indice , : )'Old;
        


private

        type T_trad is array(1..8) of integer ; 
        type T_tab_code is array(1..256) of T_trad ; 
        
        type T_Noeud;
        
        type T_arbre is access T_Noeud;
        
        type T_Noeud is record 
                freq : Integer;        
                Octet : Integer;
                branche_d : T_arbre;
                branche_g : T_arbre;
        end record;
           
        type T_tab_branche is array (1..256) of T_arbre;
    
    
end types;
        
