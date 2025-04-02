INSERT INTO users (
  email,
  password_hash,
  first_name,
  last_name,
  created_at,
  updated_at,
  role,
  deleted_at
)
VALUES (
  'user@example.com',
  'hashed_password',
  'John',
  'Doe',
  NOW(),
  NOW(),
  'admin',
  NULL
);


SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users';
