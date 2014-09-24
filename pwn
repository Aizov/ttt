enum TicTacToeEnum
{
	PlayerText:TicTacToeTextDraw[37],		// ТекстДравы
	StatusTicTacToe[37],					// Для информации о занятых клетках
	Moves,									// Ходы
	Move,									// Кто ходит
	Bet,									// Кто ходит
	Opponent,								// Опонент
	Who										// Кто крестик и кто нолик
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
CMD:ttt(playerid,params[])					// Команда предложения игры
{
	new idplayer,bet;
	if(sscanf(params,"dd",idplayer,bet))return SCM(playerid,-1,"Введите /ttt [id игрока] [ставка]");
	if(idplayer == playerid) return SCM(playerid,-1,"Нельзя играть с самим собой");
	TicTacToe[playerid][Move] = 1; 			// Даём первый ход тому кто предложил
	TicTacToe[playerid][Bet] = bet;			// Записываем ставку в переменную игрока
	TicTacToe[idplayer][Bet] = bet;			// Записываем ставку в переменную оппонента
	SelectTextDraw(playerid, -1);			// Показываем курсор
	TicTacToe[playerid][Opponent]=idplayer; // Записываем опонентов игроку
	TicTacToe[idplayer][Opponent]=playerid;	// Записываем опонентов противнику
	TicTacToe[idplayer][Who] = 1;			// Даём крестик противнику
	LoadTTT(playerid);						// Загружаем текстдравы игроку
	LoadTTT(idplayer);						// Загружаем текстдравы противнику
	for(new i;i<17;i++)PlayerTextDrawShow(playerid,TicTacToe[playerid][TicTacToeTextDraw][i]);	//Показываем текстдравы игроку
	for(new i;i<17;i++)PlayerTextDrawShow(idplayer,TicTacToe[idplayer][TicTacToeTextDraw][i]);	//Показываем текстдравы противнику
	return true;
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
			if(TicTacToe[playerid][Who] == 0)PlayerTextDrawShow(playerid,TicTacToe[playerid][TicTacToeTextDraw][i+16]),PlayerTextDrawShow(TicTacToe[playerid][Opponent],TicTacToe[playerid][TicTacToeTextDraw][i+16]),TicTacToe[playerid][StatusTicTacToe][i+16] = 2; //  0								 // После нажатия ставим нолик 
			if(TicTacToe[playerid][Who] == 1)PlayerTextDrawShow(playerid,TicTacToe[playerid][TicTacToeTextDraw][i+25]),PlayerTextDrawShow(TicTacToe[playerid][Opponent],TicTacToe[playerid][TicTacToeTextDraw][i+25]),TicTacToe[playerid][StatusTicTacToe][i+25] = 1; // X								 // После нажатия ставим крестик 
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
			new ttick;
			TicTacToe[TicTacToe[playerid][Opponent]][Move] = 1;					// Даём ход противнику
			SelectTextDraw(TicTacToe[playerid][Opponent],-1);					// Показываем ему курсор
			for(new z=1;z< 10;z++)
			{
				if(ttick > 8) return SCM(playerid,-1,"Ничья"),SCM(TicTacToe[playerid][Opponent],-1,"Ничья"),FFFToNull(playerid), ttick = 0;
				if(TicTacToe[playerid][StatusTicTacToe][z] != 0) ttick ++;
				SCM(playerid,-1,"Ничья");
				SCM(TicTacToe[playerid][Opponent],-1,"Ничья");
				FFFToNull(playerid);
			}
			if(TicTacToe[playerid][Moves] > 2)
			{
				new result;
				// Быдлоскриптер - начало
				for(new p = 0; p < sizeof(TTTwin); p++)
				{
					if(TicTacToe[playerid][StatusTicTacToe][TTTwin[p][0]] != 0 && TicTacToe[playerid][StatusTicTacToe][TTTwin[p][1]] != 0 && TicTacToe[playerid][StatusTicTacToe][TTTwin[p][2]] != 0)result = 1;
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
		TicTacToe[playerid][Bet] = 0;
		TicTacToe[TicTacToe[playerid][Opponent]][Bet] = 0;
	}
}
//---------------------------------------------------------------------------------------------------
LoadTTT(playerid) // Загружаем tic-tac-toe
{
	new string[128];
	TicTacToe[playerid][TicTacToeTextDraw][0] = CreatePlayerTextDraw(playerid, 260.371612, 274.499908, "usebox");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0.000000, 18.319177);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 2.216759, 0.000000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0);
	PlayerTextDrawUseBox(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], true);
	PlayerTextDrawBoxColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 102);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][0], 0);

	TicTacToe[playerid][TicTacToeTextDraw][1] = CreatePlayerTextDraw(playerid, 15.118629, 283.749938, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][1], true);



	TicTacToe[playerid][TicTacToeTextDraw][2] = CreatePlayerTextDraw(playerid, 67.530036, 283.916595, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][2], true);

	TicTacToe[playerid][TicTacToeTextDraw][3] = CreatePlayerTextDraw(playerid, 120.067359, 283.749908, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][3], true);

	TicTacToe[playerid][TicTacToeTextDraw][4] = CreatePlayerTextDraw(playerid, 15.181568, 334.333282, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][4], true);

	TicTacToe[playerid][TicTacToeTextDraw][5] = CreatePlayerTextDraw(playerid, 67.718894, 335.333282, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][5], true);

	TicTacToe[playerid][TicTacToeTextDraw][6] = CreatePlayerTextDraw(playerid, 120.256217, 335.749908, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][6], true);

	TicTacToe[playerid][TicTacToeTextDraw][7] = CreatePlayerTextDraw(playerid, 15.370445, 383.416656, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][7], true);

	TicTacToe[playerid][TicTacToeTextDraw][8] = CreatePlayerTextDraw(playerid, 67.907768, 384.999938, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][8], true);

	TicTacToe[playerid][TicTacToeTextDraw][9] = CreatePlayerTextDraw(playerid, 119.508049, 385.416564, "ld_drv:tvbase");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 44.509521, 42.583312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], 1);
	PlayerTextDrawSetSelectable(playerid, TicTacToe[playerid][TicTacToeTextDraw][9], true);

	TicTacToe[playerid][TicTacToeTextDraw][10] = CreatePlayerTextDraw(playerid, 182.254760, 272.999755, "Opponent");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 0);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][10], 1);

	TicTacToe[playerid][TicTacToeTextDraw][11] = CreatePlayerTextDraw(playerid, 183.254760, 273.999725, "Opponent");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 0);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][11], 1);

	GetPlayerName(TicTacToe[playerid][Opponent],string,24);
	TicTacToe[playerid][TicTacToeTextDraw][12] = CreatePlayerTextDraw(playerid, 173.010253, 295.999816, string);
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 2);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 1);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][12], 1);

	format(string,sizeof(string),"Bet: %d",TicTacToe[playerid][Bet]);
	TicTacToe[playerid][TicTacToeTextDraw][13] = CreatePlayerTextDraw(playerid, 173.352844, 319.666534, string);
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 0.388622, 1.967497);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], -2147483393);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 1);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 2);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][13], 1);

	TicTacToe[playerid][TicTacToeTextDraw][14] = CreatePlayerTextDraw(playerid, 174.352844, 320.666534, "Bet");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 0.388622, 1.967497);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], -2147483393);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][14], 0);
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
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 51);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][15], 1);

	if(TicTacToe[playerid][Who] == 0)TicTacToe[playerid][TicTacToeTextDraw][16] = CreatePlayerTextDraw(playerid, 186.002899, 390.250000, "ld_beat:circle"); // 0
	if(TicTacToe[playerid][Who] == 1)TicTacToe[playerid][TicTacToeTextDraw][16] = CreatePlayerTextDraw(playerid, 186.002899, 390.250000, "ld_beat:cross"); // X
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 43.103958, 39.083312);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 4);
	PlayerTextDrawSetProportional(playerid, TicTacToe[playerid][TicTacToeTextDraw][16], 1);

	TicTacToe[playerid][TicTacToeTextDraw][17] = CreatePlayerTextDraw(playerid, 56.691116, 323.750030, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][17], 4);

	TicTacToe[playerid][TicTacToeTextDraw][18] = CreatePlayerTextDraw(playerid, 108.291397, 323.583343, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][18], 4);

	TicTacToe[playerid][TicTacToeTextDraw][19] = CreatePlayerTextDraw(playerid, 161.297241, 323.416656, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][19], 4);

	TicTacToe[playerid][TicTacToeTextDraw][20] = CreatePlayerTextDraw(playerid, 56.879989, 375.166656, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][20], 4);

	TicTacToe[playerid][TicTacToeTextDraw][21] = CreatePlayerTextDraw(playerid, 108.480270, 374.999969, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][21], 4);

	TicTacToe[playerid][TicTacToeTextDraw][22] = CreatePlayerTextDraw(playerid, 161.486114, 375.999969, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][22], 4);

	TicTacToe[playerid][TicTacToeTextDraw][23] = CreatePlayerTextDraw(playerid, 57.068862, 423.666656, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][23], 4);

	TicTacToe[playerid][TicTacToeTextDraw][24] = CreatePlayerTextDraw(playerid, 108.669143, 424.666656, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][24], 4);

	TicTacToe[playerid][TicTacToeTextDraw][25] = CreatePlayerTextDraw(playerid, 161.206466, 425.666595, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], -37.950225, -36.750072);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][25], 4);

	TicTacToe[playerid][TicTacToeTextDraw][26] = CreatePlayerTextDraw(playerid, 19.209426, 287.583435, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][26], 4);

	TicTacToe[playerid][TicTacToeTextDraw][27] = CreatePlayerTextDraw(playerid, 70.809715, 286.833404, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][27], 4);

	TicTacToe[playerid][TicTacToeTextDraw][28] = CreatePlayerTextDraw(playerid, 124.752609, 286.666717, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][28], 4);

	TicTacToe[playerid][TicTacToeTextDraw][29] = CreatePlayerTextDraw(playerid, 19.398303, 337.833312, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][29], 4);

	TicTacToe[playerid][TicTacToeTextDraw][30] = CreatePlayerTextDraw(playerid, 70.998596, 338.249969, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][30], 4);

	TicTacToe[playerid][TicTacToeTextDraw][31] = CreatePlayerTextDraw(playerid, 124.004440, 339.249938, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][31], 4);

	TicTacToe[playerid][TicTacToeTextDraw][32] = CreatePlayerTextDraw(playerid, 19.118652, 386.916625, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][32], 4);

	TicTacToe[playerid][TicTacToeTextDraw][33] = CreatePlayerTextDraw(playerid, 71.187454, 387.333282, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][33], 4);

	TicTacToe[playerid][TicTacToeTextDraw][34] = CreatePlayerTextDraw(playerid, 123.724777, 388.916564, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 37.013179, 37.333343);
	PlayerTextDrawAlignment(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 1);
	PlayerTextDrawColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], -1);
	PlayerTextDrawSetShadow(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 0);
	PlayerTextDrawSetOutline(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 0);
	PlayerTextDrawBackgroundColor(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 0x00000000);
	PlayerTextDrawFont(playerid, TicTacToe[playerid][TicTacToeTextDraw][34], 4);
}
//---------------------------------------------------------------------------------------------------
