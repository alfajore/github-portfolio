-- ============================================================
-- USER-FACING VIEWS AND FUNCTION
-- A convenience layer so a learner (or the researcher) can query the
-- catalog by goal without joining eleven tables by hand.
-- ============================================================

-- 1) One row per tool: joins the single-valued (1:1) dimensions into a
--    single learner-readable summary.
CREATE OR REPLACE VIEW v_tool_overview AS
SELECT t.tool_id,
       t.tool_name,
       t.tool_type,
       t.platform,
       im.primary_method,
       im.keigo_instruction,
       im.pitch_accent_instruction,
       sc.kanji,
       ai.feedback_type,
       p.free_tier,
       p.monthly_usd,
       p.value_rating,
       ev.evidence_quality,
       un.use_case,
       un.proficiency_entry,
       un.recommended_for
FROM   TOOL t
JOIN   INSTRUCTION_METHODOLOGY im ON im.tool_id = t.tool_id
JOIN   SCRIPT_COVERAGE         sc ON sc.tool_id = t.tool_id
JOIN   AI_TECHNOLOGY           ai ON ai.tool_id = t.tool_id
JOIN   PRICING                 p  ON p.tool_id  = t.tool_id
JOIN   EVIDENCE_EFFECTIVENESS  ev ON ev.tool_id = t.tool_id
JOIN   USER_NAVIGATION         un ON un.tool_id = t.tool_id;

-- 2) Tool x JLPT level, for level-based search (uses the parsed child table).
CREATE OR REPLACE VIEW v_tool_by_jlpt AS
SELECT t.tool_id, t.tool_name, njt.jlpt_level,
       un.use_case, p.free_tier, p.monthly_usd
FROM   TOOL t
JOIN   USER_NAVIGATION un  ON un.tool_id = t.tool_id
JOIN   NAV_JLPT_TARGET njt ON njt.nav_id = un.nav_id
JOIN   PRICING         p   ON p.tool_id  = t.tool_id;

-- 3) Kanji coverage by level, learner-readable.
CREATE OR REPLACE VIEW v_kanji_by_level AS
SELECT t.tool_id, t.tool_name, kc.jlpt_level, kc.coverage
FROM   TOOL t
JOIN   SCRIPT_COVERAGE sc ON sc.tool_id  = t.tool_id
JOIN   KANJI_COVERAGE  kc ON kc.script_id = sc.script_id;

-- 4) Medium of instruction, for learners who do not study in English.
CREATE OR REPLACE VIEW v_medium_of_instruction AS
SELECT t.tool_id, t.tool_name, sl.language, sl.completeness
FROM   TOOL t
JOIN   SUPPORT_LANGUAGE sl ON sl.tool_id = t.tool_id;

-- 5) Parameterised search: tools for a JLPT level, optionally free only.
--    NULL level = any level; p_free_only = TRUE limits to tools with a free tier.
CREATE OR REPLACE FUNCTION find_tools(
    p_jlpt      VARCHAR DEFAULT NULL,
    p_free_only BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (tool_name VARCHAR, jlpt_level VARCHAR, free_tier BOOLEAN,
               monthly_usd DECIMAL, use_case VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT v.tool_name, v.jlpt_level, v.free_tier, v.monthly_usd, v.use_case
    FROM   v_tool_by_jlpt v
    WHERE  (p_jlpt IS NULL OR v.jlpt_level = p_jlpt)
    AND    (p_free_only = FALSE OR v.free_tier = TRUE)
    ORDER  BY v.free_tier DESC, v.monthly_usd NULLS FIRST, v.tool_name;
END;
$$ LANGUAGE plpgsql;

-- Example uses:
-- SELECT * FROM v_tool_overview;                 -- full comparison table
--  SELECT * FROM find_tools('N5', TRUE);          -- free tools that reach N5
   SELECT * FROM v_kanji_by_level WHERE jlpt_level = 'N1';
--   SELECT * FROM v_medium_of_instruction WHERE language = 'Vietnamese';