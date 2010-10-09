
int chars [26][6][6] = {
{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 0, 1},
	{1, 1, 0, 0, 0, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 0}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 0, 0, 0}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 0, 1},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 1, 1, 1},
	{1, 1, 0, 0, 1, 0},
	{1, 1, 1, 1, 1, 0}
},

{
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0},
	{1, 1, 1, 1, 0, 0}
},

{
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 1, 1, 0},
	{1, 1, 1, 1, 0, 0},
	{1, 1, 1, 1, 0, 0},
	{1, 1, 0, 1, 1, 0},
	{1, 1, 0, 0, 1, 1}
},

{
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 0, 1, 1, 0, 1},
	{1, 0, 1, 1, 0, 1},
	{1, 0, 1, 1, 0, 1},
	{1, 0, 1, 1, 0, 1}
},

{
	{1, 0, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 1, 0, 1, 1},
	{1, 1, 0, 1, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 0, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 0, 0, 0, 0},
	{1, 1, 0, 0, 0, 0}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 1},
	{1, 0, 0, 1, 0, 1},
	{1, 0, 0, 0, 1, 0},
	{1, 1, 1, 1, 0, 1}
},

{
	{1, 1, 1, 1, 1, 0},
	{1, 1, 0, 1, 1, 0},
	{1, 1, 0, 1, 1, 0},
	{1, 1, 1, 1, 0, 0},
	{1, 1, 0, 0, 1, 0},
	{1, 1, 0, 0, 0, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 0},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0}
},

{
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 0, 0, 1, 1},
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{1, 0, 0, 0, 0, 1},
	{1, 1, 0, 0, 1, 1},
	{0, 1, 0, 0, 1, 0},
	{0, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 0, 0}
},

{
	{1, 1, 0, 0, 1, 1},
	{1, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 1},
	{1, 0, 1, 1, 0, 1},
	{1, 0, 1, 1, 0, 1},
	{0, 1, 0, 0, 1, 0}
},

{
	{1, 1, 0, 0, 1, 1},
	{0, 1, 0, 0, 1, 0},
	{0, 0, 1, 1, 0, 0},
	{0, 0, 1, 1, 0, 0},
	{0, 1, 0, 0, 1, 0},
	{1, 1, 0, 0, 1, 1}
},

{
	{1, 1, 0, 0, 1, 1},
	{0, 1, 0, 0, 1, 0},
	{0, 0, 1, 1, 0, 0},
	{0, 1, 1, 0, 0, 0},
	{1, 1, 0, 0, 0, 0},
	{1, 0, 0, 0, 0, 0}
},

{
	{1, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 0},
	{0, 0, 0, 1, 0, 0},
	{0, 0, 1, 0, 0, 0},
	{0, 1, 1, 1, 1, 1},
	{1, 1, 1, 1, 1, 1}
},

{
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0}
}

};

char letters[27] = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z', ' '};