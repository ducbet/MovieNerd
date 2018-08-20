var deleted_seats = new Set();
var map;

function update_room($room_data) {
  map = full_a_map($room_data.data("map"));
  var sc = $("#seat-map").seatCharts({
    map: map,
    naming : {
      top : false,
      getLabel : function (character, row, column) {
        return column;
      }
    },
    legend : {
      node : $("#legend"),
      items : [
        ["a", "selected", $room_data.data("i18n_seat")],
        ["a", "deleted", $room_data.data("i18n_no_seat")]
      ]
    },
    click: function () {
      switch(this.status()) {
        case "deleted":
          add_seat(this.settings.id);
          return "selected";
        case "selected":
          delete_seat(this.settings.id);
          return "deleted";
        default:
          return this.style();
      }
    }
  });
  sc.get(sc.seatIds).status("selected");
  deleted_seats = new Set();
  var dels = $room_data.data("deleted_seats");
  sc.get(dels).status("deleted");
  dels.forEach(function(del) {
    deleted_seats.add(del);
  });
};

function add_seat(seat_id) {
  var $field_seat_no = $("#field_seat_no");
  field_seat_no.value++;

  deleted_seats.delete(seat_id);

  update_num_row(seat_id);
  update_max_seat_per_row(seat_id);
}

function delete_seat(seat_id) {
  var $field_seat_no = $("#field_seat_no");
  field_seat_no.value--;

  deleted_seats.add(seat_id);

  update_num_row(seat_id);
  update_max_seat_per_row(seat_id);
}

function update_num_row(seat_id) {
  var seat_id_splited = seat_id.split("_");

  var same_row = [...deleted_seats].filter(function(deleted_seat) {
    return seat_id_splited[0] == deleted_seat.split("_")[0];
  });

  if (same_row.length == field_num.value && deleted_seats.has(seat_id)) {
    field_row.value--;
  }
  if (same_row.length == field_num.value - 1 && !deleted_seats.has(seat_id)) {
    field_row.value++;
  }
}

function update_max_seat_per_row(seat_id) {
  var seat_id_splited = seat_id.split("_");

  var same_col = [...deleted_seats].filter(function(deleted_seat) {
    return seat_id_splited[1] == deleted_seat.split("_")[1];
  });

  if (same_col.length == field_row.value && deleted_seats.has(seat_id)) {
    field_num.value--;
  }
  if (same_col.length == field_row.value - 1 && !deleted_seats.has(seat_id)) {
    field_num.value++;
  }
}

function modify_seat_in_map(seat_id, new_status) {
  var seat_id_splited = seat_id.split("_"),
      row_num = parseInt(seat_id_splited[0]) - 1,
      col_num = parseInt(seat_id_splited[1]) - 1,
      deleted_row = map[row_num];
  if (row_num >= map.length || col_num >= map[0].length) {
    return;
  }
  delete map[row_num];
  deleted_row = deleted_row.substring(0, col_num) + new_status +
                deleted_row.substring(col_num + 1);

  map[row_num] = deleted_row;
}

function full_a_map(map) {
  for (i = 0; i < map.length; i++) {
      map[i] = map[i].split("_").join("a");
  }
  return map;
}

function slice_map(field_row, field_num) {
  var new_map = [];
  if (field_row > map.length) {
    for(i = 0; i < field_row - map.length; i++) {
      map.push("a".repeat(field_num));
    }
  }
  if (field_num > map[0].length) {
    for(i = 0; i < map.length; i++) {
      map[i] += "a".repeat(field_num - map[i].length);
    }
  }
  map.slice(0, field_row).forEach(function(row) {
    new_map.push(row.slice(0, field_num));
  })
  map = new_map;
}

function room_changed($room_data) {
  reset_seat_area($room_data);
  $room_data.data("map", map);
  $room_data.data("deleted_seats", Array.from(deleted_seats));

  var $field_seat_no = $("#field_seat_no");
  field_seat_no.value = num_available_seats(map);

  $(document).trigger("turbolinks:load");
};

function num_available_seats(map) {
  var count = 0;
  map.forEach(function(row) {
    for (i = 0; i < row.length; i++) {
      if(row[i] == "a") count++;
    }
  });
  return count;
}

function get_map() {
  var $field_map = $("#field_map");
  merge_deleted_seats_to_map();
  field_map.value = map;
};

function merge_deleted_seats_to_map() {
  deleted_seats.forEach(function(seat_id) {
    modify_seat_in_map(seat_id, "_");
  });
}

function change_room_listener($room_data) {
  var $field_row = $("#field_row"),
      $field_num = $("#field_num");

  $field_row.on("change", function() {
    slice_map(field_row.value, field_num.value);
    room_changed($room_data, );
  });

  $field_num.on("change", function() {
    slice_map(field_row.value, field_num.value);
    room_changed($room_data);
  });
}
