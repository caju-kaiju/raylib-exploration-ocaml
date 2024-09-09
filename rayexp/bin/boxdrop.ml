[@@@ocaml.warning "-69-27-32"]

module Window = struct
  let width = 800
  let height = 600
  let bg_color = Raylib.Color.create 100 100 100 255

  let setup () =
    Raylib.init_window width height "Boxdrop";
    Unix.gettimeofday () |> truncate |> Unsigned.UInt.of_int |> Raylib.set_random_seed;
    Raylib.set_target_fps 60;
    ()
  ;;
end

module Rect = struct
  type t =
    { x : int
    ; y : int
    ; height : int
    ; width : int
    ; color : Raylib.Color.t
    }

  let draw t =
    Raylib.draw_rectangle t.x t.y t.height t.width t.color;
    ()
  ;;

  let apply_gravity box =
    { x = box.x; y = box.y + 1; height = box.height; width = box.width; color = box.color }
  ;;

  let window_collision t =
    let new_x =
      if t.x + t.width >= Window.width then Window.width - t.width else if t.x < 0 then 0 else t.x
    in
    let new_y =
      if t.y + t.height >= Window.height then Window.height - t.height else if t.y < 0 then 0 else t.y
    in
    { x = new_x; y = new_y; height = t.height; width = t.width; color = t.color }
  ;;

  let to_string t = Printf.sprintf "x: %d\ny: %d\nh: %d\nw: %d" t.x t.y t.height t.width

  let generate_fully_random size_min size_max win_width win_height count =
    let rec aux count' acc =
      match count' <= 0 with
      | true -> acc
      | false ->
        let r = Raylib.get_random_value 0 255 in
        let g = Raylib.get_random_value 0 255 in
        let b = Raylib.get_random_value 0 255 in
        aux
          (count' - 1)
          ({ x = Raylib.get_random_value 0 win_width
           ; y = Raylib.get_random_value 0 win_height
           ; height = Raylib.get_random_value size_min size_max
           ; width = Raylib.get_random_value size_min size_max
           ; color = Raylib.Color.create r g b 255
           }
           :: acc)
    in
    aux count []
  ;;
end

module GameState = struct
  type t = { boxes : Rect.t list }

  let init () = { boxes = Rect.generate_fully_random 30 30 Window.width Window.height 10 }
end

module Debug = struct
  let log_info str = str |> Raylib.trace_log (Raylib.TraceLogLevel.to_int Raylib.TraceLogLevel.Info)
  let log_boxes boxes = boxes |> List.map Rect.to_string |> List.iter log_info
end

let rec loop (game_state : GameState.t) =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
    let (new_game_state : GameState.t) =
      { boxes = game_state.boxes |> List.map Rect.apply_gravity |> List.map Rect.window_collision }
    in
    Raylib.begin_drawing ();
    Raylib.clear_background Window.bg_color;
    List.iter Rect.draw new_game_state.boxes;
    Raylib.end_drawing ();
    loop new_game_state
;;

let () =
  Window.setup ();
  let game_state = GameState.init () in
  (* Debug.log_boxes game_state.boxes; *)
  game_state |> loop
;;
