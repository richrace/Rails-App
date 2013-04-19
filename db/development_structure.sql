CREATE TABLE "broadcasts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "content" text, "user_id" integer, "created_at" datetime, "updated_at" datetime, "title" varchar(255));
CREATE TABLE "broadcasts_feeds" ("broadcast_id" integer, "feed_id" integer);
CREATE TABLE "feeds" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "images" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "photo_file_name" varchar(255), "photo_content_type" varchar(255), "photo_file_size" integer);
CREATE TABLE "jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "broadcast_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "newsblogs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "broadcast_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "user_details" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(40), "salt" varchar(40), "crypted_password" varchar(40), "user_id" integer);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "surname" varchar(255) NOT NULL, "firstname" varchar(255) NOT NULL, "phone" varchar(255), "grad_year" integer NOT NULL, "jobs" boolean DEFAULT 'f', "email" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_users_on_email" ON "users" ("email");
CREATE INDEX "index_users_on_surname" ON "users" ("surname");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20111203180710');

INSERT INTO schema_migrations (version) VALUES ('20090729085255');

INSERT INTO schema_migrations (version) VALUES ('20090729132630');

INSERT INTO schema_migrations (version) VALUES ('20090803144012');

INSERT INTO schema_migrations (version) VALUES ('20110807175346');

INSERT INTO schema_migrations (version) VALUES ('20110913110921');

INSERT INTO schema_migrations (version) VALUES ('20110915081902');

INSERT INTO schema_migrations (version) VALUES ('20111203143809');

INSERT INTO schema_migrations (version) VALUES ('20111203');