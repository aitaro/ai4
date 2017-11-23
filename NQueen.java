import java.util.*;

public class NQueen {
	private enum Status {
		FREE,
		NOT_FREE
	}

	private final int N;	// クイーンの数
	private int[] pos;		// 各行の置かれたクイーンの位置
	private Status[] col;	// クイーンが垂直方向に利いているかを示す配列
	private Status[] down;	// クイーンが右斜め下向きに利いているかを示す配列
	private Status[] up;	// クイーンが右斜め上向きに利いているかを示す配列
	private int count;		// 解の数

	// Nクイーン問題を解くためのオブジェクトを生成する
	public NQueen(int numberOfQueen) {
		// 配列を割り当てる
		// クイーンの位置と利き筋を初期化する
		N = numberOfQueen;
		pos = new int[N];
		Arrays.fill(pos, -1);
		col = new Status[N*2 -1];
		down = new Status[N*2 -1];
		up = new Status[N*2 -1];
		Arrays.fill(col, Status.FREE);
		Arrays.fill(down, Status.FREE);
		Arrays.fill(up, Status.FREE);
	}

	public boolean tryQueen(int a) {
		// 行a以降のすべての行にクイーンを置く
		// 左から右に向かって順番にクイーンが置けるかどうかを調べる
		// 行aのb列目に置けるかどうかを,利き筋の情報を元に調べる
		// 置くことができたら．場所を記録して，利き筋をセットする．
		// クイーンが置けたらtrue,置けなかったらfalseを返す
		// 行a+1以降のすべての行に置けたら成功.
		// N個のクイーンをすべて置くことができれば成功．
		if(a == N){
			return true;
		}

		for(int b = 0; b < N; b++){
			if(col[b] == Status.NOT_FREE || down[N - 1 - a + b] == Status.NOT_FREE || up[a + b] == Status.NOT_FREE){
					continue;
			}
			pos[a] = b;
			col[b] = Status.NOT_FREE;
			down[N - 1 - a + b] = Status.NOT_FREE;
			up[a + b] = Status.NOT_FREE;

			if(!tryQueen(a + 1)){
				pos[a] = -1;
				col[b] = Status.FREE;
				down[N - 1 - a + b] = Status.FREE;
				up[a + b] = Status.FREE;
				continue;
			}
			return true;
		}
		return false;



	}

	// クイーンの位置を出力する
	public void print() {
		// 表示形式に沿って出力してください
		for(int a = 0; a < N; a ++){
			for(int b = 0;b < N; b ++){
				if(pos[a] == b){
					System.out.print("Q ");
				}else{
					System.out.print(". ");
				}
			}
			System.out.println();
		}


	}

	public boolean tryQueenAll(int a) {
		// ここに処理を書きます
		if(a == N){
			count ++;
			print();
			System.out.println("---------------------------------");
			return false;
		}

		for(int b = 0; b < N; b++){
			if(col[b] == Status.NOT_FREE || down[N - 1 - a + b] == Status.NOT_FREE || up[a + b] == Status.NOT_FREE){
					continue;
			}
			pos[a] = b;
			col[b] = Status.NOT_FREE;
			down[N - 1 - a + b] = Status.NOT_FREE;
			up[a + b] = Status.NOT_FREE;

			if(!tryQueenAll(a + 1)){
				pos[a] = -1;
				col[b] = Status.FREE;
				down[N - 1 - a + b] = Status.FREE;
				up[a + b] = Status.FREE;
				continue;
			}
			return true;
		}
		if(a == 0){
		System.out.println("個数：" + count);
		}
		return false;



	}

}
