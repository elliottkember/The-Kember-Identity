-- 
--  ada-Tobias-Birmili.adb
--  The-Kember-Identity
--  
--  created on 2009-08-13.
-- 

with Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Real_Time;
with Ada.Command_Line;
with GNAT.MD5;

procedure KemberIdentity is

	-- create global random number generator
	subtype MD5_Char_Range is Positive range 1 .. 16;
	package RN is new Ada.Numerics.Discrete_Random(MD5_Char_Range);
	G : RN.Generator;

	-- retruns a random hash
	function RandomHash return String is
		hash_chars : String := "abcdef0123456789";
		Generated  : String(1..32);
	begin
		for i in generated'Range loop
			generated(i) := hash_chars(RN.Random(G));
		end loop;
		return generated;
	end RandomHash;	
	
	input		: String(1..32);
	input_hash	: String(1..32);
	tries : Positive;
	
	start_time, end_time: Ada.Real_Time.Time;
	total_time : Duration;
	speed : Float;

	use Ada.Real_Time;
	
begin
	
	RN.Reset(G);
	tries := Integer'Value(Ada.Command_Line.Argument(1));
	start_time := Ada.Real_Time.Clock;
	
	for i in Integer range 1 .. tries loop

		input := RandomHash;
		input_hash := GNAT.MD5.Digest(input);

		if input = input_hash then
			Ada.Text_IO.Put_Line("--------------------------------------");
			Ada.Text_IO.Put_Line(" Hoooray! md5(a) == a");
			Ada.Text_IO.Put_Line(" a = " & input & "");
			Ada.Text_IO.Put_Line("--------------------------------------");
		end if;
	end loop;
		
	end_time := Ada.Real_Time.Clock;
	total_time := Ada.Real_Time.To_Duration (end_time-start_time);
	speed := Float(tries)/Float(total_time);
	
	Ada.Text_IO.Put_Line("time :" & Duration'Image(total_time) & " seconds");
	Ada.Text_IO.Put("speed: ");
	Ada.Float_Text_IO.Put(Item => speed, Fore => 5, Aft => 0, Exp => 0);
	Ada.Text_IO.Put(" hashes/s");

exception
	when CONSTRAINT_ERROR =>
		Ada.Text_IO.Put_Line("please specify number of tries as first parameter");
		
end KemberIdentity;