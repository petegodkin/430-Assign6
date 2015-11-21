#classes
class ExprC
end

class Value
end

class NumC < ExprC
  def initialize(number)
    @number = number
  end

  def number
    return @number
  end
end

class BoolC < ExprC
  def initialize(boolean)
    @boolean = boolean
  end

  def boolean
    return @boolean
  end
end

class IdC < ExprC
  def initialize(symbol)
    @symbol = symbol
  end

  def symbol
    return @symbol
  end
end

class BinopC < ExprC
  def initialize(symbol, left, right)
    @symbol = symbol
    @left = left
    @right = right
  end

  def symbol
    return @symbol
  end

  def left
    return @left
  end

  def right
    retun @right
  end
end

class IfC < ExprC
  def initialize(expr, one, two)
  @expr = expr
  @one = one
  @two = two
  end

  def expr
    return @expr
  end

  def one
    return @one
  end

  def two
    return @two
  end
end

class AppC < ExprC
  def initialize(func, args)
    @func = func
    @args = args
  end

  def func
    return @func
  end

  def args
    return @args
  end
end

class LamC < ExprC
  def initialize(params, body)
    @params = params
    @body = body
  end

  def params
    return @params
  end

  def body
    return @body
  end
end

class NumV < Value
  def initialize(number)
    @number = number
  end

  def number
    return @number
  end
end

class BoolV < Value
  def initialize(boolean)
    @boolean = boolean
  end

  def boolean
    return @boolean
  end
end

class Binding
  def initialize(name, val)
    @name = name
    @val = val
  end

  def name
    return @name
  end

  def val
    return @val
  end
end

class CloV < Value
  def initialize(params, body, env)
    @params = params
    @body = body
    @env = env
  end

  def params
    return @params
  end

  def body
    return @body
  end

  def env
    return @env
  end
end

#variables
environment = []
environment < Binding

#functions
def interp(expr, env)
  if expr.instance_of? NumC
    return NumV.new(expr.number)

  elsif expr.instance_of? BoolC
    return BoolV.new(expr.boolean)

  elsif expr.instance_of? IdC
    return lookup(expr.symbol, env)

  elsif expr.instance_of? BinopC
    lft = interp(expr.left, env).number
    rght = interp(expr.right, env).number
    return NumV.new(lft.send(expr.symbol, rght))

  elsif expr.instance_of? IfC
    condition = interp(expr.expr, env)
    if condition.instance_of? BoolV
      if condition.boolean == true
        return interp(expr.one, env)
      else
        return interp(expr.two, env)
      end
    else
      raise condition, 'Invalid Value Type in IfC in interp'
    end

  elsif expr.instance_of? LamC
    return CloV.new(expr.params, expr.body, env)
  end
end

def lookup(symbol, env)
  env.each do |bind|
    if bind.name == symbol
      return bind.val
    end
  end
  raise symbol, 'Not Found in lookup'
end