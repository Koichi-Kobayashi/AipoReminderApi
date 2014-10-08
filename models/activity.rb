require 'sinatra/activerecord'

@environment = ENV['RACK_ENV'] || 'development'
@dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection @dbconfig[@environment]

class Activity < ActiveRecord::Base
  self.table_name = 'activity'

  def exe(login_name)
    s = <<-SQL
SELECT
   t1.id
  ,t1.login_name
  ,t3.last_name
  ,t3.first_name
  ,t1.title
  ,TO_CHAR(t1.update_date, 'YYYY/MM/DD') AS update_date
FROM
  activity t1 JOIN activity_map t2
    ON t1.id = t2.activity_id
  LEFT JOIN turbine_user t3
    ON t1.login_name = t3.login_name
WHERE 1 = 1
AND t2.is_read = 0
AND t2.login_name = ?
ORDER BY t1.update_date desc
    SQL

    args = [s, login_name]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql)
  end
end


