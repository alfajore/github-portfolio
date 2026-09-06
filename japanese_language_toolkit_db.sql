-- ============================================================
-- Japanese Language Learning Toolkit Database
-- Schema + sample data (10 tools) + change-tracking layer.
-- Target DBMS: PostgreSQL.  Generated from the project dataset (June 2026).
-- ============================================================
 
-- Drop in reverse dependency order (safe re-run)
DROP TABLE IF EXISTS NAV_JLPT_TARGET CASCADE;
DROP TABLE IF EXISTS USER_NAVIGATION CASCADE;
DROP TABLE IF EXISTS EVIDENCE_EFFECTIVENESS CASCADE;
DROP TABLE IF EXISTS PRICING CASCADE;
DROP TABLE IF EXISTS AI_TECH_COMPONENT CASCADE;
DROP TABLE IF EXISTS AI_TECHNOLOGY CASCADE;
DROP TABLE IF EXISTS KANJI_COVERAGE CASCADE;
DROP TABLE IF EXISTS SCRIPT_COVERAGE CASCADE;
DROP TABLE IF EXISTS INSTRUCTION_METHODOLOGY CASCADE;
DROP TABLE IF EXISTS SUPPORT_LANGUAGE CASCADE;
DROP TABLE IF EXISTS TOOL CASCADE;
DROP TABLE IF EXISTS LOG_DATE_TIME CASCADE;
DROP FUNCTION IF EXISTS log_catalog_change() CASCADE;
 
-- ---------- SCHEMA (DDL) ----------
 
CREATE TABLE TOOL (
    tool_id            INTEGER      PRIMARY KEY,
    tool_name          VARCHAR(100) NOT NULL,
    developer          VARCHAR(100),
    country_of_origin  VARCHAR(50),
    release_year       INTEGER,
    platform           VARCHAR(120),
    tool_type          VARCHAR(30),
    active_status      BOOLEAN,
    official_url       VARCHAR(200)
);
 
CREATE TABLE SUPPORT_LANGUAGE (
    tool_id       INTEGER,
    language      VARCHAR(60),
    completeness  VARCHAR(10),
    source_note   VARCHAR(255),
    PRIMARY KEY (tool_id, language),
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE INSTRUCTION_METHODOLOGY (
    method_id                 INTEGER PRIMARY KEY,
    tool_id                   INTEGER,
    primary_method            VARCHAR(60),
    sla_theory_basis          VARCHAR(60),
    grammar_instruction       VARCHAR(20),
    communicative_focus       VARCHAR(20),
    skill_priority            VARCHAR(60),
    keigo_instruction         BOOLEAN,
    pitch_accent_instruction  BOOLEAN,
    jlpt_aligned              BOOLEAN,
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE SCRIPT_COVERAGE (
    script_id          INTEGER PRIMARY KEY,
    tool_id            INTEGER,
    hiragana           VARCHAR(20),
    katakana           VARCHAR(20),
    kanji              VARCHAR(20),
    romaji_dependency  VARCHAR(20),
    furigana_support   BOOLEAN,
    stroke_order       VARCHAR(10),
    writing_practice   BOOLEAN,
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE KANJI_COVERAGE (
    script_id    INTEGER,
    jlpt_level   VARCHAR(4),
    coverage     VARCHAR(10),
    source_note  VARCHAR(255),
    PRIMARY KEY (script_id, jlpt_level),
    FOREIGN KEY (script_id) REFERENCES SCRIPT_COVERAGE(script_id)
);
 
CREATE TABLE AI_TECHNOLOGY (
    ai_tech_id            INTEGER PRIMARY KEY,
    tool_id               INTEGER,
    adaptive_learning     BOOLEAN,
    chatbot_conversation  BOOLEAN,
    feedback_type         VARCHAR(40),
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE AI_TECH_COMPONENT (
    ai_tech_id  INTEGER,
    component   VARCHAR(20),
    detail      VARCHAR(60),
    PRIMARY KEY (ai_tech_id, component),
    FOREIGN KEY (ai_tech_id) REFERENCES AI_TECHNOLOGY(ai_tech_id)
);
 
CREATE TABLE PRICING (
    pricing_id         INTEGER PRIMARY KEY,
    tool_id            INTEGER,
    free_tier          BOOLEAN,
    free_tier_scope    VARCHAR(80),
    monthly_usd        DECIMAL(6,2),
    annual_usd         DECIMAL(8,2),
    lifetime_usd       DECIMAL(8,2),
    student_discount   BOOLEAN,
    value_rating       VARCHAR(12),
    price_source_note  VARCHAR(120),
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE EVIDENCE_EFFECTIVENESS (
    evidence_id           INTEGER PRIMARY KEY,
    tool_id               INTEGER,
    peer_reviewed_study   BOOLEAN,
    study_type            VARCHAR(40),
    sample_size           VARCHAR(30),
    vendor_efficacy_claim VARCHAR(12),
    app_store_rating      DECIMAL(2,1),
    community_reputation  VARCHAR(80),
    evidence_quality      VARCHAR(16),
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE USER_NAVIGATION (
    nav_id             INTEGER PRIMARY KEY,
    tool_id            INTEGER,
    use_case           VARCHAR(60),
    proficiency_entry  VARCHAR(30),
    daily_life_focus   BOOLEAN,
    kanji_memorization BOOLEAN,
    basic_conversation BOOLEAN,
    grammar_focus      BOOLEAN,
    recommended_for    VARCHAR(120),
    FOREIGN KEY (tool_id) REFERENCES TOOL(tool_id)
);
 
CREATE TABLE NAV_JLPT_TARGET (
    nav_id      INTEGER,
    jlpt_level  VARCHAR(4),
    PRIMARY KEY (nav_id, jlpt_level),
    FOREIGN KEY (nav_id) REFERENCES USER_NAVIGATION(nav_id)
);
 
-- ---------- SAMPLE DATA (DML) ----------
 
-- TOOL
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (1, 'Duolingo', 'Duolingo, Inc.', 'USA', 2011, 'iOS, Android, Web', 'Hybrid', TRUE, 'duolingo.com');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (2, 'WaniKani', 'Tofugu LLC', 'USA', 2012, 'Web, iOS, Android', 'Non-AI (SRS)', TRUE, 'wanikani.com');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (3, 'Bunpro', 'Bunpro', 'Japan', 2016, 'Web, iOS, Android', 'Non-AI (SRS)', TRUE, 'bunpro.jp');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (4, 'Anki', 'Damien Elmes / Ankitects', 'New Zealand', 2006, 'Win, Mac, Linux, iOS, Android, Web', 'Non-AI (SRS)', TRUE, 'apps.ankiweb.net');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (5, 'Genki (3rd ed.)', 'The Japan Times', 'Japan', 1999, 'Print, Digital workbook', 'Non-AI (Textbook)', TRUE, 'japantimes.co.jp/jtpublishing');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (6, 'Pimsleur Japanese', 'Simon & Schuster', 'USA', 1980, 'iOS, Android, Web, Audio', 'Non-AI (Audio)', TRUE, 'pimsleur.com');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (7, 'Speechling', 'Speechling Education Corp. (nonprofit)', 'USA', 2018, 'Web, iOS, Android', 'Hybrid', TRUE, 'speechling.com');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (8, 'Speak', 'Speak Learning, Inc.', 'USA', 2016, 'iOS, Android', 'AI-powered', TRUE, 'speak.com');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (9, 'ChatGPT', 'OpenAI', 'USA', 2022, 'Web, iOS, Android', 'AI-powered', TRUE, 'chatgpt.com');
INSERT INTO TOOL (tool_id, tool_name, developer, country_of_origin, release_year, platform, tool_type, active_status, official_url) VALUES (10, 'italki', 'italki HK Ltd.', 'Hong Kong', 2007, 'Web, iOS, Android', 'Hybrid (human tutors)', TRUE, 'italki.com');
 
-- SUPPORT_LANGUAGE
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (1, 'English', 'Full', 'Japanese course offered from several source languages; verify full 2026 list');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (1, 'Chinese', 'Full', 'Japanese course offered from several source languages; verify full 2026 list');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (1, 'Korean', 'Full', 'Japanese course offered from several source languages; verify full 2026 list');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (1, 'Vietnamese', 'Full', 'Japanese course offered from several source languages; verify full 2026 list');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (2, 'English', 'Full', 'English-only interface & explanations');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (3, 'English', 'Full', 'English-only explanations');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (4, 'Any (deck-dependent)', 'Partial', 'App UI localized to ~30+ languages; medium depends on the user-chosen deck');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (5, 'English', 'Full', 'English-medium textbook (grammar explanations in English)');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (6, 'English', 'Full', 'Japanese for English speakers; other base languages may exist — verify');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (7, 'English', 'Full', 'English-based interface; on-screen translations available in several languages');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (8, 'English', 'Partial', 'VERIFY: originally an English-teaching app; confirm it offers Japanese as a target language');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (9, 'Unbounded', 'Full', 'Operates in virtually any language; medium is user-chosen (recorded as Unbounded per codebook)');
INSERT INTO SUPPORT_LANGUAGE (tool_id, language, completeness, source_note) VALUES (10, 'Multiple (tutor-dependent)', 'Full', 'Tutors offer instruction in many languages; medium depends on the chosen tutor');
 
-- INSTRUCTION_METHODOLOGY
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (1, 1, 'Gamified drills', 'Behaviorist + Input Hypothesis', 'Implicit', 'Low', 'Vocabulary, Reading', FALSE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (2, 2, 'Spaced repetition (mnemonics)', 'Memory consolidation (SRS)', 'None', 'None', 'Kanji, Vocabulary', FALSE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (3, 3, 'Spaced repetition (cloze)', 'Output Hypothesis', 'Explicit', 'Low', 'Grammar', TRUE, FALSE, TRUE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (4, 4, 'User-built spaced repetition', 'Memory consolidation (SRS)', 'None', 'None', 'User-defined', FALSE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (5, 5, 'Communicative Language Teaching', 'Interactionist', 'Explicit', 'High', 'All four skills', TRUE, TRUE, TRUE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (6, 6, 'Audio-lingual (graduated interval recall)', 'Input Hypothesis', 'Implicit', 'Medium', 'Speaking, Listening', TRUE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (7, 7, 'Pronunciation practice (record & compare)', 'Skill acquisition / output', 'None', 'Medium', 'Speaking, Listening, Pronunciation', FALSE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (8, 8, 'AI conversation practice', 'Interactionist / Output Hypothesis', 'Implicit', 'High', 'Speaking', FALSE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (9, 9, 'LLM-based dialogic tutoring', 'Interactionist (negotiated)', 'Explicit', 'High', 'All four skills', TRUE, FALSE, FALSE);
INSERT INTO INSTRUCTION_METHODOLOGY (method_id, tool_id, primary_method, sla_theory_basis, grammar_instruction, communicative_focus, skill_priority, keigo_instruction, pitch_accent_instruction, jlpt_aligned) VALUES (10, 10, 'Task-based, tutor-led', 'Interactionist (Long)', 'Explicit', 'High', 'All four skills', TRUE, TRUE, TRUE);
 
-- SCRIPT_COVERAGE
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (1, 1, 'Full', 'Full', 'Partial', 'Optional', TRUE, 'No', FALSE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (2, 2, 'Assumed known', 'Assumed known', 'Full', 'None', TRUE, 'No', FALSE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (3, 3, 'Full', 'Full', 'Partial', 'None', TRUE, 'No', FALSE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (4, 4, 'Full', 'Full', 'Full', 'None', TRUE, 'Plugin', TRUE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (5, 5, 'Full', 'Full', 'Full', 'Early lessons only', TRUE, 'Yes', TRUE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (6, 6, 'None', 'None', 'None', 'Heavy', FALSE, 'No', FALSE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (7, 7, 'Assumed known', 'Assumed known', 'Minimal', 'Optional', TRUE, 'No', FALSE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (8, 8, 'Full', 'Full', 'Partial', 'Optional', TRUE, 'No', FALSE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (9, 9, 'Full', 'Full', 'Full', 'Optional', TRUE, 'No', TRUE);
INSERT INTO SCRIPT_COVERAGE (script_id, tool_id, hiragana, katakana, kanji, romaji_dependency, furigana_support, stroke_order, writing_practice) VALUES (10, 10, 'Tutor-dependent', 'Tutor-dependent', 'Tutor-dependent', 'Tutor-dependent', TRUE, 'Yes', TRUE);
 
-- KANJI_COVERAGE
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (1, 'N5', 'Partial', 'Duolingo kanji set (early JLPT)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (1, 'N4', 'Partial', 'Duolingo kanji set (early JLPT)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (2, 'N5', 'Full', 'Joyo-based SRS, ~2,000 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (2, 'N4', 'Full', 'Joyo-based SRS, ~2,000 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (2, 'N3', 'Full', 'Joyo-based SRS, ~2,000 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (2, 'N2', 'Full', 'Joyo-based SRS, ~2,000 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (2, 'N1', 'Full', 'Joyo-based SRS, ~2,000 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (3, 'N5', 'Partial', 'Kanji shown in grammar context');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (3, 'N4', 'Partial', 'Kanji shown in grammar context');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (3, 'N3', 'Partial', 'Kanji shown in grammar context');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (3, 'N2', 'Partial', 'Kanji shown in grammar context');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (3, 'N1', 'Partial', 'Kanji shown in grammar context');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (4, 'N5', 'Partial', 'User-supplied decks; deck-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (4, 'N4', 'Partial', 'User-supplied decks; deck-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (4, 'N3', 'Partial', 'User-supplied decks; deck-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (4, 'N2', 'Partial', 'User-supplied decks; deck-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (4, 'N1', 'Partial', 'User-supplied decks; deck-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (5, 'N5', 'Full', 'Genki vol. I–II, 317 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (5, 'N4', 'Full', 'Genki vol. I–II, 317 kanji');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (8, 'N5', 'Partial', 'Conversational context only');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (8, 'N4', 'Partial', 'Conversational context only');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (9, 'N5', 'Partial', 'On-demand, prompt-based (no fixed syllabus)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (9, 'N4', 'Partial', 'On-demand, prompt-based (no fixed syllabus)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (9, 'N3', 'Partial', 'On-demand, prompt-based (no fixed syllabus)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (9, 'N2', 'Partial', 'On-demand, prompt-based (no fixed syllabus)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (9, 'N1', 'Partial', 'On-demand, prompt-based (no fixed syllabus)');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (10, 'N5', 'Partial', 'Tutor-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (10, 'N4', 'Partial', 'Tutor-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (10, 'N3', 'Partial', 'Tutor-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (10, 'N2', 'Partial', 'Tutor-dependent');
INSERT INTO KANJI_COVERAGE (script_id, jlpt_level, coverage, source_note) VALUES (10, 'N1', 'Partial', 'Tutor-dependent');
 
-- AI_TECHNOLOGY
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (1, 1, TRUE, TRUE, 'Implicit');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (2, 2, TRUE, FALSE, 'Corrective');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (3, 3, TRUE, FALSE, 'Corrective + metalinguistic');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (4, 4, TRUE, FALSE, 'Self-graded');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (5, 5, FALSE, FALSE, 'None (textbook)');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (6, 6, FALSE, FALSE, 'Implicit');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (7, 7, TRUE, FALSE, 'Human corrective (coach)');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (8, 8, TRUE, TRUE, 'Corrective');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (9, 9, FALSE, TRUE, 'Metalinguistic');
INSERT INTO AI_TECHNOLOGY (ai_tech_id, tool_id, adaptive_learning, chatbot_conversation, feedback_type) VALUES (10, 10, TRUE, TRUE, 'Human corrective');
 
-- AI_TECH_COMPONENT
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (1, 'ASR', 'Basic');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (1, 'LLM', 'GPT-4o (Max tier)');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (1, 'TTS', 'Native audio');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (1, 'SRS', 'Half-Life Regression');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (1, 'ML-NLP', 'Core engine');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (2, 'SRS', 'Modified SM-based');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (2, 'TTS', 'Native audio');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (3, 'SRS', 'Custom SRS');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (3, 'TTS', 'Native audio');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (4, 'SRS', 'FSRS / SM-2');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (4, 'TTS', 'Add-on');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (6, 'ASR', 'Basic');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (6, 'TTS', 'Native audio');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (6, 'SRS', 'Graduated interval recall');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (7, 'ASR', 'Basic');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (7, 'SRS', 'Spaced repetition');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (8, 'ASR', 'Advanced');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (8, 'LLM', 'GPT-based');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (8, 'TTS', 'Native audio');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (9, 'LLM', 'GPT-4o / GPT-5 family');
INSERT INTO AI_TECH_COMPONENT (ai_tech_id, component, detail) VALUES (9, 'TTS', 'Native audio');
 
-- PRICING
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (1, 1, TRUE, 'Full curriculum w/ ads & energy limits', 12.99, 95.99, NULL, TRUE, 'High', 'Super tier; Max ~$168/yr. Verified Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (2, 2, TRUE, 'First 3 levels free', 9.00, 89.00, 299.00, FALSE, 'High', 'Official; lifetime ~$199 in Dec sale. Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (3, 3, TRUE, '30-day full free trial', 5.00, 50.00, 150.00, TRUE, 'Very High', 'Official bunpro.jp/pricing. JET 20% off. Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (4, 4, TRUE, 'Free on desktop/Android/web', 0.00, 0.00, 0.00, NULL, 'Very High', 'Free except AnkiMobile iOS ($24.99 one-time). Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (5, 5, FALSE, 'None (commercial textbook)', NULL, NULL, 45.00, TRUE, 'High', '~$45 per volume (text + workbook separate). Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (6, 6, TRUE, 'First lesson free', 20.95, NULL, NULL, FALSE, 'Low', 'Sub ~$20.95/mo; bundles sold separately. Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (7, 7, TRUE, 'Full curriculum + ~10 coaching sessions/month', 19.99, 119.99, NULL, FALSE, 'Very High', 'Nonprofit; Unlimited $19.99/mo, $119.99/yr. Verified Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (8, 8, FALSE, '7-day trial only', 19.99, 99.99, NULL, FALSE, 'Medium', 'Premium tier; regional pricing varies. Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (9, 9, TRUE, 'GPT-5 mini access, daily caps', 20.00, 200.00, NULL, FALSE, 'Very High', 'Plus $20/mo; Pro $200/mo. Jun 2026.');
INSERT INTO PRICING (pricing_id, tool_id, free_tier, free_tier_scope, monthly_usd, annual_usd, lifetime_usd, student_discount, value_rating, price_source_note) VALUES (10, 10, FALSE, 'No subscription (pay-per-lesson)', NULL, NULL, NULL, FALSE, 'Variable', 'Tutors set rates; community ~$8–15/hr. Jun 2026.');
 
-- EVIDENCE_EFFECTIVENESS
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (1, 1, TRUE, 'Internal + some independent', 'Large', 'Strong', 4.70, 'Mixed — habit-forming but criticized for depth', 'Medium');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (2, 2, FALSE, 'Anecdotal / community', 'N/A', 'Indirect', 4.90, 'Highly regarded for kanji retention', 'Low');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (3, 3, FALSE, 'Anecdotal / community', 'N/A', 'None', 4.70, 'Well regarded for JLPT grammar', 'Low');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (4, 4, TRUE, 'Multiple RCTs on SRS principle', 'Large (SRS research)', 'None', 4.50, 'Universally respected by researchers', 'High (method)');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (5, 5, TRUE, 'Wide academic adoption', 'Large (institutional)', 'N/A', NULL, 'Gold standard in university JSL courses', 'High');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (6, 6, TRUE, 'Internal + some independent', 'Medium', 'Strong', 4.40, 'Strong for speaking, weak for literacy', 'Medium');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (7, 7, FALSE, 'Anecdotal / community', 'N/A', 'Indirect', 4.60, 'Well regarded for pronunciation feedback', 'Low');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (8, 8, TRUE, 'Internal', 'Small', 'Strong', 4.50, 'Growing positive reputation', 'Low–Medium');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (9, 9, TRUE, 'Emerging independent (2023–25)', 'Growing', 'None', NULL, 'Highly regarded by self-directed learners', 'Medium–High');
INSERT INTO EVIDENCE_EFFECTIVENESS (evidence_id, tool_id, peer_reviewed_study, study_type, sample_size, vendor_efficacy_claim, app_store_rating, community_reputation, evidence_quality) VALUES (10, 10, TRUE, 'Tutoring efficacy literature', 'Varies', 'N/A', 4.70, 'Strong for speaking & accountability', 'Medium–High');
 
-- USER_NAVIGATION
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (1, 1, 'Basic Japanese, habit-building', 'Absolute beginner', TRUE, FALSE, TRUE, FALSE, 'New arrivals wanting low-pressure daily practice');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (2, 2, 'Kanji memorization', 'Beginner (kana known)', TRUE, TRUE, FALSE, FALSE, 'Students targeting reading & kanji literacy');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (3, 3, 'Grammar mastery', 'Beginner–Advanced', FALSE, FALSE, FALSE, TRUE, 'JLPT candidates drilling grammar points');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (4, 4, 'Custom vocab/kanji review', 'All levels', TRUE, TRUE, FALSE, FALSE, 'Self-directed learners who want full control');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (5, 5, 'Structured full curriculum', 'Absolute beginner', TRUE, TRUE, TRUE, TRUE, 'Students who want a classroom-style backbone');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (6, 6, 'Listening & speaking on the go', 'Absolute beginner', TRUE, FALSE, TRUE, FALSE, 'Commuters focused on spoken survival Japanese');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (7, 7, 'Pronunciation & speaking feedback', 'Beginner–Intermediate', TRUE, FALSE, TRUE, FALSE, 'Students who want native-coach feedback on pronunciation');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (8, 8, 'Conversation fluency', 'Beginner–Intermediate', TRUE, FALSE, TRUE, FALSE, 'Students needing speaking confidence for daily life');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (9, 9, 'Flexible tutor/explanations', 'All levels', TRUE, FALSE, TRUE, TRUE, 'Intermediate–advanced learners needing flexible practice');
INSERT INTO USER_NAVIGATION (nav_id, tool_id, use_case, proficiency_entry, daily_life_focus, kanji_memorization, basic_conversation, grammar_focus, recommended_for) VALUES (10, 10, 'Live tutored practice', 'All levels', TRUE, FALSE, TRUE, TRUE, 'Students wanting accountability & real interaction');
 
-- NAV_JLPT_TARGET
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (1, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (1, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (2, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (2, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (2, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (2, 'N2');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (2, 'N1');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (3, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (3, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (3, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (3, 'N2');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (3, 'N1');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (4, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (4, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (4, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (4, 'N2');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (4, 'N1');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (5, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (5, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (6, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (6, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (7, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (7, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (7, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (8, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (8, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (8, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (9, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (9, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (9, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (9, 'N2');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (9, 'N1');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (10, 'N5');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (10, 'N4');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (10, 'N3');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (10, 'N2');
INSERT INTO NAV_JLPT_TARGET (nav_id, jlpt_level) VALUES (10, 'N1');
 
-- ============================================================
-- CHANGE TRACKING / AUDIT LOGGING
-- Business purpose: the catalog is only useful while it is current.
-- This layer records who changed what and when, so the database can
-- be maintained on a schedule with a complete, automatic audit trail.
-- ============================================================
 
-- Audit log: one row per INSERT / UPDATE / DELETE on any catalog table.
CREATE TABLE LOG_DATE_TIME (
    log_id      SERIAL       PRIMARY KEY,
    table_name  VARCHAR(40)  NOT NULL,
    operation   VARCHAR(10)  NOT NULL,
    record_id   VARCHAR(120),
    changed_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_by  VARCHAR(60)  NOT NULL DEFAULT CURRENT_USER
);
 
-- Generic trigger function. The operation is classified from the
-- presence of the OLD and NEW row images (INSERT has no OLD row;
-- DELETE has no NEW row) rather than from a status flag. Local
-- variables are prefixed v_ so they never clash with column names.
CREATE OR REPLACE FUNCTION log_catalog_change()
RETURNS TRIGGER AS $$
DECLARE
    v_operation  VARCHAR(10);
    v_record_id  VARCHAR(120);
BEGIN
    IF OLD IS NULL THEN
        v_operation := 'INSERT';
        v_record_id := left(NEW::TEXT, 120);
    ELSIF NEW IS NULL THEN
        v_operation := 'DELETE';
        v_record_id := left(OLD::TEXT, 120);
    ELSE
        v_operation := 'UPDATE';
        v_record_id := left(NEW::TEXT, 120);
    END IF;
 
    INSERT INTO LOG_DATE_TIME (table_name, operation, record_id)
    VALUES (TG_TABLE_NAME, v_operation, v_record_id);
 
    IF NEW IS NULL THEN
        RETURN OLD;      -- DELETE
    END IF;
    RETURN NEW;          -- INSERT / UPDATE
END;
$$ LANGUAGE plpgsql;
-- Note: PostgreSQL 11+ uses EXECUTE FUNCTION; on older servers use EXECUTE PROCEDURE.
 
-- Attach the same audit trigger to every catalog table.
CREATE TRIGGER trg_log_tool         AFTER INSERT OR UPDATE OR DELETE ON TOOL                    FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_support_lang AFTER INSERT OR UPDATE OR DELETE ON SUPPORT_LANGUAGE        FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_instruction  AFTER INSERT OR UPDATE OR DELETE ON INSTRUCTION_METHODOLOGY FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_script       AFTER INSERT OR UPDATE OR DELETE ON SCRIPT_COVERAGE         FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_kanji        AFTER INSERT OR UPDATE OR DELETE ON KANJI_COVERAGE          FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_ai           AFTER INSERT OR UPDATE OR DELETE ON AI_TECHNOLOGY           FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_ai_component AFTER INSERT OR UPDATE OR DELETE ON AI_TECH_COMPONENT       FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_pricing      AFTER INSERT OR UPDATE OR DELETE ON PRICING                 FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_evidence     AFTER INSERT OR UPDATE OR DELETE ON EVIDENCE_EFFECTIVENESS  FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_navigation   AFTER INSERT OR UPDATE OR DELETE ON USER_NAVIGATION         FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
CREATE TRIGGER trg_log_nav_jlpt     AFTER INSERT OR UPDATE OR DELETE ON NAV_JLPT_TARGET         FOR EACH ROW EXECUTE FUNCTION log_catalog_change();
 
-- ---------- Example: a scheduled price update is now logged automatically ----------
-- Duolingo revises its annual Super price; LOG_DATE_TIME captures the change.
UPDATE PRICING
SET    annual_usd        = 99.99,
       price_source_note = 'Super tier price revised. Verified 2026-09.'
WHERE  tool_id = 1;
 
-- Review the audit trail (most recent first):
-- SELECT table_name, operation, record_id, changed_at, changed_by
-- FROM   LOG_DATE_TIME
-- ORDER  BY changed_at DESC;
