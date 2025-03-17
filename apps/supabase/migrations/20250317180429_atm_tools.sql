revoke delete on table "public"."atm_tools" from "anon";

revoke insert on table "public"."atm_tools" from "anon";

revoke references on table "public"."atm_tools" from "anon";

revoke select on table "public"."atm_tools" from "anon";

revoke trigger on table "public"."atm_tools" from "anon";

revoke truncate on table "public"."atm_tools" from "anon";

revoke update on table "public"."atm_tools" from "anon";

revoke delete on table "public"."atm_tools" from "authenticated";

revoke insert on table "public"."atm_tools" from "authenticated";

revoke references on table "public"."atm_tools" from "authenticated";

revoke select on table "public"."atm_tools" from "authenticated";

revoke trigger on table "public"."atm_tools" from "authenticated";

revoke truncate on table "public"."atm_tools" from "authenticated";

revoke update on table "public"."atm_tools" from "authenticated";

revoke delete on table "public"."atm_tools" from "service_role";

revoke insert on table "public"."atm_tools" from "service_role";

revoke references on table "public"."atm_tools" from "service_role";

revoke select on table "public"."atm_tools" from "service_role";

revoke trigger on table "public"."atm_tools" from "service_role";

revoke truncate on table "public"."atm_tools" from "service_role";

revoke update on table "public"."atm_tools" from "service_role";

alter table "public"."atm_tools" drop constraint "atm_tools_pkey";

drop index if exists "public"."atm_tools_pkey";

drop table "public"."atm_tools";

create table "public"."tool_capabilities" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "tool_id" bigint,
    "name" text not null,
    "description" text not null,
    "key" text not null
);


alter table "public"."tool_capabilities" enable row level security;

create table "public"."tools" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "tool_handle" text not null,
    "owner_id" uuid not null,
    "name" text not null,
    "description" text,
    "owner_username" text not null,
    "type" text not null
);


alter table "public"."tools" enable row level security;

CREATE UNIQUE INDEX atm_tool_capabilities_pkey ON public.tool_capabilities USING btree (id);

CREATE UNIQUE INDEX unique_owner_id_tool_handle ON public.tools USING btree (owner_id, tool_handle);

CREATE UNIQUE INDEX unique_tool_cap ON public.tool_capabilities USING btree (tool_id, name);

CREATE UNIQUE INDEX atm_tools_pkey ON public.tools USING btree (id);

alter table "public"."tool_capabilities" add constraint "atm_tool_capabilities_pkey" PRIMARY KEY using index "atm_tool_capabilities_pkey";

alter table "public"."tools" add constraint "atm_tools_pkey" PRIMARY KEY using index "atm_tools_pkey";

alter table "public"."tool_capabilities" add constraint "atm_tool_capabilities_tool_id_fkey" FOREIGN KEY (tool_id) REFERENCES tools(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."tool_capabilities" validate constraint "atm_tool_capabilities_tool_id_fkey";

alter table "public"."tool_capabilities" add constraint "unique_tool_cap" UNIQUE using index "unique_tool_cap";

alter table "public"."tools" add constraint "atm_tools_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES auth.users(id) not valid;

alter table "public"."tools" validate constraint "atm_tools_owner_id_fkey";

alter table "public"."tools" add constraint "unique_owner_id_tool_handle" UNIQUE using index "unique_owner_id_tool_handle";

grant delete on table "public"."tool_capabilities" to "anon";

grant insert on table "public"."tool_capabilities" to "anon";

grant references on table "public"."tool_capabilities" to "anon";

grant select on table "public"."tool_capabilities" to "anon";

grant trigger on table "public"."tool_capabilities" to "anon";

grant truncate on table "public"."tool_capabilities" to "anon";

grant update on table "public"."tool_capabilities" to "anon";

grant delete on table "public"."tool_capabilities" to "authenticated";

grant insert on table "public"."tool_capabilities" to "authenticated";

grant references on table "public"."tool_capabilities" to "authenticated";

grant select on table "public"."tool_capabilities" to "authenticated";

grant trigger on table "public"."tool_capabilities" to "authenticated";

grant truncate on table "public"."tool_capabilities" to "authenticated";

grant update on table "public"."tool_capabilities" to "authenticated";

grant delete on table "public"."tool_capabilities" to "service_role";

grant insert on table "public"."tool_capabilities" to "service_role";

grant references on table "public"."tool_capabilities" to "service_role";

grant select on table "public"."tool_capabilities" to "service_role";

grant trigger on table "public"."tool_capabilities" to "service_role";

grant truncate on table "public"."tool_capabilities" to "service_role";

grant update on table "public"."tool_capabilities" to "service_role";

grant delete on table "public"."tools" to "anon";

grant insert on table "public"."tools" to "anon";

grant references on table "public"."tools" to "anon";

grant select on table "public"."tools" to "anon";

grant trigger on table "public"."tools" to "anon";

grant truncate on table "public"."tools" to "anon";

grant update on table "public"."tools" to "anon";

grant delete on table "public"."tools" to "authenticated";

grant insert on table "public"."tools" to "authenticated";

grant references on table "public"."tools" to "authenticated";

grant select on table "public"."tools" to "authenticated";

grant trigger on table "public"."tools" to "authenticated";

grant truncate on table "public"."tools" to "authenticated";

grant update on table "public"."tools" to "authenticated";

grant delete on table "public"."tools" to "service_role";

grant insert on table "public"."tools" to "service_role";

grant references on table "public"."tools" to "service_role";

grant select on table "public"."tools" to "service_role";

grant trigger on table "public"."tools" to "service_role";

grant truncate on table "public"."tools" to "service_role";

grant update on table "public"."tools" to "service_role";

create policy "Allow users to delete their tool capabilities"
on "public"."tool_capabilities"
as permissive
for delete
to public
using ((EXISTS ( SELECT 1
   FROM tools
  WHERE ((tools.id = tool_capabilities.tool_id) AND (tools.owner_id = auth.uid())))));


create policy "Allow users update their tool capabilities"
on "public"."tool_capabilities"
as permissive
for update
to authenticated
using ((EXISTS ( SELECT 1
   FROM tools
  WHERE ((tools.id = tool_capabilities.tool_id) AND (tools.owner_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM tools
  WHERE ((tools.id = tool_capabilities.tool_id) AND (tools.owner_id = auth.uid())))));


create policy "Enable insert for authenticated users only"
on "public"."tool_capabilities"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."tool_capabilities"
as permissive
for select
to public
using (true);


create policy "Allow users to delete their own tools"
on "public"."tools"
as permissive
for delete
to public
using ((( SELECT auth.uid() AS uid) = owner_id));


create policy "Allow users to update their own tools"
on "public"."tools"
as permissive
for update
to authenticated
using ((( SELECT auth.uid() AS uid) = owner_id))
with check ((( SELECT auth.uid() AS uid) = owner_id));


create policy "Enable insert for authenticated users only"
on "public"."tools"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."tools"
as permissive
for select
to public
using (true);



