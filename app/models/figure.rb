class Figure < ActiveRecord::Base
    self.inheritance_column = nil

    belongs_to :game

    validates :game_id, :type, :color, presence: true
    validates :type, inclusion: { in: %w(k q r n b p) }
    validates :color, inclusion: { in: %w(white black) }

    scope :on_the_board, -> { where.not(cell_name: nil) }
    scope :current_color, -> (color) { where(color: color) }
    scope :other_color, -> (color) { where.not(color: color) }
end
