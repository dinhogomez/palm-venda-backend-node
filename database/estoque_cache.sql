-- =============================================================
-- pi.estoque_cache — Materialized View de cache de estoque
-- =============================================================
-- Criada automaticamente pelo server.js na inicialização.
-- Use este script apenas para criação/recriação manual.
--
-- Uso manual:
--   psql -U frigo <banco> -f database/estoque_cache.sql
-- =============================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS pi.estoque_cache AS
  SELECT * FROM pi.estoque_atual
WITH DATA;

-- Índice único obrigatório para REFRESH CONCURRENTLY (não bloqueia leituras)
CREATE UNIQUE INDEX IF NOT EXISTS idx_estoque_cache_unique
  ON pi.estoque_cache(codigo_empresas, codigo_filiais, codigo_marchant, codigo_produtos);

-- Para atualizar manualmente:
-- REFRESH MATERIALIZED VIEW CONCURRENTLY pi.estoque_cache;

-- Para recriar do zero:
-- DROP MATERIALIZED VIEW IF EXISTS pi.estoque_cache;
-- (então execute o CREATE acima novamente)
