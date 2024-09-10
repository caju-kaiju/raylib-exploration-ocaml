[@@@ocaml.warning "-69-27-32-34-50"]

module Window = struct
  let width = 1200
  let height = 1200
  let bg_color = Raylib.Color.create 100 100 100 255

  let setup () =
    Raylib.init_window width height "Boxbounce";
    Unix.gettimeofday () |> truncate |> Unsigned.UInt.of_int |> Raylib.set_random_seed;
    Raylib.set_target_fps 60;
    ()
  ;;
end

(* module Position = struct *)
(*   type t = Raylib.Vector2.t *)
(* end *)

(* module Velocity = struct *)
(*   type t = Raylib.Vector2.t *)

(*   let clamp_x min max t = *)
(*     let new_x = *)
(*       if Raylib.Vector2.x t < min then min else if Raylib.Vector2.x t > max then max else Raylib.Vector2.x t *)
(*     in *)
(*     Raylib.Vector2.create new_x (Raylib.Vector2.y t) *)
(*   ;; *)

(*   let clamp_y min max t = *)
(*     let new_y = *)
(*       if Raylib.Vector2.y t < min then min else if Raylib.Vector2.y t > max then max else Raylib.Vector2.y t *)
(*     in *)
(*     Raylib.Vector2.create (Raylib.Vector2.x t) new_y *)
(*   ;; *)
(* end *)

(* module Acceleration = struct *)
(*   type t = Raylib.Vector2.t *)
(* end *)

(* module Rect = struct *)
(*   type t = *)
(*     { pos : Position.t *)
(*     ; vel : Velocity.t *)
(*     ; acc : Acceleration.t *)
(*     ; height : int *)
(*     ; width : int *)
(*     ; color : Raylib.Color.t *)
(*     } *)

(*   let draw t = *)
(*     Raylib.draw_rectangle *)
(*       (t.pos |> Raylib.Vector2.x |> truncate) *)
(*       (t.pos |> Raylib.Vector2.y |> truncate) *)
(*       t.height *)
(*       t.width *)
(*       t.color; *)
(*     () *)
(*   ;; *)

(*   let apply_gravity t = *)
(*     let ax = Raylib.Vector2.x t.acc in *)
(*     let ay = Raylib.Vector2.y t.acc in *)
(*     let new_acc = Raylib.Vector2.create ax (ay +. 0.01) in *)
(*     { pos = t.pos; vel = t.vel; acc = new_acc; height = t.height; width = t.width; color = t.color } *)
(*   ;; *)

(*   let apply_acceleration t = *)
(*     let vx = Raylib.Vector2.x t.vel in *)
(*     let vy = Raylib.Vector2.y t.vel in *)
(*     let ax = Raylib.Vector2.x t.acc in *)
(*     let ay = Raylib.Vector2.y t.acc in *)
(*     let new_vel = Raylib.Vector2.create (vx +. ax) (vy +. ay) in *)
(*     { pos = t.pos; vel = new_vel; acc = t.acc; height = t.height; width = t.width; color = t.color } *)
(*   ;; *)

(*   let apply_velocity t = *)
(*     let vx = Raylib.Vector2.x t.vel in *)
(*     let vy = Raylib.Vector2.y t.vel in *)
(*     let px = Raylib.Vector2.x t.pos in *)
(*     let py = Raylib.Vector2.y t.pos in *)
(*     let new_pos = Raylib.Vector2.create (vx +. px) (vy +. py) in *)
(*     { pos = new_pos; vel = t.vel; acc = t.acc; height = t.height; width = t.width; color = t.color } *)
(*   ;; *)

(*   let window_collision t = *)
(*     let new_x : float = *)
(*       if (t.pos |> Raylib.Vector2.x |> truncate) + t.width >= Window.width *)
(*       then Window.width - t.width |> Float.of_int *)
(*       else if t.pos |> Raylib.Vector2.x |> truncate < 0 *)
(*       then 0. *)
(*       else Raylib.Vector2.x t.pos *)
(*     in *)
(*     let new_y : float = *)
(*       if (t.pos |> Raylib.Vector2.y |> truncate) + t.height >= Window.height *)
(*       then Window.height - t.height |> Float.of_int *)
(*       else if t.pos |> Raylib.Vector2.y |> truncate < 0 *)
(*       then 0. *)
(*       else Raylib.Vector2.y t.pos *)
(*     in *)
(*     let new_vel = *)
(*       if new_y >= float_of_int (Window.height - t.height) then Raylib.Vector2.create 0. (-0.5) else t.vel *)
(*     in *)
(*     let new_acc = *)
(*       if new_y >= float_of_int (Window.height - t.height) then Raylib.Vector2.create 0. (-0.3) else t.acc *)
(*     in *)
(*     { pos = Raylib.Vector2.create new_x new_y *)
(*     ; vel = new_vel *)
(*     ; acc = new_acc *)
(*     ; height = t.height *)
(*     ; width = t.width *)
(*     ; color = t.color *)
(*     } *)
(*   ;; *)

(*   let to_string t = *)
(*     Printf.sprintf *)
(*       "pos:\t%f, %f\nvel:\t%f, %f\nacc:\t%f, %f\n(h, w) : (%d, %d)" *)
(*       (Raylib.Vector2.x t.pos) *)
(*       (Raylib.Vector2.y t.pos) *)
(*       (Raylib.Vector2.x t.vel) *)
(*       (Raylib.Vector2.y t.vel) *)
(*       (Raylib.Vector2.x t.acc) *)
(*       (Raylib.Vector2.y t.acc) *)
(*       t.height *)
(*       t.width *)
(*   ;; *)

(*   let generate_fully_random size_min size_max win_width win_height count = *)
(*     let rec aux count' acc = *)
(*       match count' <= 0 with *)
(*       | true -> acc *)
(*       | false -> *)
(*         let r = Raylib.get_random_value 0 255 in *)
(*         let g = Raylib.get_random_value 0 255 in *)
(*         let b = Raylib.get_random_value 0 255 in *)
(*         aux *)
(*           (count' - 1) *)
(*           ({ pos = *)
(*                Raylib.Vector2.create *)
(*                  (Raylib.get_random_value 0 win_width |> Float.of_int) *)
(*                  (Raylib.get_random_value 0 win_height |> Float.of_int) *)
(*            ; vel = Raylib.Vector2.create 0. 0. *)
(*            ; acc = Raylib.Vector2.create 0. 0. *)
(*            ; height = Raylib.get_random_value size_min size_max *)
(*            ; width = Raylib.get_random_value size_min size_max *)
(*            ; color = Raylib.Color.create r g b 255 *)
(*            } *)
(*            :: acc) *)
(*     in *)
(*     aux count [] *)
(*   ;; *)
(* end *)

(* module GameState = struct *)
(*   type t = { boxes : Rect.t list } *)

(*   let init () = { boxes = Rect.generate_fully_random 30 30 Window.width Window.height 10 } *)
(* end *)

(* module Debug = struct *)
(*   let log_info str = "\n" ^ str |> Raylib.trace_log (Raylib.TraceLogLevel.to_int Raylib.TraceLogLevel.Info) *)
(*   let log_box box = box |> Rect.to_string |> log_info *)
(*   let log_boxes boxes = boxes |> List.map Rect.to_string |> List.iter log_info *)
(* end *)

(*
   Need size of window
   Need size of box
   Need to add padding if necessary
*)

TODO: take in number of vert squares, number of horz squares. Calc size from that.

module Square = struct
  let side = 5
end

module GameState = struct
  module Grid = struct
    type t =
      { nwidth : int
      ; nheight : int
      ; padding : int
      }
  end

  let init w_width w_height square_len padding : Grid.t =
    let nwdith' = w_width / square_len in
    let nheight' = w_height / square_len in
    { nwidth = nwdith'; nheight = nheight'; padding = 0 }
  ;;
end

let rec loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
    Raylib.begin_drawing ();
    Raylib.clear_background Window.bg_color;
    Raylib.end_drawing ();
    loop ()
;;

let () =
  Window.setup ();
  loop ()
;;
