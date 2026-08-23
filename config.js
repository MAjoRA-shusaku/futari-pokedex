// anon key はブラウザ用の公開キーです。service_role key は絶対に入れないでください。
window.FUTARI_DEX_CONFIG = { supabaseUrl: 'https://gmjtfuoahwxcpkphbqva.supabase.co', supabaseAnonKey: 'sb_publishable_THlsCqAgckgUHzpyoh8zGw_3skC30RO', room: 'aika-shusaku-2026', members: 'あいか & しゅうさく' };
document.addEventListener('DOMContentLoaded',()=>{const e=document.getElementById('memberNames');if(e)e.textContent=window.FUTARI_DEX_CONFIG.members||'';});
