class PickCheckerService
  attr_reader :users_repository, :latest_checker
  private :users_repository, :latest_checker

  def initialize(args)
    @users_repository = UsersRepository.new
    @latest_checker = args.fetch(:latest_checker)
  end

  def call
    pick_random
  end

  private

  def pick_random
    users = prepare_users
    users.sample(1).first
  end

  def prepare_users
    users - [latest_checker]
  end

  def users
    users_repository.all.to_a
  end
end
