# RDS
DATABASE_HOST = ENV['DATABASE_HOST']
DATABASE_PORT = ENV['DATABASE_PORT']

# アプリケーション固有
DATABASE_DB = ENV['TECH_NEWS_DATABASE_DB']
DATABASE_USER_NAME = ENV['TECH_NEWS_DATABASE_USER_NAME']
DATABASE_USER_PASSWORD = ENV['TECH_NEWS_DATABASE_USER_PASSWORD']
SECRET_KEY_BASE = ENV['TECH_NEWS_SECRET_KEY_BASE']

APPLICATION_USER = 'ec2-user'
BASE_DIR = '/home/ec2-user'
BASH_RC = '/home/ec2-user/.bashrc'

# Railsアプリケーション用ログディレクトリ作成
directory "/var/log/app" do
  mode "777"
  owner APPLICATION_USER
  group APPLICATION_USER
end

# pidディレクトリ作成
directory "#{BASE_DIR}/tmp/pids" do
  mode "755"
  owner APPLICATION_USER
  group APPLICATION_USER
end

# CodeDeploy対応
directory "/opt/codedeploy-agent/.bundle" do
  mode "755"
  owner APPLICATION_USER
  group APPLICATION_USER
end

# アプリケーション固有の環境変数定義
execute 'init environment variables' do
  not_if "cat #{BASH_RC} | grep 'SECRET_KEY_BASE'"
  command <<-EOL
    echo 'export DATABASE_HOST="#{DATABASE_HOST}"' >> #{BASH_RC}
    echo 'export DATABASE_PORT="#{DATABASE_PORT}"' >> #{BASH_RC}
    echo 'export DATABASE_DB="#{DATABASE_DB}"' >> #{BASH_RC}
    echo 'export DATABASE_USER_NAME="#{DATABASE_USER_NAME}"' >> #{BASH_RC}
    echo 'export DATABASE_USER_PASSWORD="#{DATABASE_USER_PASSWORD}"' >> #{BASH_RC}
    echo 'export SECRET_KEY_BASE="#{SECRET_KEY_BASE}"' >> #{BASH_RC}
    source #{BASH_RC}
  EOL
end