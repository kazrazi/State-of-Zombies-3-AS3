package units 
{
	import etc.Blood2;
	import etc.Bullet;
	import etc.Explosion;
	import etc.Flash;
	import etc.LevelUP;
	import etc.Particle;
	import etc.Poof;
	import etc.SFX;
	import etc.TextEffect;
	import flash.geom.Point;
	import items.AirAttack;
	import items.Bonus;
	import items.Droid;
	import items.Grenade;
	import items.Shield;
	import items.Turret;
	import items.WalkerD;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.*;
	import net.flashpunk.FP;
	import ui.Cursor;
	import ui.GameStatusBar;
	import ui.GameUI;
	import ui.ItemSelect;
	import ui.PlayerBonus;
	import ui.WeapSelect;
	import ui.HealthBar;
	import etc.Hit;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Player extends Entity
	{
		// Камера
		private var cam:Entity = new Entity();
		private var camSpeed:int = 10;
		
		// Характеристики
		private var walkSpeed:Number = 4;
		public static var canWalk:Boolean = true;
		public static var walkBonus:Number = 0;
		public static var adrenBonus:Number = 1;
		public static var currentHealth:int = 100;
		public static var totalHealth:int = 100;
		
		private var isFlipped:Boolean = true;
		public static var isDeath:Boolean = false;
		private var quake:Number = 0;
		public static var playerBlock:Point = new Point();
		private var emoTimer:int = 0;
		
		public static var head:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
		private var hair:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 200, 200);
		private var body:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
		private var legs:Spritemap = new Spritemap(GFX.PLAYER1_LEGS, 100, 100);
		private var handL:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
		private var handR:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
		private var weapon:Spritemap = new Spritemap(GFX.WEAPONS, 160, 100); 
		
		private var playerID:int = 1;
		
		// Оружие
		public static var weapArray:Array = [];
		public static var weapID:int = 0;
		public static var ammoArray:Array = [];
		private var weapType:String = "pistol";
		private var weapDamage:int = 0;
		private var weapX:Number = 0;
		private var weapY:Number = 0;
		private var fireSpeed:int = 0;
		public static var fireTimer:int = 0;
		public static var powAngle:int = 0;
		
		// Итемы
		public static var itemID:int = 0;
		public static var itemArray:Array = [];
		
		// Эффекты
		private var muzzle:Spritemap = new Spritemap(GFX.MUZZ, 200, 200);
		private var muzzleSpecial:Spritemap = new Spritemap(GFX.SPECIALMUZZ, 300, 300);
		private var shadow:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		
		public static var pos:Point = new Point();
		
		private var deathTimer:int = 0;
		
		private var ammoSfx:Sfx = new Sfx(SFX.ammo);
		private var weapSfx:Sfx;
		private var sawStart:Sfx = new Sfx(SFX.sawStart);
		private var flameSfx:Sfx = new Sfx(SFX.napalm);
		
		public function Player(_x:Number = 0, _y:Number = 0, _id:int = 1) 
		{
			setHitbox(40, 60, 20, 40);
			type = "player";
			x = _x;
			y = _y;
			playerID = _id;
			playerBlock.x = GameRoom.cameraBlock.x + FP.width - 50;
			playerBlock.y = GameRoom.cameraBlock.y + FP.height - 50;
			
			// Управление
			Input.define("moving", Key.A, Key.D, Key.S, Key.W, Key.LEFT, Key.RIGHT, Key.UP, Key.DOWN);
			
			// Выспышка выстрела
			muzzle.add("pistol", [[0], [1], [2], [3]], 40, false);
			muzzle.add("shootgun", [[14], [15], [16], [17], [18], [19], [20]], 40, false);
			muzzle.add("riffle", [[7], [8], [9], [10]], 40, false);
			muzzle.blend = "hardlight";
			
			// Вспышка специального оружия
			muzzleSpecial.add("napalm", [[0], [1], [2]], 20, true);
			muzzleSpecial.scaleX = muzzleSpecial.scaleY = 0;
		}
		
		override public function added():void
		{
			FP.world.add(new WeapSelect());
			FP.world.add(new ItemSelect());
			FP.world.add(cam);
			FP.world.add(new GameUI(playerID));
			
			setImage(playerID);
			
			addGraphic(shadow);
			addGraphic(hair);
			addGraphic(handL);
			addGraphic(legs);
			addGraphic(body);
			addGraphic(head);
			addGraphic(weapon);
			addGraphic(handR);
			addGraphic(muzzle);
			addGraphic(muzzleSpecial);
			
			// Формируем список оружия
			weapArray = [];
			ammoArray = [];
			for (var i:int = 0; i < Settings.weaponsXML.weapon.length(); i++)
			{
				ammoArray[i] = [];
				if (Settings.weaponsXML.weapon[i].@status == "equipped") 
				{
					weapArray.push(i);
					ammoArray[i].push(int(Settings.weaponsXML.weapon[i].@ammo));
					ammoArray[i].push(int(Settings.weaponsXML.weapon[i].@ammo));
				}
			}
			// начальное оружие
			weapID = weapArray[0];
			
			// Формируем список итемов
			itemArray = [];
			for (var j:int = 0; j < Settings.itemsXML.item.length(); j++)
			{
				if (int(Settings.itemsXML.item[j].@count) > 0) 
				{
					itemArray.push(j);
				}
			}
			// начальный итем
			if (itemArray.length == 0) itemArray.push(0);
			itemID = itemArray[0];
			
			// начальные настройки
			canWalk = true;
			fireTimer = 0;
			powAngle = 0;
			isDeath = false;
			currentHealth = totalHealth;
			head.frame = 0;
			
			walkBonus = 0;
			adrenBonus = 1;
			PlayerBonus.bonusArray = [];
		}
		
		public static function getExp(_exp:int = 0):void
		{
			Settings.playerExp = Settings.playerExp + _exp;
			
			var exp:int = Settings.playerExp;
			var level:int = Settings.playerLevel;
			var levels:Array = Settings.playerLevels;
			
			if (levels[level-1] <= exp)
			{
				Settings.playerLevel++;
				FP.world.add(new LevelUP());
				FP.world.add(new TextEffect(0, pos.x, pos.y, "LEVEL UP"));
			}
			
		}
		
		private function setImage(_id:int = 1):void
		{
			switch(_id)
			{
				case 1:
					head = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER1_BODY, 100, 200);
					body = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
					legs = new Spritemap(GFX.PLAYER1_LEGS, 100, 100);
					handL = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
					handR = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
				break;
				case 2:
					head = new Spritemap(GFX.PLAYER2_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER2_BODY, 100, 200);
					body = new Spritemap(GFX.PLAYER2_BODY, 100, 100);
					legs = new Spritemap(GFX.PLAYER2_LEGS, 100, 100);
					handL = new Spritemap(GFX.PLAYER2_BODY, 100, 100);
					handR = new Spritemap(GFX.PLAYER2_BODY, 100, 100);
				break;
				case 3:
					head = new Spritemap(GFX.PLAYER3_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER3_BODY, 100, 200);
					body = new Spritemap(GFX.PLAYER3_BODY, 100, 100);
					legs = new Spritemap(GFX.PLAYER3_LEGS, 100, 100);
					handL = new Spritemap(GFX.PLAYER3_BODY, 100, 100);
					handR = new Spritemap(GFX.PLAYER3_BODY, 100, 100);
				break;
				case 4:
					head = new Spritemap(GFX.PLAYER4_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER4_BODY, 100, 200);
					body = new Spritemap(GFX.PLAYER4_BODY, 100, 100);
					legs = new Spritemap(GFX.PLAYER4_LEGS, 100, 100);
					handL = new Spritemap(GFX.PLAYER4_BODY, 100, 100);
					handR = new Spritemap(GFX.PLAYER4_BODY, 100, 100);
				break;
			}
			
			shadow.y = 20;
			shadow.centerOrigin();
			shadow.smooth = true;
			shadow.scale = 0.6;
			shadow.alpha = 0.4;
			
			weapon.scale = 0.8;
			weapon.smooth = true;
			
			handL.scale = 0.8;
			handL.smooth = true;
			handL.centerOrigin();
			handL.frame = 2;
			handL.y = -16;
			
			handR.scale = 0.8;
			handR.smooth = true;
			handR.centerOrigin();
			handR.frame = 2;
			handR.y = -16;
			
			head.scale = 0.8;
			head.smooth = true;
			head.centerOrigin();
			head.y = -30;
			head.originY = 70;
			
			hair.scale = 0.8;
			hair.smooth = true;
			hair.centerOrigin();
			hair.y = -30;
			hair.originY = 70;
			hair.frame = 6;
			
			body.scale = 0.8;
			body.smooth = true;
			body.centerOrigin();
			body.frame = 1;
			body.y = - 5;
			
			legs.scale = 0.8;
			legs.smooth = true;
			legs.centerOrigin();
			legs.add("stand", [[3]], 0, false);
			legs.play("stand");
			legs.add("play", [[4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19]], 30, true);
			legs.add("playback", [[19], [18], [17], [16], [15], [14], [13], [12], [11], [10], [9], [8], [7], [6], [5], [4]], 30, true);
		}
		
		private function specialSfx():void
		{
			if (GameUI.gameStatus == "play") 
			{
				muzzleSpecial.alpha = 1;
			}
			else
			{
				muzzleSpecial.alpha = 0;
				flameSfx.stop();
				sawStart.stop();
				return
			}
			
			if (weapID == 29)
			{
				if (!sawStart.playing) sawStart.play(Settings.sound * 0.3);
			}
			else
			{
				sawStart.stop();
			}
			
			if (weapType == "napalm")
			{
				if (!flameSfx.playing)
				{
					flameSfx.play(Settings.sound * 0.5);
				}
				if (Input.mouseDown) 
				{
					flameSfx.volume = Settings.sound * 0.5;
				}
				else
				{
					flameSfx.volume = Settings.sound * 0.1;
				}
			}
			else
			{
				flameSfx.stop()
			}
			
			if (isDeath)
			{
				flameSfx.stop();
				sawStart.stop();
			}
		}
		
		override public function render():void
		{
			super.render();
			if (!canWalk) legs.play("stand");
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y;
			pos.x = x;
			pos.y = y;
			
			specialSfx();
			if (!isDeath)
			{
				camera();
				muzzleflash();
				flipped();
				animation();
				openfire();
				if (canWalk) control();
				if (canWalk) useItem();
				emotion();
				
			}
			else
			{
				animation();
				animationDeath();
				flipped();
				
				deathTimer++;
				if (deathTimer > 100) FP.world.add(new GameStatusBar("gameover"));
			}
		}
		
		public function hurt(_damage:int = 0):void
		{
			currentHealth -= _damage;
			head.frame = 8;
			emoTimer = 0;
			if (currentHealth <= 0) 
			{
				isDeath = true;
				FP.world.add(new Poof(x, y - 20));
				GameUI.gameStatus = "gameover";
			}
		}
		
		private function emotion():void
		{
			if (emoTimer > 50)
			{
				head.frame = 0;
			}
			else
			{
				emoTimer++;
			}
		}
		
		private function animationDeath():void
		{
			weapon.visible = false;
			muzzle.visible = false;
			head.frame = 4;
			body.frame = 5;
			handL.frame = 6;
			handR.frame = 6;
			handR.angle = 30;
			handL.angle = 0;
			head.angle = -30;
			
			this.moveTowards( -50, y, walkSpeed / 2);
			shake();
			legs.play("play");
			
			hair.angle = head.angle;
		}
		
		private function muzzleflash():void
		{
			if (weapType == "melee") muzzle.frame = 0;
			muzzle.centerOrigin();
			muzzle.scale = 0.5;
			muzzle.smooth = true;
			isFlipped? muzzle.angle = weapon.angle: muzzle.angle = weapon.angle + 180;
			muzzle.x = weapon.x + 100 * Math.cos(muzzle.angle *  Math.PI / 180);
			muzzle.y = weapon.y - 100 * Math.sin(muzzle.angle *  Math.PI / 180);
			if (muzzle.complete) muzzle.frame = 0;
			muzzle.originX = int(Settings.weaponsXML.weapon.(@id == weapID).@muzX);
			muzzle.originY = int(Settings.weaponsXML.weapon.(@id == weapID).@muzY);
			if (isFlipped) muzzle.originY = muzzle.height - int(Settings.weaponsXML.weapon.(@id == weapID).@muzY);
			
			muzzleSpecial.x = muzzle.x;
			muzzleSpecial.y = muzzle.y;
			muzzleSpecial.smooth = true;
			muzzleSpecial.angle = weapon.angle;
			muzzleSpecial.originY = 150;
			isFlipped? muzzleSpecial.originX = 10: muzzleSpecial.originX = 290;
			isFlipped? muzzleSpecial.flipped = false: muzzleSpecial.flipped = true;
			if (weapType == "napalm")
			{
				muzzleSpecial.scaleX = muzzleSpecial.scaleY = 1;
				muzzleSpecial.play("napalm");
				muzzleSpecial.visible = true;
				muzzleSpecial.scale = 0.3;
				if ((Input.mouseDown) && (ammoArray[weapID][0] > 0))
				{
					muzzleSpecial.scale = 0.8;
				}
			}
			else
			if (weapType == "rail")
			{
				muzzleSpecial.frame = 3;
				muzzleSpecial.visible = true;
			}
			else
			{
				muzzleSpecial.visible = false;
			}
		}
		
		private function weaponSound():void
		{
			switch(weapID)
			{
				// пистолеты
				case 0:
					weapSfx = new Sfx(SFX.pistol_1);
				break;
				case 1:
					weapSfx = new Sfx(SFX.pistol_2);
				break;
				case 2:
					weapSfx = new Sfx(SFX.pistol_3);
				break;
				case 3:
					weapSfx = new Sfx(SFX.pistol_4);
				break;
				case 4:
					weapSfx = new Sfx(SFX.pistol_5);
				break;
				// дробовики
				case 5:
					weapSfx = new Sfx(SFX.shootgun_1);
				break;
				case 6:
					weapSfx = new Sfx(SFX.shootgun_2);
				break;
				case 7:
					weapSfx = new Sfx(SFX.shootgun_3);
				break;
				case 8:
					weapSfx = new Sfx(SFX.shootgun_4);
				break;
				case 9:
					weapSfx = new Sfx(SFX.shootgun_5);
				break;
				// автоматы
				case 10:
					weapSfx = new Sfx(SFX.riffle_1);
				break;
				case 11:
					weapSfx = new Sfx(SFX.riffle_2);
				break;
				case 12:
					weapSfx = new Sfx(SFX.riffle_3);
				break;
				case 13:
					weapSfx = new Sfx(SFX.riffle_4);
				break;
				case 14:
					weapSfx = new Sfx(SFX.riffle_5);
				break;
				// винтовки
				case 15:
					weapSfx = new Sfx(SFX.riffle_6);
				break;
				case 16:
					weapSfx = new Sfx(SFX.riffle_7);
				break;
				case 17:
					weapSfx = new Sfx(SFX.riffle_8);
				break;
				case 18:
					weapSfx = new Sfx(SFX.riffle_9);
				break;
				case 19:
					weapSfx = new Sfx(SFX.riffle_10);
				break;
				// специальное
				case 20:
					weapSfx = new Sfx(SFX.sniper);
				break;
				case 22:
					weapSfx = new Sfx(SFX.rail);
				break;
				case 23:
					weapSfx = new Sfx(SFX.arbalet);
				break;
				case 24:
					weapSfx = new Sfx(SFX.plasma);
				break;
				// пила
				case 29:
					weapSfx = new Sfx(SFX.saw);
				break;
				// напалм
				case 21:
					return
				break;
				default:
					weapSfx = new Sfx(SFX.melee);
			}
			
			weapSfx.play(Settings.sound * 0.3);
		}
		
		private function openfire():void
		{
			// Атака
			fireSpeed = int(Settings.weaponsXML.weapon.(@id == weapID).@spd);
			weapType = Settings.weaponsXML.weapon.(@id == weapID).@type;
			weapDamage = int(Settings.weaponsXML.weapon.(@id == weapID).@damage);
			if (fireTimer < fireSpeed)
			{
				fireTimer ++;
				if (weapType == "rail")
				{
					muzzleSpecial.scaleX = 4;
					muzzleSpecial.scaleY > 0 ? muzzleSpecial.scaleY -= 0.2: muzzleSpecial.scaleY = 0;
				}
			}
			else
			{
				if (Input.mouseDown)
				{
					var bulletAngle:int = 0;
					isFlipped? bulletAngle = weapon.angle: bulletAngle = weapon.angle + 180;
					
					if (ammoArray[weapID][0] > 0)
					{
						weaponSound();
						fireTimer = 0;
						
						if (weapType == "rail")
						{
							muzzleSpecial.scaleX = 4;
							muzzleSpecial.scaleY = 2;
						}
						
						ammoArray[weapID][0]--;
						// гильзы
						var vector:int = 1;
						isFlipped?vector = -1:vector = 1;
						var ang:int = 0;
						isFlipped? ang = weapon.angle: ang = weapon.angle + 180;
						var x1:int = x + weapon.x + 40 * (Math.cos(ang *  Math.PI / 180));
						var y1:int = y + weapon.y - 30 * (Math.sin(ang *  Math.PI / 180));
					
						if (weapType == "pistol") muzzle.play("pistol");
						if (weapType == "shootgun") muzzle.play("shootgun");
						if (weapType == "riffle") muzzle.play("riffle");
					
						var randomAngle:int = Math.random() * 10 - 5;
						// если снайперское оружие
						if ((weapID >= 20) && (weapID <= 23)) randomAngle = 0;
						// если дробовик
						
						if ((weapID >= 5) && (weapID <= 9))
						{
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle-10, weapDamage*adrenBonus));
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle-5, weapDamage*adrenBonus));
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle, weapDamage*adrenBonus));
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle+5, weapDamage*adrenBonus));
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle+10, weapDamage*adrenBonus));
						}
						
						// арбалет
						if (weapID == 23)
						{
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle+randomAngle, weapDamage*adrenBonus, weapType));
						}
						else
						if ((weapType == "plasma")||(weapType == "rail"))
						{
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle, weapDamage*adrenBonus, weapType));
							FP.world.add(new Flash(x + muzzle.x, y + muzzle.y, 1));
						}
						else
						if (weapType == "napalm")
						{
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle, weapDamage*adrenBonus, weapType));
						}
						else
						{
							FP.world.add(new Bullet(x + muzzle.x, y + muzzle.y, bulletAngle+randomAngle, weapDamage*adrenBonus, weapType));
							FP.world.add(new Flash(x + muzzle.x, y + muzzle.y, 0));
							FP.world.add(new Particle(x1, y1, isFlipped, weapType));
						}
					}
					else
					{
						// если оружие ближнего боя 
						if (weapType == "melee")
						{
							weaponSound();
							fireTimer = 0;
							FP.world.add(new Bullet(x, y, bulletAngle, weapDamage*adrenBonus, weapType));
							FP.world.add(new Bullet(x, y, bulletAngle+30, weapDamage*adrenBonus, weapType));
							FP.world.add(new Bullet(x, y, bulletAngle-30, weapDamage*adrenBonus, weapType));
						}
						else
						{
							// кончились патроны
							if(!ammoSfx.playing) ammoSfx.play(Settings.sound);
						}
					}
				}
			}
			
			// Дальний бой отдача
			if (weapType != "melee")
			{
				if (fireTimer <= 2)
				{
					powAngle -= 2;
				}
				else
				{
					powAngle < 0? powAngle+= 4: powAngle = 0;
				}
				if (weapType == "napalm") powAngle = 0;
			}
			
			// Ближний бой
			if (weapType == "melee")
			{
				// Поднимаем вверх
				if (fireTimer < 6)
				{
					if (isFlipped)
					{
						powAngle < 70?powAngle+= 20:powAngle = 70;
					}
					else
					{
						powAngle > - 70?powAngle-= 20:powAngle = -70;
					}
				}
				else // ударяем
				if ((fireTimer < 14)&&(fireTimer > 6))
				{
					if (!isFlipped)
					{
						powAngle < 70?powAngle+= 30:powAngle = 70;
					}
					else
					{
						powAngle > - 70?powAngle-= 30:powAngle = -70;
					}
				}
				else // исходное положение
				{
					if (!isFlipped)
					{
						powAngle > 0 ?powAngle -= 10:powAngle = 0;
					}
					else
					{
						powAngle < 0 ?powAngle += 10:powAngle = 0;
					}
				}
				
				var vct:int = 0;
				isFlipped?vct = -1:vct = 1;
				weapon.angle = handR.angle - 30 * vct;
			}
		}
		
		private function camera():void
		{
			// Дистанция камеры
			var dist:int = int(Settings.weaponsXML.weapon.(@id == weapID).@dist);
			// Ограничения камеры
			var camX:int = x - FP.halfWidth - (x - Cursor.posX) / dist;
			var camY:int = y - FP.halfHeight - (y - Cursor.posY) / dist;
			
			if (cam.x > GameRoom.cameraBlock.x ) cam.x = GameRoom.cameraBlock.x;
			if (cam.y > GameRoom.cameraBlock.y ) cam.y = GameRoom.cameraBlock.y;
			if (cam.x > x - 50) cam.x = x - 50;
			if (cam.x < x - FP.width + 50) cam.x = x - FP.width + 50;
			if (cam.x < 0 ) cam.x = 0;
			if (cam.y < 0 ) cam.y = 0;
			
			FP.camera.x = cam.x;
			FP.camera.y = cam.y;
			if ((WeapSelect.show)||(ItemSelect.show))
			{
				cam.moveTowards(x - FP.halfWidth, y - FP.halfHeight, camSpeed);
			}
			else
			{
				cam.moveTowards(camX, camY, camSpeed);
			}
			
			// Ограничения игрока
			if (x < 40) x = 40;
			if (y < 160) y = 160;
			if (x > playerBlock.x) x = playerBlock.x;
			if (y > playerBlock.y - 50) y = playerBlock.y - 50;
		}
		
		private function animation():void
		{
			if (isFlipped)
			{
				head.angle = -int(Math.atan2(FP.world.mouseY - y + 20, FP.world.mouseX - x + 20) * 180 / Math.PI);
				handR.angle = -int(Math.atan2(FP.world.mouseY - y + 20, FP.world.mouseX - x + 20) * 180 / Math.PI);
				if (head.angle < -40) head.angle = -40;
				if (head.angle > 40) head.angle = 40;
				
				handR.x = -10;
				handL.x = 0
				handL.y = handR.y = -16;
				
				weapon.originX = 45 - weapX;
				weapon.originY = 65 + weapY;
				
				hair.angle = head.angle;
			}
			else
			{
				head.angle = -int(Math.atan2(FP.world.mouseY - y + 20, FP.world.mouseX - x + 20) * 180 / Math.PI + 180);
				handR.angle = -int(Math.atan2(FP.world.mouseY - y + 20, FP.world.mouseX - x - 20) * 180 / Math.PI + 180);
				if ((head.angle < - 40) && (head.angle > -140)) head.angle = -40;
				if ((head.angle > - 320) && (head.angle < -240)) head.angle = -320;
				
				handR.x = 10;
				handL.x = 0
				handL.y = handR.y = -16;
				
				weapon.originX = -45 + 160 + weapX;
				weapon.originY = 65 + weapY;
				
				hair.angle = head.angle;
			}
			
			// Вращение руками и оружием
			handL.angle = handR.angle;
			weapon.angle = handR.angle;
			// Положение оружия по руке
			weapon.x = handR.x;
			weapon.y = handR.y;
			
			// Положение оружия
			weapon.frame = weapID;
			var weapPos:int = 0;
			weapPos = int(Settings.weaponsXML.weapon.(@id == weapID).@pos);
			
			// переменная отдача от выстрела
			var vec:Number = powAngle;
			!isFlipped? vec = -vec: vec = vec;
			switch(weapPos)
			{	
				case 1:
					weapX = Settings.weapPos1.x;
					weapY = Settings.weapPos1.y;
					handR.frame = 2;
					// отдача от выстрела
					handR.x += vec * Math.cos(handR.angle *  Math.PI / 180);
					handR.y -= vec * Math.sin(handR.angle *  Math.PI / 180);
					handL.x += vec * Math.cos(handR.angle *  Math.PI / 180);
					handL.y -= vec * Math.sin(handR.angle *  Math.PI / 180);
					weapon.x += vec * Math.cos(handR.angle *  Math.PI / 180);
					weapon.y -= vec * Math.sin(handR.angle *  Math.PI / 180);
				break;
				case 2:
					weapX = Settings.weapPos2.x;
					weapY = Settings.weapPos2.y;
					handR.frame = 3;
					// отдача от выстрела
					handR.x += vec * Math.cos(handR.angle *  Math.PI / 180);
					handR.y -= vec * Math.sin(handR.angle *  Math.PI / 180);
					handL.x += vec * Math.cos(handR.angle *  Math.PI / 180);
					handL.y -= vec * Math.sin(handR.angle *  Math.PI / 180);
					weapon.x += vec * Math.cos(handR.angle *  Math.PI / 180);
					weapon.y -= vec * Math.sin(handR.angle *  Math.PI / 180);
				break;
				case 3:
					weapX = Settings.weapPos2.x;
					weapY = Settings.weapPos2.y;
					handR.frame = 2;
					isFlipped? handR.angle = handL.angle - 30 + powAngle:handR.angle = handL.angle + 30 + powAngle;
					handL.angle += powAngle;
				break;
			}
			
			// если курсор наведен на игрока
			if (collide("cursor", x, y))
			{
				head.angle = hair.angle = weapon.angle = handL.angle = handR.angle = 0;
			}
		}
		
		private function flipped():void
		{
			if (!isDeath)
			{
				FP.world.mouseX > x? isFlipped = true:isFlipped = false;
			}
			else
			{
				isFlipped = false;
			}
			
			if (isFlipped)
			{
				head.flipped = true;
				hair.flipped = true;
				body.flipped = true;
				legs.flipped = true;
				handL.flipped = true;
				handR.flipped = true;
				weapon.flipped = false;
				
			}
			else
			{
				head.flipped = false;
				hair.flipped = false;
				body.flipped = false;
				legs.flipped = false;
				handL.flipped = false;
				handR.flipped = false;
				weapon.flipped = true;
				
			}
		}
		
		private function control():void
		{
			// управление игроком
			if (((Input.check(Key.A)) && (Input.check(Key.D))) || ((Input.check(Key.RIGHT)) && (Input.check(Key.LEFT)))) 
			{
				legs.play("stand");
				return
			}
			
			if ((Input.check(Key.A))||(Input.check(Key.LEFT)))
			{
				x -= (walkSpeed+walkBonus);
				if (isFlipped)
				{
					legs.play("playback");
				}
				else
				{
					legs.play("play");
				}
			}
			
			if ((Input.check(Key.D))||(Input.check(Key.RIGHT)))
			{
				x += (walkSpeed+walkBonus);
				if (isFlipped)
				{
					legs.play("play");
				}
				else
				{
					legs.play("playback");
				}
			}
			
			if ((Input.check(Key.W))||(Input.check(Key.UP)))
			{
				y -= (walkSpeed+walkBonus);
				if ((Input.check(Key.A))||(Input.check(Key.LEFT)))
				{
					if (isFlipped)
					{
						legs.play("playback");
					}
					else
					{
						legs.play("play");
					}
				}
				else
				if ((Input.check(Key.D)) || (Input.check(Key.RIGHT)))
				{
					if (isFlipped)
					{
						legs.play("play");
					}
					else
					{
						legs.play("playback");
					}
				}
				else
				{
					legs.play("play");
				}
			}
			
			if ((Input.check(Key.S))||(Input.check(Key.DOWN)))
			{
				y += (walkSpeed+walkBonus);
				if ((Input.check(Key.A))||(Input.check(Key.LEFT)))
				{
					if (isFlipped)
					{
						legs.play("playback");
					}
					else
					{
						legs.play("play");
					}
				}
				else
				if ((Input.check(Key.D)) || (Input.check(Key.RIGHT)))
				{
					if (isFlipped)
					{
						legs.play("play");
					}
					else
					{
						legs.play("playback");
					}
				}
				else
				{
					legs.play("play");
				}
			}
			
			if(!Input.check("moving"))
			{
				legs.play("stand");
			}
			else
			{
				shake();
			}
		}
		
		private function shake():void
		{
			var Dy:int = -Math.cos(quake / 10) * 3;
			body.y = Dy - 5;
			head.y = Dy - 30;
			hair.y = head.y;
			handL.y = Dy - 16;
			handR.y = Dy - 16;
			weapon.y = Dy - 16;
			quake > 1000? quake = 0: quake += walkSpeed + 1;
		}
		
		private function useItem():void
		{
			var count:int = int(Settings.itemsXML.item.(@id == itemID).@count);
			if (Input.released(Key.F))
			{
				if (count > 0)
				{
					Settings.itemsXML.item.(@id == itemID).@count = String(int(Settings.itemsXML.item.(@id == itemID).@count) - 1);
					switch(itemID)
					{
						case 0: //граната
							FP.world.add(new Grenade(x, y));
						break;
						case 1: //авиа удар
							FP.world.add(new AirAttack(x, y));
						break;
						case 2: //щит
							FP.world.add(new Shield());
						break;
						case 3:	//спрей
							FP.world.add(new Bonus(0, x, y));
						break;
						case 4: //аптечка
							FP.world.add(new Bonus(1, x, y));
						break;
						case 5:	//патроны
							FP.world.add(new Bonus(2, x, y));
						break;
					}
				}
			}
		}
		
		public function getBonus(_id:int = 0):void
		{
			var healSfx:Sfx;
			var getSfx:Sfx;
			
			if ((playerID == 1) || (playerID == 3))
			{
				healSfx = new Sfx(SFX.healMale);
			}
			else
			{
				healSfx = new Sfx(SFX.healFemale);
			}
			
			switch(_id)
			{
				case 0: // first aid
					currentHealth += totalHealth / 2;
					
					getSfx = new Sfx(SFX.spray);
					getSfx.play(Settings.sound * 0.7);
					healSfx.play(Settings.sound);
					
					FP.world.add(new TextEffect(1, pos.x, pos.y, "HEALTH"));
				break;
				case 1: // heal
					currentHealth = totalHealth;
					
					getSfx = new Sfx(SFX.pickupItem);
					getSfx.play(Settings.sound);
					healSfx.play(Settings.sound);
					
					FP.world.add(new TextEffect(1, pos.x, pos.y, "HEALTH"));
				break;
				case 2: // ammo
					for (var i:int = 0; i < ammoArray.length; i++)
					{
						ammoArray[i][0] = ammoArray[i][1];
					}
					
					getSfx = new Sfx(SFX.pickupAmmo);
					getSfx.play(Settings.sound);
					
					FP.world.add(new TextEffect(2, pos.x, pos.y, "AMMO"));
				break;
				case 3: // speed
					FP.world.add(new PlayerBonus(_id));
					
					getSfx = new Sfx(SFX.pickupItem);
					getSfx.play(Settings.sound);
					
					FP.world.add(new TextEffect(2, pos.x, pos.y, "SPEED"));
				break;
				case 4: // magnet
					FP.world.add(new PlayerBonus(_id));
					
					getSfx = new Sfx(SFX.pickupItem);
					getSfx.play(Settings.sound);
					
					FP.world.add(new TextEffect(2, pos.x, pos.y, "MAGNET"));
				break;
				case 5: // adrenaline
					FP.world.add(new PlayerBonus(_id));
					
					getSfx = new Sfx(SFX.pickupItem);
					getSfx.play(Settings.sound);
					
					FP.world.add(new TextEffect(2, pos.x, pos.y, "DAMAGE"));
				break;
			}
		}
		
	}

}