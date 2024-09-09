[@@@ocaml.warning "-69-27-32"]

module Window = struct
  let width = 800
  let height = 600
end

module Rect = struct
  type t =
    { x : int
    ; y : int
    ; height : int
    ; width : int
    ; color : Raylib.Color.t
    }

  let draw t () = Raylib.draw_rectangle t.x t.y t.height t.width t.color
  let to_string t = Printf.sprintf "x: %d\ny: %d\nh: %d\nw: %d" t.x t.y t.height t.width

  let generate_fully_random size_min size_max win_width win_height count =
    let rec aux count' acc =
      match count' <= 0 with
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
      | true -> acc
    in
    aux count []
  ;;
end

module Debug = struct
  let log_info str = str |> Raylib.trace_log (Raylib.TraceLogLevel.to_int Raylib.TraceLogLevel.Info)
end

let setup () =
  Raylib.init_window Window.width Window.height "Boxfill";
  Raylib.set_target_fps 60;
  ()
;;

let rec loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
    let r = Rect.generate_fully_random 5 30 Window.width Window.height 1 |> List.hd in
    Raylib.begin_drawing ();
    Rect.draw r ();
    Raylib.end_drawing ();
    loop ()
;;

let () = setup () |> loop
