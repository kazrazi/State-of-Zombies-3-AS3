package 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Settings 
	{
		
		public static var sound:Number = 1;
		public static var music:Number = 1;
		
		public static var totalCoins:int = 0;
		public static var playerID:int = 1;
		public static var playerLevel:int = 1;
		public static var playerExp:int = 0;
		
		/// Прокачка уровней
		public static var playerLevels:Array = 
		[
		[500], [1000], [1500], [2000], [3000], [7000], [12000], [18000], [23000], [30000], 
		[37000], [44000], [51000], [58000], [66000], [74000], [82000], [90000], [99000], [110000], 
		[120000], [130000], [140000], [150000], [161000], [172000], [183000], [194000], [205000], [216000],
		[227000], [238000], [249000], [260000], [272000], [284000], [296000], [308000], [320000], [332000],
		[344000], [356000], [368000], [380000], [392000], [406000], [418000], [430000], [442000], [456000],
		]
		
		public static var weapPos1:Point = new Point(35, 0);
		public static var weapPos2:Point = new Point(20, -15);
		public static var weapPos3:Point = new Point(20, -15);
		
		/// оружие
		public static var weaponsXML:XML = 
		<weapons>
			<weapon id="0" slot="1" level="1" status="equipped" name="Glock" price="100" dist="4" type="pistol" pos="1" muzX="90" muzY="80" spd="8" damage="40" ammo="90"/>
			<weapon id="1" slot="1" level="3" status="closed" name="Eagle" price="300" dist="4" type="pistol" pos="1" muzX="80" muzY="80" spd="8" damage="50" ammo="90"/>
			<weapon id="2" slot="1" level="13" status="closed" name="Colt" price="3000" dist="4" type="pistol" pos="1" muzX="70" muzY="80" spd="8" damage="70" ammo="90"/>
			<weapon id="3" slot="1" level="23" status="closed" name="Kedr" price="4000" dist="4" type="pistol" pos="1" muzX="70" muzY="90" spd="5" damage="50" ammo="120"/>
			<weapon id="4" slot="1" level="33" status="closed" name="Kriss-V" price="5000" dist="4" type="pistol" pos="1" muzX="70" muzY="90" spd="5" damage="60" ammo="120"/>
			<weapon id="5" slot="3" level="6" status="closed" name="Wilson" price="800" dist="4" type="shootgun" pos="2" muzX="30" muzY="100" spd="25" damage="30" ammo="30"/>
			<weapon id="6" slot="3" level="16" status="closed" name="Benelli" price="5000" dist="4" type="shootgun" pos="2" muzX="40" muzY="100" spd="25" damage="35" ammo="40"/>
			<weapon id="7" slot="3" level="26" status="closed" name="AA-12" price="6500" dist="4" type="shootgun" pos="2" muzX="60" muzY="110" spd="20" damage="35" ammo="40"/>
			<weapon id="8" slot="3" level="36" status="closed" name="KSG" price="6200" dist="4" type="shootgun" pos="2" muzX="50" muzY="105" spd="20" damage="35" ammo="60"/>
			<weapon id="9" slot="3" level="46" status="closed" name="Spas" price="8000" dist="4" type="shootgun" pos="2" muzX="30" muzY="110" spd="20" damage="40" ammo="80"/>
			<weapon id="10" slot="2" level="4" status="closed" name="UZI" price="600" dist="4" type="riffle" pos="1" muzX="90" muzY="80" spd="4" damage="35" ammo="90"/>
			<weapon id="11" slot="2" level="14" status="closed" name="Knight" price="3500" dist="4" type="riffle" pos="1" muzX="80" muzY="85" spd="4" damage="40" ammo="90"/>
			<weapon id="12" slot="2" level="24" status="closed" name="PS-90" price="6000" dist="4" type="riffle" pos="1" muzX="70" muzY="85" spd="4" damage="45" ammo="90"/>
			<weapon id="13" slot="2" level="34" status="closed" name="MP-5" price="5500" dist="4" type="riffle" pos="1" muzX="60" muzY="85" spd="4" damage="50" ammo="160"/>
			<weapon id="14" slot="2" level="44" status="closed" name="G36" price="7000" dist="4" type="riffle" pos="1" muzX="50" muzY="85" spd="4" damage="60" ammo="160"/>
			<weapon id="15" slot="4" level="7" status="closed" name="Volcano" price="1500" dist="4" type="riffle" pos="1" muzX="50" muzY="90" spd="4" damage="40" ammo="90"/>
			<weapon id="16" slot="4" level="17" status="closed" name="M-16" price="5500" dist="4" type="riffle" pos="1" muzX="50" muzY="90" spd="4" damage="50" ammo="90"/>
			<weapon id="17" slot="4" level="27" status="closed" name="AK-47" price="6000" dist="4" type="riffle" pos="1" muzX="30" muzY="90" spd="4" damage="60" ammo="90"/>
			<weapon id="18" slot="4" level="37" status="closed" name="Steyr" price="7000" dist="4" type="riffle" pos="1" muzX="55" muzY="85" spd="4" damage="50" ammo="160"/>
			<weapon id="19" slot="4" level="47" status="closed" name="Dragon" price="9000" dist="4" type="riffle" pos="1" muzX="50" muzY="90" spd="4" damage="50" ammo="200"/>
			<weapon id="20" slot="5" level="8" status="closed" name="SVD" price="2300" dist="2" type="riffle" pos="1" muzX="50" muzY="90" spd="20" damage="190" ammo="30"/>
			<weapon id="21" slot="5" level="28" status="closed" name="Axel" price="8000" dist="4" type="napalm" pos="2" muzX="50" muzY="85" spd="10" damage="150" ammo="70"/>
			<weapon id="22" slot="5" level="38" status="closed" name="Laser" price="9000" dist="2" type="rail" pos="2" muzX="30" muzY="90" spd="20" damage="210" ammo="80"/>
			<weapon id="23" slot="5" level="18" status="closed" name="Arbalet" price="6000" dist="2" type="arbalet" pos="1" muzX="50" muzY="105" spd="15" damage="170" ammo="50"/>
			<weapon id="24" slot="5" level="48" status="closed" name="Ultras" price="10000" dist="4" type="plasma" pos="2" muzX="60" muzY="105" spd="5" damage="120" ammo="140"/>
			<weapon id="25" slot="0" level="0" status="equipped" name="Crowbar" price="100" dist="8" type="melee" pos="3" spd="20" damage="40" ammo="0"/>
			<weapon id="26" slot="0" level="10" status="closed" name="Wrench" price="900" dist="8" type="melee" pos="3" spd="25" damage="50" ammo="0"/>
			<weapon id="27" slot="0" level="20" status="closed" name="Axe" price="1800" dist="8" type="melee" pos="3" spd="30" damage="70" ammo="0"/>
			<weapon id="28" slot="0" level="30" status="closed" name="Hammer" price="2700" dist="8" type="melee" pos="3" spd="35" damage="90" ammo="0"/>
			<weapon id="29" slot="0" level="40" status="closed" name="Saw" price="3600" dist="8" type="melee" pos="3" spd="40" damage="110" ammo="0"/>
		</weapons>
		
		public static var itemsXML:XML = 
		<items>
			<item id="0" count="1" max="5" price="400"/>
			<item id="1" count="1" max="1" price="800"/>
			<item id="2" count="1" max="2" price="300"/>
			<item id="3" count="1" max="2" price="300"/>
			<item id="4" count="1" max="1" price="600"/>
			<item id="5" count="1" max="2" price="800"/>
		</items>
		
		public static var currentLevel:int = 1;
		public static var levelLenght:int = 0;
		
	}

}