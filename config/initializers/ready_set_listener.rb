Rails.application.configure do
  # https://edgeguides.rubyonrails.org/active_support_instrumentation.html#sql-active-record
  ActiveSupport::Notifications.subscribe "sql.active_record" do |event|
    sql_statement = event.payload[:sql]
    # filter on SELECT statements that aren't looking at Postgres system tables
    # https://docs.readyset.io/reference/features/queries
    if (sql_statement.match?(/^SELECT/i) && !(sql_statement.match? /pg_*/))
      Rails.logger.info "\nSQL statement is -> #{sql_statement}"
      Rails.logger.info "Values are #{event.payload[:type_casted_binds]}\n"
      # this is a db connection - not http blah
      #   if ReadySet.cacheable?(query)
      #     # cache it or notify user?
      #   end
    end
  end
end
