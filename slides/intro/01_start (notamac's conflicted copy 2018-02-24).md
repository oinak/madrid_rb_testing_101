
!SLIDE subsection

# ¿Cómo testear?

> Érase una vez...

<small>
*La trágica historia del estudiante de informática que no conocía cvs*
</small>

!SLIDE

## clase mínima de ruby:

Almacena un nobre de usuario para saludarlo

    @@@ Ruby
    g = Greeter.new("Nombre")
    g.say
    # => Hola Nombre!

!SLIDE

## clase mínima de ruby:

~~~FILE:../examples/greeter.rb:ruby~~~

!SLIDE incremental bullets

## prueba mínima:

    @@@ Shell
    $ ruby -r'./examples/greeter.rb' -e 'puts Greeter.new("Fer").say'
    Hello Fer

- ¿está bien?
- guardar salida para comprobar
- ¿cual fue el error?
- ¿efectos secundarios?

!SLIDE incremental bullets

## prueba mínima en irb:

    @@@ Ruby
    require './examples/greeter.rb'

    greet    = Greeter.new("Fer")
    expected = "Hola Fer!"
    got      = greet.say

    if got == expected
      puts 'ok'
    else
      puts "ERROR, Expected: #{expected}, got #{got}"
    end

!SLIDE

    @@@ Ruby
    > require './examples/greeter.rb'
    => true
    > greet    = Greeter.new("Fer")
    => #<Greeter:0x000055abdd9fcd40 @name="Fer">
    > expected = "Hola Fer!"
    => "Hola Fer!"
    > got = greet.say
    => "Hello Fer"
    > if got == expected
    ?>   puts 'ok'
    ?> else
    ?>   puts "ERROR, Expected: #{expected}, got #{got}"
    ?> end

`ERROR, Expected: Hola Fer!, got Hello Fer`

!SLIDE bigtext

# D.R.Y.

!SLIDE subsection

# ¿Cómo testear (una clase)?

!SLIDE

## test mínimo (minitest):

    @@@ Ruby
    require 'minitest/autorun'           # "soy un test"
    require 'my_obj'                     # carga lo que vas a probar

    class ObjTest < Minitest::Test       # convención: TuClaseTest
    
      def test_what                      # ejecutará todos los test_xxxx
    
        o = Obj.new("Value")             # 1. prepara lo necesario
    
        result = o.my_method             # 2. ejecuta tu codigo
    
        assert_equal(result, "Expected") # 3. compara con lo esperado
    
        o.destroy                        # 4. dejalo como lo encontraste
      end
    end

!SLIDE

## test mínimo (minitest):

~~~FILE:../examples/greeter_test.rb:ruby~~~

!SLIDE small

### prueba automática (minitest)

    @@@ Shell
    $ ruby -I./examples ./examples/greeter_test.rb
    Run options: --seed 5216

    # Running:

    F

    Finished in 0.000568s, 1759.7114 runs/s, 1759.7114 assertions/s.

      1) Failure:
    GreeterTest#test_say [./examples/greeter_test.rb:8]:
    Expected: "Hello Ada"
      Actual: "Hello Ada!"

    1 runs, 1 assertions, 1 failures, 0 errors, 0 skips

!SLIDE

## test mínimo (rspec):

Primero hacemos `gem install rspec`

~~~FILE:../examples/greeter_spec.rb:ruby~~~

!SLIDE small

### prueba automática (rspec)

    @@@ Shell
    $ rspec -Iexamples/ examples/greeter_spec.rb
    F

    Failures:

      1) Greeter#say returns 'Hello Name!'
         Failure/Error: expect(greeter.say).to eq("Hello Ada!")
         
           expected: "Hello Ada!"
                got: "Hello Ada"
         
           (compared using ==)
         # ./examples/greeter_spec.rb:8:in `block (3 levels) in <top (required)>'

    Finished in 0.01217 seconds (files took 0.08172 seconds to load)
    1 example, 1 failure

    Failed examples:

    rspec ./examples/greeter_spec.rb:5 # Greeter#say returns 'Hello Name!'


