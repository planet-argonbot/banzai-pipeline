Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    namespace :assets do
      # Override the Capistrano default task
      task :precompile, :roles => :web, :except => { :no_release => true } do
        if force_asset_compilation? || assets_dirty?
          run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
        else
          logger.info "Skipping asset pre-compilation because there were no asset changes"
        end
      end

      def force_asset_compilation?
        fetch(:always_compile_assets, false) || ENV['COMPILE_ASSETS'] == 'true'
      end

      def assets_dirty?
        safe_revision = safe_current_revision
        return true if safe_revision.nil?
        from = source.next_revision(safe_revision)
        asset_changing_files = ["vendor/assets/", "app/assets/", "lib/assets", "Gemfile", "Gemfile.lock"]
        asset_changing_files = asset_changing_files.select do |file|
          File.exists? file
        end

        capture("cd #{shared_path}/cached-copy && #{source.local.log(from, real_revision)} #{asset_changing_files.join(" ")} | wc -l").to_i > 0
      end

      def safe_current_revision
        begin
          current_revision
        rescue => e
          logger.info "*" * 80
          logger.info "An exception as occured while fetching the current revision. This is to be expected if this is your first deploy to this machine. Othewise, something is broken :("
          logger.info e.inspect
          logger.info "*" * 80
          nil
        end
      end
    end
  end
end
