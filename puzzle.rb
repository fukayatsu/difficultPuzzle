#ruby $
#stop


require "./block.rb"

class Puzzle
  Width = 10+8
  Height = 6+8

  def initialize
		#ボードを初期化
    board = Array.new(Height).map!{Array.new(Width, -100)}
		for i in 0...6 do
			for j in 0...10 do 
				board[i+4][j+4]=0
			end
		end
		
		#ブロックを初期化
		@blocks = []
		B.each_with_index{ |block, i|
			bl = []
			for j in 0...block[0] do
				bl.push rotate_block(block[1], j, i+1)
			end
			@blocks.push bl
		}
		#showBlock @blocks[0][0]
		#p @blocks.length
		
		#スタックを初期化
		@stack = []
		@stack.push [-1, board]
		
		@answer_num = 0
  end
	
	attr_accessor :blocks

  def show_board(board)
    board.each{|row|
      row.each{|dot|
				print_cell dot	
      }  
      puts ''
    }
  end
  
	#rotate a block for n times
	#  ...and add sum p
	#n must be 0, 1, 2, or 3
	def rotate_block(block, n, p)
		nblock = Array.new(5).map!{Array.new(5, 0)} 
		if n==0 then
			for i in 0...5 do
				for j in 0...5 do
					nblock[i][j] = block[i][j] * p
				end
			end
			return nblock
		elsif n==1 then
			for i in 0...5 do
				for j in 0...5 do
					nblock[i][j] = block[j][4-i] * p
				end
			end
			return nblock
		elsif n==2 then
			for i in 0...5 do
				for j in 0...5 do
					nblock[i][j] = block[4-i][4-j] * p
				end
			end
			return nblock
		elsif n==3 then
			for i in 0...5 do
				for j in 0...5 do
					nblock[i][j] = block[4-j][i] * p
				end
			end
			return nblock
		end
	end

	def show_block(block)
	  block.each{ |row|
				row.each{ |col|
				  print_cell col					
				}
				puts
			}
	end

	def print_cell(num)
		case num 
		when 0
			printf('   ')
		when -100
			printf(' * ')
		when -99..-1
			printf(' @ ')
		else
			printf('%2d ',num)
		end
	end
	
	def fit?(block, board, y, x)
		for i in 0...5 do
			for j in 0...5 do
				if block[i][j]!=0 && board[i+y][j+x]!=0 then
					#puts "#{i+y}, #{j+x}"
					return false
				end
			end
		end

		return true
	end
	
	def zero_check?(board)
		#枝刈り
		#0の周りチェック
		for i in 4...10 do
			for j in 4...18 do
				if board[i][j] == 0 then
					if board[i-1][j] != 0 && board[i+1][j] !=0 &&
								board[i][j-1] != 0 && board[i][j+1] !=0 then
						return false
					end
				end
			end
		end

		return true
	end

	def put_block(block, board, y, x)
		nboard = Marshal.load(Marshal.dump(board))	
		for i in 0...5 do
			for j in 0...5 do
				nboard[i+y][j+x] += block[i][j]
			end
		end
		return nboard
	end
	
	def solve_all
		while(true) do
			answer = solve
			if answer != nil then
				show_board answer
				break
			end
		end
	end

	def solve
		#スタックから一つ取り出す
		@stack
		move = @stack.pop #[-1, board]
		if move == nil then
			puts "scack is now empty."
			exit
		end

		bl_num = move[0] + 1
		board = move[1]

		#もし解けていたら
		if bl_num == 12 then
			show_board board
			@answer_num += 1
			puts "#answer No. {@answer_num}"
			#ファイルに回答を保存
			File.open('result.txt','a'){ |file|
			  file.puts board.join(',')
			}
		  return nil 
		end

		bl = @blocks[bl_num]
		bl.each{ |b|
			for i in 0...9 do
				for j in 0...13 do
					if fit?(b, board, i, j) then
						n_board = put_block(b, board, i, j)
						@stack.push [bl_num, n_board] if zero_check?(n_board)
					#	`clear`						
					#	show_board board
					#	puts
					end
				end
			end
		}
		#p	@stack.length
		return nil
	end
end

pz = Puzzle.new
pz.solve_all
