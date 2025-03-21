create table "public"."atm_tools" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."atm_tools" enable row level security;

CREATE UNIQUE INDEX atm_tools_pkey ON public.atm_tools USING btree (id);

alter table "public"."atm_tools" add constraint "atm_tools_pkey" PRIMARY KEY using index "atm_tools_pkey";

grant delete on table "public"."atm_tools" to "anon";

grant insert on table "public"."atm_tools" to "anon";

grant references on table "public"."atm_tools" to "anon";

grant select on table "public"."atm_tools" to "anon";

grant trigger on table "public"."atm_tools" to "anon";

grant truncate on table "public"."atm_tools" to "anon";

grant update on table "public"."atm_tools" to "anon";

grant delete on table "public"."atm_tools" to "authenticated";

grant insert on table "public"."atm_tools" to "authenticated";

grant references on table "public"."atm_tools" to "authenticated";

grant select on table "public"."atm_tools" to "authenticated";

grant trigger on table "public"."atm_tools" to "authenticated";

grant truncate on table "public"."atm_tools" to "authenticated";

grant update on table "public"."atm_tools" to "authenticated";

grant delete on table "public"."atm_tools" to "service_role";

grant insert on table "public"."atm_tools" to "service_role";

grant references on table "public"."atm_tools" to "service_role";

grant select on table "public"."atm_tools" to "service_role";

grant trigger on table "public"."atm_tools" to "service_role";

grant truncate on table "public"."atm_tools" to "service_role";

grant update on table "public"."atm_tools" to "service_role";


