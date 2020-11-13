export const SERVER_ADDRESS = process.env.REACT_APP_SERVER_ADDRESS || 'localhost:4000';
export const API_BASE_URL = `http://${SERVER_ADDRESS}`;
export const CHANNEL_BASE_URL = `ws://${SERVER_ADDRESS}`;