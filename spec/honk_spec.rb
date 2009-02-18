require File.join(File.dirname(__FILE__), 'helper')

describe Honk do
  after(:each) do
    reset_honk
  end

  describe '.root' do
    it "should return the root without arguments" do
      Honk.root.should eql(Honk.config[:root])
    end

    it "should set the root to the expanded path with one argument" do
      Honk.root '..'
      Honk.root.should eql(Pathname.new('..').expand_path)
    end
  end

  describe '.paginate' do
    it "should return the pagination value without arguments" do
      Honk.paginate.should eql(Honk::DEFAULTS[:paginate])
    end

    it "should set the pagination with one argument" do
      Honk.paginate 20
      Honk.config[:paginate].should eql(20)
    end
  end

  describe '.formatter' do
    it "should return the formatter name without arguments" do
      Honk.formatter.should be_nil
    end

    it "should change the default formatter with one argument" do
      Honk.formatter :redcloth
      Honk.formatter.should eql(:redcloth)
    end

    it "should change de default format_proc with one argument" do
      Honk.formatter :redcloth
      Honk.format_proc.should eql Honk::FORMAT_PROCS[:redcloth]
    end

    it "should reset the default format_proc when the formatter is unknown" do
      begin
        $stderr = StringIO.new
        Honk.formatter :unknown_formatter
        $stderr = STDERR
      rescue SystemExit
      end
      Honk.format_proc.should eql Honk::DEFAULTS[:format_proc]
    end

    it "should require the formatter with one argument" do
      Honk.formatter :redcloth
      require('redcloth').should be_false
    end
  end

  describe '.format_proc' do
    it "should return the proc without arguments" do
      Honk.format_proc.call("foo").should eql("foo")
    end

    it "should change the proc with one argument" do
      Honk.format_proc { |s| s.gsub('a', 'e') }
      Honk.format_proc.call("mah").should eql("meh")
    end

    it "should raise an error if the proc arity is wrong" do
      lambda { Honk.format_proc {|a,b| a + b} }.should raise_error(ArgumentError)
    end
  end

end
