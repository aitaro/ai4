$size = 8
class Chess
  def initialize(chess_piece, map = 0)
    @chess_piece = chess_piece # 0:ナイト, 1:ビショップ, 2:キング
    @size = $size
    if map == 0 then map = Array.new(@size).map{Array.new(@size,0)} end
    @map = map # 0:駒設置可能, 1:駒設置不可, 2:駒配置済
    @correct_map = []
    @searched_map = []
    @max_count = 0
    @tmp = 0
  end

  # place_nowに存在するコマが行くことが可能な場所
  def where_go(s,t)
    place = []
    case @chess_piece
    when 0 then
      place = [[s-2,t-1],[s-2,t+1],[s+2,t-1],[s+2,t+1],[s-1,t-2],[s-1,t+2],[s+1,t-2],[s+1,t+2]]
    when 1 then
      -7.upto(7) do |i|
        unless i == 0
          place += [[s + i,t + i]]
          place += [[s + i,t - i]]
        end
      end
    when 2 then
      place = [[s-1,t-1],[s-1,t],[s-1,t+1],[s,t-1],[s,t+1],[s+1,t-1],[s+1,t],[s+1,t+1]]
    end
    place_new = []
    place.length.times do |i|
      if (place[i][0] >= 0 && place[i][0] <= 7) && (place[i][1] >= 0 && place[i][1] <= 7)
        place_new.push(place[i])
      end
    end
    return place_new
  end

  # 位置を出力する
  def mapping
    @size.times do |i|
      @size.times do |j|
        case @map[i][j]
        when 0
          print ". "
        when 1
          print "x "
        when 2
          print "#{@chess_piece} "
        end
      end
      print "\n"
    end
  end

  # mapの更新
  def map_update
    @size.times do |i|
      @size.times do |j|
        if @map[i][j] != 2 then next end
        place = where_go(i,j)
        place.length.times do |k|
          @map[place[k][0]][place[k][1]] = 1
        end
      end
    end
  end

  def can_put?(i,j)
    @map[i][j] == 0
  end

  def put(i,j)
    @map[i][j] = 2
    map_update
  end

  def map
    @map
  end

  def map_init
    @map = Array.new(@size).map{Array.new(@size,0)}
  end

  def already_puted?(s,t)
    bool = false
    @searched_map.length.times do |i|
      bool = bool || @searched_map[i][s][t] == 2
    end
    return bool
  end

  def exist_set?(s,t)
    if s==0&&t==0 then return already_puted?(0,0) end

    bool = false

    @searched_map.length.times do |i|


      search = one_zero(@searched_map[i].flatten[0..(s*@size+t)])
      now = one_zero(@map.flatten[0..(s*@size+t-1)].push(2))
      bool = bool || search == now
    end

    return bool
  end

  def one_zero(arr)
    arr.length.times do |i|
      if arr[i] == 1 then arr[i] = 0 end
    end
    return arr
  end

  def try_put
    2.times do |t|
      @size.times do |i|
        @size.times do |j|

        if !can_put?(i,j) then next end
        if exist_set?(i,j) && t == 0 then next end
        put(i,j)
        puts "----------------------"
        mapping
        map_update
        try_put
        end
      end
    end
  end

  def count_piece
    return @map.flatten.count(2)
  end

  def count_ableplace
    return @map.flatten.count(0)
  end




  def try_all
    loop do
      try_put
      puts "----------------------"
      mapping

      gets
      @searched_map.push(Marshal.load(Marshal.dump(@map)))
      if @max_count == count_piece
        @correct_map.push(self)
      elsif @max_count < count_piece
        @correct_map = [Marshal.load(Marshal.dump(@map))]
        @max_count = count_piece
      end
      map_init

      if @max_count == 25
        mapping
        return
      end
    end
  end

  def placed
    ans = []
    @size.times do |i|
      @size.times do |j|
        if @map[i][j] == 2 then ans.push(i*@size+j) end
      end
    end
    return ans
  end


  def try(n = 0)
    if n==@size**2 then
      puts "-------------------"
      mapping
      @tmp += 1
      p @tmp
      gets
      return
    end
    if  n == 55 then mapping end
    if can_put?(n/@size,n% @size)
      put(n/@size,n% @size)
      try(n+1)
    end
    if  n == 55 then mapping end
    p n
    try(n+1)
  end

end

class Try_chess
  def initialize
    @count = 0
    @max_count = 0
    @size = $size
  end

  def try(n = 0, c = Chess.new(0))
    if n == @size**2 then
      if c.count_piece > 31
        puts "-------------------"
        c.mapping
      end
      return
    end

    if c.can_put?(n/@size,n% @size)
      c.put(n/@size,n% @size)
      try(n+1,c)
      c.map[n/@size][n% @size] = 0
      c.map_update
    end
    if c.count_piece + c.count_ableplace < 5
    #  return
    end
    try(n+1,c)
  end
end

c = Try_chess.new
c.try
