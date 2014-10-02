enum TicTacToeEnum
{
	PlayerText:TicTacToeTextDraw[37],
	StatusTicTacToe[37],
	Moves,									// Ходы
	Move,									// Кто ходит
	Bet,									// Кто ходит
	Opponent,								// Опонент
	Who,									// Кто крестик а кто нолик
	Accept,									// Переменная для подтверждения
	Gamed									// Играет ли он
}
new TicTacToe[MAX_PLAYERS][TicTacToeEnum];
new TTTwin[8][3] =
{
	{1, 2, 3},
	{4, 5, 6},
	{7, 8, 9},
	{1, 4, 7},
	{2, 5, 8},
	{3, 6, 9},
	{1, 5, 9},
	{3, 5, 7}
};
//---------------------------------------------------------------------------------------------------
CMD:ttt(playerid,params[])
{
	new idplayer,bet,string[128],name[25];
	if(sscanf(params,"dd",idplayer,bet))return SCM(playerid,-1,"Введите /ttt [id игрока] [ставка]");
	if(playerid == idplayer) return SCM(playerid,-1,"Вы не можете играть с самим собой");
	if(TicTacToe[playerid][Gamed] != 0) return SCM(playerid,-1,"Вы уже играете");
	if(TicTacToe[idplayer][Gamed] != 0) return SCM(playerid,-1,"Игрок уже играет");
	if(TicTacToe[idplayer][Accept] != 0) return SCM(playerid,-1,"Игроку уже предложили играть");
	if(TicTacToe[playerid][Accept] != 0) return SCM(playerid,-1,"Вы уже предложили кому-то сыграть");
	TicTacToe[idplayer][Opponent] = playerid;
	TicTacToe[playerid][Bet] = bet;
	TicTacToe[idplayer][Bet] = bet;
	GetPlayerName(playerid,name,sizeof(name));
	format(string,sizeof(string),"%s предложил вам сыграть в крестики-нолики. Ставка: %d",name,bet);
	SCM(idplayer,-1,string);
	SCM(idplayer,-1,"Нажмите  Y для принятия, N для отмены");
	GetPlayerName(idplayer,name,sizeof(name));
	format(string,sizeof(string),"Вы предложили %s сыграть в крестики-нолики. Ставка: %d",name,bet);
	SCM(playerid,-1,string);
	TicTacToe[idplayer][Accept] = 1;
	return true;
}
//---------------------------------------------------------------------------------------------------
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 65536)//Yes
	{
		if(TicTacToe[playerid][Accept] == 1)
		{
			TicTacToe[playerid][Move] = 1;
			SelectTextDraw(playerid, -1);
			TicTacToe[TicTacToe[playerid][Opponent]][Opponent] = playerid;
			TicTacToe[TicTacToe[playerid][Opponent]][Accept] = 0;
			TicTacToe[playerid][Accept] = 0;
			TicTacToe[TicTacToe[playerid][Opponent]][Who] = 1;
			TicTacToe[playerid][Gamed] = 1;
			TicTacToe[TicTacToe[playerid][Opponent]][Gamed] = 1;
			LoadTTT(playerid);
			LoadTTT(TicTacToe[playerid][Opponent]);
			GetPlayerName(TicTacToe[playerid][Opponent],name,sizeof(name));
			format(string,sizeof(string),"Вы приняли предложение от %s. Ставка: %d",name,TicTacToe[playerid][Bet]);
			SCM(playerid,-1,string);
			GetPlayerName(playerid,name,sizeof(name));
			format(string,sizeof(string),"%s принял ваше предложение. Ставка: %d",name,TicTacToe[playerid][Bet]);
			SCM(TicTacToe[playerid][Opponent],-1,string);
			for(new i;i<17;i++)PlayerTextDrawShow(playerid,TicTacToe[playerid][TicTacToeTextDraw][i]);
			for(new i;i<17;i++)PlayerTextDrawShow(TicTacToe[playerid][Opponent],TicTacToe[TicTacToe[playerid][Opponent]][TicTacToeTextDraw][i]);
		}	
	}
	if(newkeys == 131072)//No
	{
		if(TicTacToe[playerid][Accept] == 1)
		{
			GetPlayerName(TicTacToe[playerid][Opponent],name,sizeof(name));
			format(string,sizeof(string),"Вы отказались от предложения %s",name);
			SCM(playerid,-1,string);
			GetPlayerName(playerid,name,sizeof(name));
			format(string,sizeof(string),"%s отказался от вашего предложения",name);
			SCM(TicTacToe[playerid][Opponent],-1,string);
			TicTacToe[playerid][Opponent] = 0;
			TicTacToe[playerid][Bet] = 0;
			TicTacToe[playerid][Accept] = 0;
			TicTacToe[TicTacToe[playerid][Opponent]][Opponent] = 0;
			TicTacToe[TicTacToe[playerid][Opponent]][Bet] = 0;
		}
	}
}
//---------------------------------------------------------------------------------------------------
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new string[128];
	for(new i = 1;i< 10;i++) if(playertextid == TicTacToe[playerid][TicTacToeTextDraw][i])
	{
		if(TicTacToe[playerid][Move] == 1)
		{
			if(TicTacToe[playerid][StatusTicTacToe][i] == 1 || TicTacToe[playerid][StatusTicTacToe][i] ==  2 || TicTacToe[TicTacToe[playerid][Opponent]][StatusTicTacToe][i] == 1 || TicTacToe[TicTacToe[playerid][Opponent]][StatusTicTacToe][i] ==  2) return SCM(playerid,-1,"Эта клетка уже занята");// 1 - X , 2 - 0
			if(TicTacToe[playerid][Who] == 0)PlayerTextDrawShow(playerid,TicTacToe[playerid][TicTacToeTextDraw][i+16]),PlayerTextDrawShow(TicTacToe[playerid][Opponent],TicTacToe[playerid][TicTacToeTextDraw][i+16]),TicTacToe[playerid][StatusTicTacToe][i] = 2; //  0								 // После нажатия ставим нолик 
			if(TicTacToe[playerid][Who] == 1)PlayerTextDrawShow(playerid,TicTacToe[playerid][TicTacToeTextDraw][i+25]),PlayerTextDrawShow(TicTacToe[playerid][Opponent],TicTacToe[playerid][TicTacToeTextDraw][i+25]),TicTacToe[playerid][StatusTicTacToe][i] = 1; // X								 // После нажатия ставим крестик 
			TicTacToe[playerid][Moves] += 1;																				// Прибаляем 1 к ходу
			TicTacToe[playerid][Move] = 0;																					// Прекращаем ход игрока
			CancelSelectTextDraw(playerid);																					// Забираем курсор
			//
			PlayerTextDrawHide(playerid,TicTacToe[playerid][TicTacToeTextDraw][15]);
			PlayerTextDrawDestroy(playerid,TicTacToe[playerid][TicTacToeTextDraw][15]);
			format(string,sizeof(string),"Moves: %d",TicTacToe[playerid][Moves]);
			TicTacToe[playerid][TicTacToeTextDraw][15] = CreatePlayerTextDraw(playerid, 180.849182, 354.083190, string);
			PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 0.449999, 1.600000);
			PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 30.453874, 12.833333);
			PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);
			PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], -2147450625);
			PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], -2);
			PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 0);
			PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 51);
			PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);
			PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);
			PlayerTextDrawShow(playerid, TicTacToe[playerid][TicTacToeTextDraw][15]);
			
			//
			TicTacToe[TicTacToe[playerid][Opponent]][Move] = 1;					// Даём ход противнику
			SelectTextDraw(TicTacToe[playerid][Opponent],-1);					// Показываем ему курсор
			new result,tuck;
			for(new p = 0; p < sizeof(TTTwin); p++)
			{
				if(TicTacToe[playerid][StatusTicTacToe][TTTwin[p][0]] == TicTacToe[playerid][StatusTicTacToe][TTTwin[p][1]] && TicTacToe[playerid][StatusTicTacToe][TTTwin[p][1]] == TicTacToe[playerid][StatusTicTacToe][TTTwin[p][2]] && TicTacToe[playerid][StatusTicTacToe][TTTwin[p][2]] != 0)result = 1;
			}	
			if(result == 1)
			{
				format(string,sizeof(string),"Вы победили и получили $%d",TicTacToe[playerid][Bet]);
				SCM(playerid,-1,string);
				Player[playerid][Money] += TicTacToe[playerid][Bet];
				format(string,sizeof(string),"Вы проиграли и потеряли $%d",TicTacToe[TicTacToe[playerid][Opponent]][Bet]);
				Player[TicTacToe[playerid][Opponent]][Money] -= TicTacToe[TicTacToe[playerid][Opponent]][Bet];
				SCM(TicTacToe[playerid][Opponent],-1,string);
				FFFToNull(playerid);
				FFFToNull(TicTacToe[playerid][Opponent]);
			}
			for(new k;k< 9;k++)
			{
				if(TicTacToe[playerid][StatusTicTacToe][k] != 0) tuck ++;
				if(tuck >4) SCM(playerid,-1,"Ничья"),SCM(TicTacToe[playerid][Opponent],-1,"Ничья"),FFFToNull(playerid);
			}
		}
	}
}
//---------------------------------------------------------------------------------------------------
stock FFFToNull(playerid)
{
	for(new y;y<35;y++)
	{
		PlayerTextDrawHide(playerid,TicTacToe[playerid][TicTacToeTextDraw][y]);
		PlayerTextDrawDestroy(playerid,TicTacToe[playerid][TicTacToeTextDraw][y]);
		PlayerTextDrawHide(TicTacToe[playerid][Opponent],TicTacToe[TicTacToe[playerid][Opponent]][TicTacToeTextDraw][y]);
		PlayerTextDrawDestroy(TicTacToe[playerid][Opponent],TicTacToe[TicTacToe[playerid][Opponent]][TicTacToeTextDraw][y]);	
		TicTacToe[playerid][StatusTicTacToe][y] = 0;
		TicTacToe[TicTacToe[playerid][Opponent]][StatusTicTacToe][y] = 0;
	}
	TicTacToe[playerid][Bet] = 0;
	TicTacToe[TicTacToe[playerid][Opponent]][Bet] = 0;
	TicTacToe[TicTacToe[playerid][Opponent]][Move] = 0;
	TicTacToe[playerid][Move] = 0;
	CancelSelectTextDraw(playerid);
	CancelSelectTextDraw(TicTacToe[playerid][Opponent]);
	TicTacToe[playerid][Gamed] = 0;
	TicTacToe[playerid][Who] = 0;
	TicTacToe[TicTacToe[playerid][Opponent]][Who] = 0;
	TicTacToe[TicTacToe[playerid][Opponent]][Gamed] = 0;
	return true;
}
//---------------------------------------------------------------------------------------------------
LoadTTT(playerid) // Загружаем tic-tac-toe
{
	new string[128];
	TicTacToe[playerid][TicTacToeTextDraw][0] = CreatePlayerTextDraw(playerid, 260.371612, 274.499908, "usebox");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0.000000, 18.319177);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 2.216759, 0.000000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 1);
	PlayerTextDrawUseBox(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], true);
	PlayerTextDrawBoxColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 102);

	TicTacToe[playerid][TicTacToeTextDraw][1] = CreatePlayerTextDraw(playerid, 15.118629, 283.749938, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][2] = CreatePlayerTextDraw(playerid, 67.530036, 283.916595, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][3] = CreatePlayerTextDraw(playerid, 120.067359, 283.749908, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][4] = CreatePlayerTextDraw(playerid, 15.181568, 334.333282, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][5] = CreatePlayerTextDraw(playerid, 67.718894, 335.333282, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][6] = CreatePlayerTextDraw(playerid, 120.256217, 335.749908, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][7] = CreatePlayerTextDraw(playerid, 15.370445, 383.416656, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][8] = CreatePlayerTextDraw(playerid, 67.907768, 384.999938, "ld_drv:tvbase");
	TicTacToe[playerid][TicTacToeTextDraw][9] = CreatePlayerTextDraw(playerid, 119.508049, 385.416564, "ld_drv:tvbase");
	
	TicTacToe[playerid][TicTacToeTextDraw][10] = CreatePlayerTextDraw(playerid, 182.254760, 272.999755, "Opponent");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], -1);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 51);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 1);

	TicTacToe[playerid][TicTacToeTextDraw][11] = CreatePlayerTextDraw(playerid, 183.254760, 273.999725, "Opponent");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], -1);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 51);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 1);

	GetPlayerName(TicTacToe[playerid][Opponent],string,24);
	TicTacToe[playerid][TicTacToeTextDraw][12] = CreatePlayerTextDraw(playerid, 173.010253, 295.999816, string);
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], -1);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 2);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 1);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 1);

	format(string,sizeof(string),"Bet: %d",TicTacToe[playerid][Bet]);
	TicTacToe[playerid][TicTacToeTextDraw][13] = CreatePlayerTextDraw(playerid, 173.352844, 319.666534, string);
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 0.388622, 1.967497);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], -2147483393);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 2);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 1);

	TicTacToe[playerid][TicTacToeTextDraw][14] = CreatePlayerTextDraw(playerid, 174.352844, 320.666534, "Bet");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 0.388622, 1.967497);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], -2147483393);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 2);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 1);

	format(string,sizeof(string),"Move: %d",TicTacToe[playerid][Move]);
	TicTacToe[playerid][TicTacToeTextDraw][15] = CreatePlayerTextDraw(playerid, 180.849182, 354.083190, string);
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 30.453874, 12.833333);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], -2147450625);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], -2);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);

	if(TicTacToe[playerid][Who] == 0)TicTacToe[playerid][TicTacToeTextDraw][16] = CreatePlayerTextDraw(playerid, 186.002899, 390.250000, "ld_beat:circle"); // 0
	if(TicTacToe[playerid][Who] == 1)TicTacToe[playerid][TicTacToeTextDraw][16] = CreatePlayerTextDraw(playerid, 186.002899, 390.250000, "ld_beat:cross"); // X
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 43.103958, 39.083312);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 1);

	TicTacToe[playerid][TicTacToeTextDraw][17] = CreatePlayerTextDraw(playerid, 56.691116, 323.750030, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][18] = CreatePlayerTextDraw(playerid, 108.291397, 323.583343, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][19] = CreatePlayerTextDraw(playerid, 161.297241, 323.416656, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][20] = CreatePlayerTextDraw(playerid, 56.879989, 375.166656, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][21] = CreatePlayerTextDraw(playerid, 108.480270, 374.999969, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][22] = CreatePlayerTextDraw(playerid, 161.486114, 375.999969, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][23] = CreatePlayerTextDraw(playerid, 57.068862, 423.666656, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][24] = CreatePlayerTextDraw(playerid, 108.669143, 424.666656, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][25] = CreatePlayerTextDraw(playerid, 161.206466, 425.666595, "ld_beat:circle");
	TicTacToe[playerid][TicTacToeTextDraw][26] = CreatePlayerTextDraw(playerid, 19.209426, 287.583435, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][27] = CreatePlayerTextDraw(playerid, 70.809715, 286.833404, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][28] = CreatePlayerTextDraw(playerid, 124.752609, 286.666717, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][29] = CreatePlayerTextDraw(playerid, 19.398303, 337.833312, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][30] = CreatePlayerTextDraw(playerid, 70.998596, 338.249969, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][31] = CreatePlayerTextDraw(playerid, 124.004440, 339.249938, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][32] = CreatePlayerTextDraw(playerid, 19.118652, 386.916625, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][33] = CreatePlayerTextDraw(playerid, 71.187454, 387.333282, "ld_beat:cross");
	TicTacToe[playerid][TicTacToeTextDraw][34] = CreatePlayerTextDraw(playerid, 123.724777, 388.916564, "ld_beat:cross");
	for(new i=1;i<35;i++)
	{
		//1
		if(i>0&&i<11)
		{
			PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 44.509521, 42.583312);
			PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 4);
			PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], true);
		}
		//10
		if(i>16&&i<26)
		{//17
			PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], -37.950225, -36.750072);
			PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 4);
		}//25
		if(i>25&&i<35)
		{
			PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 37.013179, 37.333343);
			PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 4);
			PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 1);
			PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][i], 1);
		}
	}
}
//---------------------------------------------------------------------------------------------------
