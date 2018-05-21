class DepOne
  def initialize(foo)
    @foo = foo
  end

  def run
    if @foo.save
      publish
    end
  end

  private

  def publish
    Notification.new(@foo, Time.now).deliver
  end
end
