class Admin::RoomsController < Admin::BaseController
  def index
    @rooms = Room.page(params[:page]).per Settings.admin.per_page
  end

  def new
    @support = new_room %w(aaaaaa aaaaaa aaaaaa aaaaaa aaaaaa)
  end

  def create
    @support = new_room params_map
    @support.room.name = params_name
    if @support.room.save
      flash[:success] = t "flash.create_room_success"
      redirect_to admin_room_url(@support.room)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @room = Room.find_by id: params[:id]
    return if @room
    redirect_to root_url
    flash[:danger] = t "flash.no_room"
  end

  def edit
    @room = Room.find_by id: params[:id]
    @support = editable_room @room
  end

  def update
    @room = Room.find_by id: params[:id]
    if @room.set_map params_map
      redirect_to admin_room_url @room
    else
      flash[:danger] = t "flash.edit_faild"
      redirect_to edit_admin_room_url @room
    end
  end

  private

  def params_name
    params.require(:room).permit(:name)[:name]
  end

  def params_map
    params.require(:field_map).split ","
  end

  def new_room map
    room = Room.new
    set_map room, map
    AdminRoomSupport.new room, map
  end

  def editable_room room
    map = room.full_a_map
    AdminRoomSupport.new room, map
  end

  def set_map room, map
    map.each_with_index do |row, row_index|
      row.split("").each_with_index do |pos, pos_index|
        next unless pos == "a"
        room.seats.build row: row_index + 1, number: pos_index + 1
      end
    end
    room.seat_no = room.seats.size
  end
end
