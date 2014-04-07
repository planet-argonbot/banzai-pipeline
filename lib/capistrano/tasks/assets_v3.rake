namespace :deploy do
  namespace :assets do
    # Override the Capistrano default task
    task :precompile do
      on roles(:app) do
        if force_asset_compilation? || assets_dirty?
          within fetch(:latest_release_directory) do
            with rails_env: fetch(:rails_env) do
              execute :rake, 'assets:precompile'
            end
          end
        else
          puts "Skipping asset pre-compilation because there were no asset changes"
        end
      end
    end

    def force_asset_compilation?
      fetch(:always_compile_assets, false) || ENV['COMPILE_ASSETS'] == 'true'
    end

    def assets_dirty?
      r = fetch(:safe_current_revision)
      return true if r.nil?
      asset_changing_files = ["/vendor/assets/", "/app/assets/", "/lib/assets", "/Gemfile", "/Gemfile.lock"]
      asset_changing_files = asset_changing_files.select do |f|
        test("[ -f #{file} ]")
      end
      capture("cd #{shared_path}/cached-copy && #{source.local.log(current_revision, real_revision)} #{asset_changing_files.join(" ")} | wc -l").to_i > 0
    end

    def safe_current_revision
      begin
        current_revision
      rescue => e
        puts "*" * 80
        puts "An exception as occured while fetching the current revision. This is to be expected if this is your first deploy to this machine. Othewise, something is broken :("
        puts e.inspect
        puts "*" * 80
        nil
      end
    end
  end
end
