require_relative "../Common/Builder.rb"

# See:
# - Compiling the latest OpenSSL for Android: https://stackoverflow.com/questions/11929773/compiling-the-latest-openssl-for-android

class OpenSSLBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.ssl, arch)
      @ndk = AndroidBuilder.new(@arch)
   end

   def prepare
      # Not used at the moment
   end

   def options()
      cmd = ["cd #{@sources} &&"]
      cmd << "ANDROID_NDK=#{@ndk.sources}"
      cmd << "PATH=#{@ndk.toolchain}/bin:$PATH"
      return cmd
   end

   def executeConfigure
      # Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
      execute options.join(" ") + " ./Configure -D__ANDROID_API__=#{@ndk.api} --prefix=#{@installs} android-arm"
   end

   def executeBuild
      execute options.join(" ") + " make"
   end

   def executeInstall
      execute options.join(" ") + " make install_sw install_ssldirs"
   end

end