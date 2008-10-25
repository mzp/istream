#!/usr/bin/env ruby
class FfmpegWrapper
  # 各機種用のProfile
  @@profiles = {
    'iPod' => {
      :f       => 'mp4', #file suffix
      :vcodec  => 'mpeg4', # codec
      :s       => '320x240', # resolution
      :b       => '600k', # video bit rate
      :acodec  => 'aac', # audio codec
      :ab      => '64', # audio bit rate
      :ar      => '48000'
    },
    
    'thumbnail' => {
      :f       => 'image2',
      :pix_fmt => 'png',
      :vframes => 1,
      :ss      => 5,
      :s       => '320x240',
    }
  }

  def initialize()
  end

  def setandgo(setting)
    set(setting)
    run()
  end

  #パラメータ設定
  def set( setting )
    #setting{ :ffmpeg  => '/path/to/ffmpeg',
    #         :ifile   => '/path/to/inputfile',
    #         :ofile   => 'outputfile',
    #         :profile => 'targetName', }

    @ffmpegOptions = Array.new
    @@profiles[ setting[:target] ].each{ |k,v|
      @ffmpegOptions.push(%Q{ -#{k} #{v}})
    }

    @cmd = Array.new
    @cmd.push %Q{#{setting[:ffmpeg]} -i "#{setting[:ifile]}" #{@ffmpegOptions} "#{setting[:ofile]}" }
  end

  # @cmdを実際に実行
  #エラー処理などを全く行っていない。 FIXME
  def run()
    stdout = ""
    io = IO.popen("#{@cmd}", "r");
    io.each("\n") {|line|
      stdout << line
    }
    io.close
    return stdout
  end

  # 登録プロファイルのKeyリストを返す
  def profiles()
    rtnarr = Array.new()
    @@profiles.each{ |k,v|
      rtnarr.push(k)
    }
    return rtnarr
  end
end

if __FILE__ == $0 then
  require 'optparse'
  opt = OptionParser.new

  opt.on('-p=PROFILE','--profile=PROFILE') {|profile| @profile = profile }
  opt.on('-s=SUFFIX','--suffix=SUFFIX') {|suffix| @suffix = suffix }
  opt.parse!(ARGV)

 
  ffmpeg =  FfmpegWrapper.new()
  ARGV.each do|file|
    ffmpeg.setandgo(:ffmpeg=> 'ffmpeg',
                    :ifile => file,
                    :ofile => File.basename(file,'.*') + '.' + @suffix,
                    :target=> @profile )
  end
end

