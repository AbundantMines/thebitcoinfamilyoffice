// BFO Team Comments API — Cloudflare D1 backed
export async function onRequestPost(context) {
  const { request, env } = context;
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json',
  };

  try {
    const body = await request.json();
    const { resource, reviewer, rating, comment, timestamp } = body;
    if (!resource || !reviewer || !comment) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), { status: 400, headers });
    }
    const id = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    const ts = timestamp || new Date().toISOString();

    await env.DB.prepare(
      'INSERT INTO comments (id, timestamp, resource, reviewer, rating, comment) VALUES (?, ?, ?, ?, ?, ?)'
    ).bind(id, ts, resource, reviewer, rating || '', comment).run();

    return new Response(JSON.stringify({ success: true, id }), { status: 200, headers });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500, headers });
  }
}

export async function onRequestGet(context) {
  const { env } = context;
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json',
    'Cache-Control': 'no-cache',
  };

  try {
    const { results } = await env.DB.prepare(
      'SELECT * FROM comments ORDER BY timestamp DESC LIMIT 500'
    ).all();
    return new Response(JSON.stringify({ comments: results }), { status: 200, headers });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500, headers });
  }
}

export async function onRequestOptions() {
  return new Response(null, {
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  });
}
