require "bigdecimal"

class IcbcArgentinaAdapter
  include Capybara::DSL

  def initialize(credentials)
    @user = credentials[:user]
    @password = credentials[:password]
  end

  def login
    visit "https://www.accessbanking.com.ar/RetailHomeBankingWeb/init.do"
    fill_in "usuario", :with => @user
    fill_in "password", :with => @password
    click_link "Ingresar"

    verify_login!
    true
  end

  def download
    accounts = []
    within_frame('miboston') do
      accounts = all("div.left-column div.card:nth-child(1) div.data-table table tbody tr")
    end
    accounts.map do |account|
      {
        :adapter => :icbc_argentina,
        :user => @user,
        :id => id_for(account),
        :name => name_for(account),
        :amount => total_for(account)
      }
    end
  end

  private

    def verify_login!
      within_frame('miboston') do
        find("a.divSalir", wait: 7)
      end
    rescue
      raise FineAnts::LoginFailedError.new
    end

    def id_for(account)
      account.find("td[2]").text
    end

    def name_for(account)
      "#{account.find("td:nth-child(1)").text} - #{account.find("td:nth-child(2)").text}"
    end

    def total_for(account)
      total_string = account.find("td[3]").text
      BigDecimal.new(total_string.match(/\$(.*)$/)[1].gsub(/./,'').gsub(/,/,'.'))
    end
end
