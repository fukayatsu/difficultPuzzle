# -*- encoding: utf-8 -*-
line_num = 0

File.open('result.txt','r'){ |file|
	while line = file.gets
		line_num += 1
		board = line.split(',')
		for i in 4...10 do
			for j in 4...14 do
				case  board[i*18+j].to_i
					when 1..3
					printf('十');
				when 4..6
					printf('口');
				when 7..9
					printf('・');
				when 10..12
					printf('＠');
				else
					printf('.');
				end
					#printf('%02d ', board[i*18+j].to_i )
			end
			puts
		end
		puts
  end
	puts "there is now #{line_num} answers."
	puts
}
