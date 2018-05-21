!SLIDE subsection

# ¿Qué testear?

!SLIDE bullets incremental

## ¿Qué testear?

- Unitarios (una pieza)
- Funcionales (interacción entre piezas)
- Integración (interacción entre sistemas)
- Acceptación (punto de vista de usuario)

<small>*sí, es una simplificación gruesa, ahorraos el tuit*</small>

!SLIDE bullets incremental

## ¿Qué testear (rails way)?

- Modelos (tocando DB)
- Controlador (abstrayendo muchas piezas, rutas, vistas...)
- Integración (default en rails 5, ahora menos lentos)
- System, benchmark...

!SLIDE incremental

## ¿Qué testear (unit)?

---

         | Incoming                      | Outgoing
--------:|:-----------------------------:|:-----------------------------:
 Query   | Response         <sup>1</sup> | Stub (test at provider)    <sup>3</sup>
 Command | State (Response) <sup>2</sup> | Call is made (mock/verify) <sup>4</sup>


1. `full_name` en una persona
2. `compact!` en una colección
3. `Time.now` que usaremos en un timestamp
4. `Slack.notify(channel: "#alert",txt: "Error: #{msg}")`


!SLIDE

## 1. incoming query

- Como lo que hemos visto
- Llamar a un método público y
- Comparar el retorno con lo esperado

!SLIDE bullets
## 2. incoming command

    @@@ Ruby

    class Cart
      def scan(code)
        @products << Product.new(code)
      end

      def total
        sub_total - discounts
      end

      #...
    end

Y si no hay método `products`?

!SLIDE bullets incremental
## 2. incoming command (cont)

Opciones:

- No testear "si es privado no le importa a nadie"
- Efectos "testear lo que ves"
- `send(:privado)`, `get_instance_variable("@foo")`

!SLIDE
## 3. outgoing query

- **este** test no debería fallar
- no ejecutar código de más
- respuesta conocida

!SLIDE bullets incremental
## 3. outgoing query (stub)

    @@@ Ruby
    product = Product.new(expire_date: Date.new(2010,5,5))

    def Date.today
      new(2010, 5, 6)
    end

    assert_equal(product.expired?, true)

- `Date` se queda modificado
- hay que *arreglarlo* a mano

!SLIDE bullets incremental
## 3. outgoing query (stub/minitest)

    @@@ Ruby
    # add 'require "minitest/mock"' to test_helper.rb
    class PersonTest < Minitest::Test
      def setup
        @product = Product.new(expire_date: Date.new(2010,5,5))
        @expired_date = Date.new(2010,5,6)
      end

      def test_expired_after_exired_date
        Time.stub(:now, @expired_date) do
          assert_equal(@product.expired?, true)
        end
      end
    end

- método queda restaurado al terminar el bloque

!SLIDE
## 3. outgoing query (stub/spec)

    @@@ Ruby

    describe Product do # Rspec.describe Product do
      describe ".expired?" do
        subject{ Product.new(expire_date: Date.new(2010,5,5)) }

        context "after expire date" do
          let(:expired_date){ Date.new(2010,5,6) }
          before do
            allow(Date).to receive(:today).and_return(expired_date)
          end

          it "is expired" do
            expect(subject).to be_expired # checks with and without '?'
          end
        end
      end
    end

!SLIDE
## 3. outgoing query (stub/minispec)

    @@@ Ruby
    # add 'require "minitest/spec"' to test_helper.rb
    describe Product do # class ProductTest < Minitest::Spec
      describe ".expired?" do
        subject{ Product.new(expire_date: Date.new(2010,5,5)) }

        describe "after expire date" do
          let(:expired_date){ Date.new(2010,5,6) }
          before do
            allow(Date).to receive(:today).and_return(expired_date)
          end

          it "is expired" do
            expect(subject).must_be :expired?
          end
        end
      end
    end

!SLIDE bullets incremental
## 4. outgoing command

- comprobar que cambiamos el mundo
- no cómo, sino qué

!SLIDE bullets incremental
## 4. outgoing command (mock/minitest)

- comprobar que cambiamos el mundo
- no cómo, sino qué

!SLIDE

## clase con dependencias

~~~FILE:../examples/dep_one.rb:ruby~~~

!SLIDE

## test deps (outgoing command/rspec)

    @@@ Ruby
    describe "sends notification" do
      let(:foo){ double() }
      subject { DepOne.new(foo) }

      before do
        expect_any_instance_of(Notification).to receive(:deliver).
          and_return(true)

        expect(foo).to_receive(:save).and_return(true)
      end

      it "returns the specified value" do
        expect(subject.run).to eq(true)

        # auto verifies mocks
      end
    end

!SLIDE

## se cura con una inyeccion

    @@@Ruby
    class DepOne
      def initialize(foo, notifier: Notification )
        @foo = foo
        @notifier = notifier
      end

      def run
        if @foo.save
          publish
        end
      end

      private

      def publish
        notifier.deliver(@foo, Time.now)
      end
    end

!SLIDE

## test deps (outgoing command/minispec)

    @@@ Ruby

    describe "sends notification" do
      let(:foo){ Minitest::Mock.new }
      let(:notifier){ Minitest::Mock.new }
      subject { DepOne.new(foo) }

      before do
        notifier.expect(:publish, notification, [Time, foo])
        foo.expect(:save, true)
      end

      it "returns the specified value" do
        expect(subject.run).to eq(true)

        foo.verify # it was called the appropiate number of times
      end
    end

!SLIDE bullets center

## deberes

[Mocks and stubs](http://www.martinfowler.com/bliki/TestDouble.html) *Fowler & Meszaros*

!SLIDE bullets center

![Manolo Rubyto](/_images/manolo_rubyto.png)

## Gracias &#127829; !

![Sponsors](/_images/sponsors.jpg)
