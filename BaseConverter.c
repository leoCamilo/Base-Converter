#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define TAM 16

int toDecimal(char *num,int base){
	int new_Num = 0,i,temp_Num,tam;
	
	tam = strlen(num) - 1;
	for(i = 0;num[i];i++){
		if(num[i] > 64){
			temp_Num = num[i] - 55;
		}else{
			temp_Num = num[i] - 48;
		}

		if(temp_Num < 0 && temp_Num >= base){
			return(-1);
		}else{
			new_Num += temp_Num*pow(base,tam);
			tam-=1;
		}
	}
	return(new_Num);
}

char* decimalTo(int num, int base){
	int i,temp = 0,flag = num,tam;
	char result[TAM],aux;

	for(i = 0;temp != num;i++){
		num = flag;
		temp = num % base;
		if(temp < 10){
			result[i] = temp + 48;
		}else{
			result[i] = temp + 55;
		}
		flag = num/base;
	}
	result[i] = 0;

	tam = strlen(result) - 1;
	for(i = 0;i < (tam/2 + 1);i++){
		aux = result[i];
		result[i] = result[tam-i];
		result[tam-i] = aux;
	}

	return(result);
}

void main()
{
	int num;
	char num_NC[TAM];
	
	printf("\n Digite o numero a ser convertido: ");
	scanf("%s",num_NC);

	if(num_NC[1] == 'x'){
		num = toDecimal(&num_NC[2],16);
	}else{
		if(num_NC[1] == 'b'){
			num = toDecimal(&num_NC[2],2);
		}else{
			num = toDecimal(num_NC,10);
		}
	}

	system("cls");

	if(num == -1){
		printf("\n Valor invalido! ");
	}else{
		strcpy(num_NC,decimalTo(num,16));
		printf("\n Numero convertido hexadecimal: %s\n",num_NC);
		strcpy(num_NC,decimalTo(num,2));
		printf("\n Numero convertido binario: %s\n",num_NC);
		printf("\n Numero convertido decimal: %d\n",num);
		printf("\n\n\n ");
		system("pause");
	}
}