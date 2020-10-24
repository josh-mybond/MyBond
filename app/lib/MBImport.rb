require 'csv'

class MBImport

  def initialize
  end

  def postcodes

    table = CSV.parse(File.read("#{Rails.root}/import/Postcode Risk-Table 1.csv"), headers: false)

    0.upto(table[0].count - 1) do |i|
      postcode = table[0][i]
      risk     = table[2][i].to_f

      if !postcode.nil? or postcode != "Grand Total"
        puts "#{postcode} - #{risk}"

        pc = Postcode.find_or_create_by(postcode: postcode)
        pc.risk = risk
        pc.save
      end

    end

  end

end
