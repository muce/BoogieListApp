Resque::Mailer.error_handler = lambda { |mailer, message, error, action, args|
  # Necessary to re-enqueue jobs that receieve the SIGTERM signal
  puts "RESQUE MAILER ERROR"
  if error.is_a?(Resque::TermException)
    Resque.enqueue(mailer, action, *args)
  else
    raise error
  end
}