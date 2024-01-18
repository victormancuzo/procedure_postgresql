CREATE DATABASE procedure;
\c procedure;

CREATE TABLE IF NOT EXISTS public.tipo_pessoa
(
    id_tipo_pessoa integer NOT NULL DEFAULT nextval('tipo_pessoa_id_tipo_pessoa_seq'::regclass),
    descricao character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT tipo_pessoa_pkey PRIMARY KEY (id_tipo_pessoa)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tipo_pessoa
    OWNER to postgres;

INSERT INTO tipo_pessoa (DESCRICAO) VALUES ('Pessoa Física'), ('Pessoa Jurídica');

CREATE TABLE IF NOT EXISTS public.pessoa
(
    id_pessoa integer NOT NULL DEFAULT nextval('pessoa_id_pessoa_seq'::regclass),
    nome character varying(100) COLLATE pg_catalog."default" NOT NULL,
    cpf_cnpj character varying(18) COLLATE pg_catalog."default" NOT NULL,
    data_nascimento date,
    id_tipo_pessoa integer NOT NULL,
    CONSTRAINT pessoa_pkey PRIMARY KEY (id_pessoa),
    CONSTRAINT pessoa_cpf_cnpj_key UNIQUE (cpf_cnpj),
    CONSTRAINT pessoa_id_tipo_pessoa_fkey FOREIGN KEY (id_tipo_pessoa)
        REFERENCES public.tipo_pessoa (id_tipo_pessoa) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pessoa
    OWNER to postgres;

CREATE OR REPLACE PROCEDURE public.cadastrar_pessoa(
	IN p_nome character varying,
	IN p_cpf_cnpj character varying,
	IN p_data_nascimento date,
	IN p_id_tipo_pessoa integer)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
INSERT INTO pessoa (nome, cpf_cnpj, data_nascimento, id_tipo_pessoa) VALUES (p_nome, p_cpf_cnpj, p_data_nascimento, p_id_tipo_pessoa);
END;
$BODY$;
ALTER PROCEDURE public.cadastrar_pessoa(character varying, character varying, date, integer)
    OWNER TO postgres;

CALL cadastrar_pessoa ('Nome da pessoa', '123.456.789-01', '0001-01-01', 1);
CALL cadastrar_pessoa ('Nome da empresa', '12.345.678/0001-00', NULL, 2);