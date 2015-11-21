class ExprC
end

class Value
end

class NumC < ExprC
  def initialize(number)
    @number = number
  end
end

class BoolC < ExprC
  def initialize(boolean)
    @boolean = boolean
  end
end

class IdC < ExprC
  def initialize(symbol)
    @symbol = symbol
  end
end

class BinopC < ExprC
  def initialize(symbol, left, right)
    @symbol = symbol
    @left = left
    @right = right
  end
end

class IfC < ExprC
  def initialize(expr, one, two)
  @expr = expr
  @one = one
  @two = two
  end
end

class AppC < ExprC
  def initialize(func, args)
    @func = func
    @args = args
  end
end

class LamC < ExprC
  def initialize(params, body)
    @params = params
    @body = body
  end
end

class NumV < Value
  def initialize(number)
    @number = number
  end
end

class BoolV < Value
  def initialize(boolean)
    @boolean = boolean
  end
end

class CloV < Value
  def initialize(params, body, env)
    @params = params
    @body = body
    @env = env
  end
end

def interp(expr)
  if expr.instance_of? NumC
    return NumV.new(expr.number)

  elsif expr.instance_of? BoolC
    return BoolV.new(expr.boolean)

  elsif expr.instance_of? IdC
    fail 'interp IdC is not working'

  elsif expr.instance_of? BinopC
    lft = interp(expr.left).number
    rght = interp(expr.right).number
    return NumV.new(lft.send(expr.symbol, rght))

  elsif expr.instance_of? IfC
    condition = interp(expr.expr)
    if condition.instance_of? BoolV
      if condition.boolean == true
        return interp(expr.one)
      else
        return interp(expr.two)
      end
    else
      raise condition, "Invalid Value Type in IfC in interp"
    end
  end
end