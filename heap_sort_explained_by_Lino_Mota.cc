#include <iostream>

using std::cout;
using std::cin;

//author: Lino Mota
//email : linomota0@gmail.com

//heap sort precisa de 3 algoritmos pra funcionar

//1) Montar heap ajusta o vetor inteiro para a propriedade de heap, fazendo diversas
//chamadas da função 2.
void montar_heap(int * array, int tamanho);

//2) Heapify é a função que ajusta a propriedade de heap em uma posição x do vetor
void heapify(int * array, int tamanho, int pos);

//3) Heap sort que finalmente usa dessas funcões acima para funcionar
void heap_sort(int * array, int tamanho);

//ultilitárias
void imprimir_vetor(int * array, int tamanho);
void trocar(int * array, int posA, int posB);


void montar_heap(int * array, int tamanho){
	int chamada_inicial = (tamanho-1)/2;

	while(chamada_inicial >= 0){
		heapify(array,tamanho,chamada_inicial);
		chamada_inicial = chamada_inicial - 1;
	}
}

void heapify(int * array, int tamanho, int posicao_chamada){
	
	int filho_esquerdo = 2*posicao_chamada + 1;
	int filho_direito  = 2*posicao_chamada + 2;
	int maior_elemento = posicao_chamada;
	
	if(filho_esquerdo < tamanho && array[filho_esquerdo] > array[maior_elemento])
		maior_elemento = filho_esquerdo;

	if(filho_direito < tamanho && array[filho_direito] > array[maior_elemento])
		maior_elemento = filho_direito;

	if(maior_elemento != posicao_chamada){
		trocar(array,maior_elemento,posicao_chamada);
		heapify(array,tamanho,maior_elemento);		
	}
}

void heap_sort(int * array, int tamanho){

	if(tamanho <= 0 ) return;
	trocar(array,0,tamanho-1);
	heapify(array,tamanho-1,0);
	heap_sort(array,tamanho-1);
}


//==================IGNORE========================
//funcão de auxilio pra imprimir

void imprimir_vetor(int * array,int tamanho){
	int i = 0;
	while(i<tamanho)cout << array[i++] << " ";
	cout << "\n";
}


void trocar(int * array, int posA, int posB){
	int aux = array[posA];
	array[posA] = array[posB];
	array[posB] = aux;
}

//================================================



int main(){
	// O usuário pode colocar um número n de valores, então solicitamos esse n;
	int n;
	//lemos esse n
	cout << "Insira o número de elementos do vetor : ";
	cin >> n;
	//declaramos um vetor com esse tamanho n
	int * array = new int[n];
	int tamanho = n;
	int i;
	//loop de leitura
	for(i = 0; i < n; i++) {
		cout << "Insira o valor para o " << i+1 << "º elemento : ";
		cin >> array[i];
	}
	cout << "Antes de se tornar uma heap : ";
	imprimir_vetor(array,tamanho);
	
	cout << "Depois de se tornar heap : ";
	montar_heap(array,tamanho);
	imprimir_vetor(array,tamanho);

	cout << "Depois do heap sort : ";
	heap_sort(array,tamanho);
	imprimir_vetor(array,tamanho);

	return 0;
}
