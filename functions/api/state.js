// GET /api/state — état public du site (lu par le JavaScript des pages si besoin)
import { json, loadState, computeTonight } from '../_lib.js';

export async function onRequestGet({ env }) {
  const state = await loadState(env);
  return json({ ...state, tonight: computeTonight(state) }, 200, { 'cache-control': 'public, max-age=60' });
}
