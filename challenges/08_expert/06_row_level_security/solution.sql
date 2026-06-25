ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS user_documents ON documents;
CREATE POLICY user_documents ON documents
    USING (owner = current_user);

SET ROLE test_user;
SELECT doc_id, owner, title FROM documents;
RESET ROLE;
