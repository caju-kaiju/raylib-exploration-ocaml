[@@@ocaml.warning "-69-27-32-34-50"]

let random_color () =
  let r = Raylib.get_random_value 0 255 in
  let g = Raylib.get_random_value 0 255 in
  let b = Raylib.get_random_value 0 255 in
  Raylib.Color.create r g b 255
;;

module Window = struct
  let width = 1200
  let height = 1200
  let bg_color = Raylib.Color.create 255 255 255 255

  let setup () =
    Raylib.init_window width height "Boxbounce";
    Unix.gettimeofday () |> truncate |> Unsigned.UInt.of_int |> Raylib.set_random_seed;
    Raylib.set_target_fps 60;
    ()
  ;;
end

module Tile = struct
  type t =
    { size : int
    ; xpos : int
    ; ypos : int
    }

  let create xpos ypos size = { size; xpos; ypos }
  let draw t = Raylib.draw_rectangle t.xpos t.ypos t.size t.size (random_color ())
end

module Grid = struct
  type t =
    { htile_count : int
    ; wtile_count : int
    ; tiles : Tile.t list list
    }

  let draw t = t.tiles |> List.flatten |> List.iter Tile.draw

  let create height width size =
    let hcount = height / size in
    let wcount = width / size in
    let tiles =
      List.init hcount (fun j -> List.init wcount (fun i -> Tile.create (i * size) (j * size) size))
    in
    { htile_count = hcount; wtile_count = wcount; tiles }
  ;;
end

let rec loop grid =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
    Raylib.begin_drawing ();
    Raylib.clear_background Window.bg_color;
    Grid.draw grid;
    Raylib.end_drawing ();
    loop grid
;;

let () =
  let tile_size = 10 in
  let grid = Grid.create Window.height Window.width tile_size in
  Window.setup ();
  loop grid
;;
