import {Socket} from "phoenix";
import {CHANNEL_BASE_URL} from "./constants";

let socket = new Socket(CHANNEL_BASE_URL + "/socket", {});
socket.connect();

export default socket;