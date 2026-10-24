// GET /photos/<fichier> — sert les photos envoyées depuis le tableau de contrôle (stockées dans R2)
export async function onRequestGet({ params, env }) {
  const key = (params.path || []).join('/');
  if (!env.PHOTOS || !/^[A-Za-z0-9._-]+$/.test(key)) return new Response('Not found', { status: 404 });
  const obj = await env.PHOTOS.get(key);
  if (!obj) return new Response('Not found', { status: 404 });
  const headers = new Headers();
  obj.writeHttpMetadata(headers);
  headers.set('etag', obj.httpEtag);
  headers.set('cache-control', 'public, max-age=31536000, immutable');
  return new Response(obj.body, { headers });
}
