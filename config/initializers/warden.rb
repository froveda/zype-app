require Rails.root.join('lib/strategies/zype_login_strategy')

Warden::Strategies.add(:zype_login, ZypeLoginStrategy)