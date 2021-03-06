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
    return @right
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

class Bind
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


#[:with, [:z,:=,14], [:+, :z, :z]]

def parse(expr)
  if not expr.is_a? (Array)
    case expr
      when !!expr == expr
        BoolC.new(expr)
      when Numeric
        NumC.new(expr)
      when Symbol
        IdC.new(expr)
    end

  elsif expr.first.is_a? (Symbol)

    case expr.first
      when :if
        IfC.new(parse(expr[1]), parse(expr[2]), parse(expr[3]))

      when :with
        paramsArgs = expr.slice(1, expr.length - 2)
        AppC.new(LamC.new(paramsArgs.map {|x| withParams(x)}, parse(expr.last)), paramsArgs.map {|x| withArgs(x)})

      when :func
        params = expr.slice(1, expr.length - 2)
        if params.uniq.length == params.length
          LamC.new(params, parse(expr.last))
        else
          raise "Duplicate Params"
        end

      when Symbol
	if  [:+, :-, :/, :*].include?(expr[0])
          BinopC.new(expr[0], parse(expr[1]), parse(expr[2]))
        else
          args = expr.slice(1, expr.length)
          AppC.new(parse(expr.first), args.map {|x| parse(x)})
        end
    end

  else
    args = expr.slice(1, expr.length)
    AppC.new(parse(expr.first), args.map {|x| parse(x)})
  end
end

def interp(expr, env)
  if expr.instance_of? NumC
    return NumV.new(expr.number)

  elsif expr.instance_of? BoolC
    return BoolV.new(expr.boolean)

  elsif expr.instance_of? IdC
    return lookup(expr.symbol, env)

  elsif expr.instance_of? BinopC
    lft = interp(expr.left, env)
    rght = interp(expr.right, env)
    if (lft.instance_of? NumV) && (rght.instance_of? NumV)
      return NumV.new(lft.number.send(expr.symbol, rght.number))
    else
      fail 'Argument(s) not a NumV'
    end

  elsif expr.instance_of? IfC
    condition = interp(expr.expr, env)
    if condition.instance_of? BoolV
      if condition.boolean == true
        return interp(expr.one, env)
      else
        return interp(expr.two, env)
      end
    else
      raise "Invalid Value Type in IfC in interp"
    end

  elsif expr.instance_of? LamC
    return CloV.new(expr.params, expr.body, env)

  elsif expr.instance_of? AppC
    funcCloV = interp(expr.func, env)

    if funcCloV.instance_of? CloV
      if expr.args.length == funcCloV.params.length
        return interp(funcCloV.body, bindAll(funcCloV.params, expr.args, env, funcCloV.env))
      else
        fail 'interp: Wrong arity ' + expr.args.to_s + ' ' + funcCloV.params.to_s
      end
    else
      raise "Not evaluated into a CloV in AppC"
    end
  end
end

def serialize (val)
  case val
    when BoolV
      return val.boolean.to_s
    when NumV
      return val.number.to_s
    when CloV
      return '#<procedure>'
  end
end

def topEval(arr)
  serialize(interp(parse(arr), []))
end

#helper functions
def withArgs(expr)
  return parse(expr[2])
end

def withParams(expr)
  return expr[0]
end

def lookup(symbol, env)
  env.each do |bind|
    if bind.name == symbol
      return bind.val
    end
  end
  raise "Not Found in lookup: " + symbol.to_s
end

def bindAll(params, args, env, clovEnv)
  if params.empty? == true
    return clovEnv
  else
    return [Bind.new(params.first, interp(args.first, env))] + bindAll(params.slice(1, params.length), args.slice(1, args.length), env, clovEnv)
  end
end
