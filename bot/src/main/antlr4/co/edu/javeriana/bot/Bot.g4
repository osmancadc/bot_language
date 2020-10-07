grammar Bot;

@header {

import org.jpavlich.bot.*;

}

@parser::members {

private Bot bot;

public BotParser(TokenStream input, Bot bot) {
    this(input);
    this.bot = bot;
}

}



program: 
	comment* 
	DEFINE MAIN OPEN_PARENTESIS parameters CLOSE_PARENTESIS START_FUNCTION 
		sentence*	
	END
;
parameters: PARAMETER* | PARAMETER','PARAMETER ;
sentence:
	comment | move_up | move_down | move_left | move_right | pick_star | drop_star
;
comment:  
	COMMENT_BODY
;
move_up:
	GO_UP expression SEMICOLON
	{bot.up((int)$expression.value);}
;
move_down:
	GO_DOWN expression SEMICOLON
	{bot.down((int)$expression.value);}
;
move_left:
	LESS_LEFT expression SEMICOLON
	{bot.left((int)$expression.value);}
;
move_right:
	GREAT_RIGHT expression SEMICOLON
	{bot.right((int)$expression.value);}
;
pick_star:
	PICK SEMICOLON
	{
		bot.pick();
		System.out.println("Nuevo iventario ->"+bot.inventory());
	}
;
drop_star:
	DROP SEMICOLON
	{
		bot.drop();
		System.out.println("Nuevo iventario ->"+bot.inventory());
	}
;

expression returns [Object value]: 
	NUMBER {$value = Integer.parseInt($NUMBER.text);}
	| 
	ID {$value = $ID.text;} 
;

// Los tokens se escriben a continuación de estos comentarios.
// Todo lo que esté en líneas previas a lo modificaremos cuando hayamos visto Análisis Sintáctico
MAIN: 'main';
EMPTY: [\s];
GO_UP:[^];
GO_DOWN:[Vv];
GREAT_RIGHT:'>';
LESS_LEFT:'<';
PICK:[Pp];
DROP:[Dd];
DEFINE:'define';
END:'end';
START_FUNCTION:'->';
NUMBER:[0-9];
ID : [A-za-z_][a-zA-Z0-9_]*;
OPEN_PARENTESIS:'(';
CLOSE_PARENTESIS:')';
PARAMETER: ['\''][a-zA-Z0-9_]+;
SEMICOLON:';';
COMMENT_BODY: '#' ~( '\r' | '\n' )*;

WS
:
	[ \t\r\n]+ -> skip
;