---
trigger: always_on
---

# Second brain do Arthur — instruções raiz

## 1. Natureza deste repositório

Isto é um **second brain**, não um codebase. O produto do trabalho é a nota, não a
resposta no chat.

Consequência prática: quando o trabalho produz conhecimento, escreva o arquivo.
Não responda e siga adiante — o que não foi escrito aqui está perdido.

Código de projeto vive em `code/`, que o Obsidian ignora e o git não versiona.
Todo o resto é conhecimento.

## 2. Dever de documentar

Conversa substantiva termina em `.md` criado ou atualizado. Sempre documente:

- reunião com cliente
- decisão com consequência
- descoberta técnica reaproveitável
- mudança de estado de projeto

Não documente pergunta trivial, comando de uma linha, ou conversa que não gerou
conhecimento novo. Bloat é tão ruim quanto lacuna.

Se não estiver claro se vale nota: escreva em `inbox/` e siga. Triagem é depois.

## 3. Onde salvar

| Isto | Vai para |
|---|---|
| Reunião com cliente | `clients/<cliente>/meetings/YYYY-MM-DD-assunto.md` |
| Decisão com consequência | `clients/<cliente>/decisions/YYYY-MM-DD-assunto.md` |
| Estado de projeto de cliente | `clients/<cliente>/projects/<projeto>.md` |
| Pessoa, contexto de relacionamento | `clients/<cliente>/people/<nome>.md` |
| Aprendizado técnico que atravessa clientes | `knowledge/<domínio>/<tema>.md` |
| Coisa pessoal: casa, saúde, finanças | `personal/life/` |
| Projeto pessoal | `personal/projects/<projeto>.md` |
| Log do dia | `daily/YYYY-MM-DD.md` |
| Não sei ainda | `inbox/` |

Templates prontos em `_meta/templates/`. Use o do tipo certo em vez de inventar
estrutura.

## 4. Protocolo de leitura

Antes de trabalhar em qualquer contexto, **leia o MOC daquele contexto primeiro**.

- "vamos falar de euler" → leia `clients/euler/euler.md`
- "sobre b2med" → leia `clients/b2med/b2med.md`
- assunto pessoal → leia `personal/personal.md`

O MOC é o índice curado: estado atual, projetos ativos, decisões recentes, quem é
quem. Ele te dá o contexto que a conversa assume mas não diz.

## 5. Dever de linkar

**Nota nova sem link no MOC pai não está terminada.** É isto que impede o vault de
virar cemitério de arquivo solto.

1. Toda nota linka para cima, para seu MOC.
2. Depois de criar nota, adicione o link no MOC correspondente. Mesma tarefa, não
   uma tarefa seguinte.
3. Link é `[[wikilink]]`, sempre. Nunca caminho relativo, nunca link markdown.
4. Menção a pessoa, projeto ou decisão vira link, não texto solto: escreva
   `[[2026-07-20-decisao-stack-api]]`, não "a decisão de 20 de julho".
5. Link para nota que ainda não existe é permitido e desejável — marca lacuna a
   preencher depois.

## 6. Proibições

- **Nenhum segredo em nota.** Nem credencial, chave de API, token, senha ou string
  de conexão. O repositório vai para remoto privado, e privado não é o mesmo que
  seguro. Se precisar referenciar, escreva onde o segredo está guardado, nunca o
  valor.
- **Nada de nota dentro de `code/`.** Aquilo é código; o Obsidian não indexa e o
  git não versiona. Nota que cair lá desaparece do vault.
- **Nunca deletar.** Mova para `archive/`, espelhando a estrutura de origem.
  Deletar destrói histórico de decisão, que é o ativo mais caro aqui.
- **Não reorganize pasta por conta própria.** A estrutura é decisão registrada em
  `_meta/specs/`. Mudança de estrutura se discute antes.

## 7. Git: conectar a conta certa antes de qualquer operação

Há **duas** contas GitHub autenticadas nesta máquina. Antes de qualquer operação de
git ou `gh` — commit, push, criar repo, abrir PR, clonar — confira qual está ativa e
troque se for a errada.

| Conta | Usar em |
|---|---|
| `kennedyeuler` | projetos da **Euler** |
| `kennedysmartins` | **todo o resto** — pessoal, outros clientes, este vault |

**Duas coisas separadas que precisam bater.** Errar isso é a fonte de commit
atribuído à conta errada:

1. **`gh auth switch`** controla quem *empurra* — push, criar repo, abrir PR.
2. **`git config user.email`** controla a *autoria do commit*. Trocar a conta do
   `gh` **não** muda isto. É configuração por repositório.

### Como fazer

```bash
gh auth status                          # qual esta ativa
gh auth switch --user kennedyeuler      # ou kennedysmartins
```

O comando é `gh auth switch`, **não** `gh switch` — este não existe.

Autoria do commit, por repositório:

```bash
# projeto da Euler
git config user.name  "Kennedy Martins"
git config user.email "kennedy@eulerapp.com"

# pessoal e outros clientes
git config user.name  "Kennedy Martins"
git config user.email "me@kennedymartins.dev"
```

O `user.email` global já é `me@kennedymartins.dev`, então repo pessoal funciona sem
configurar nada. **Repo da Euler precisa do `git config` local** — sem ele o commit
sai com a identidade pessoal.

> O e-mail de commit da Euler está assumido como `kennedy@eulerapp.com`: a conta
> `kennedyeuler` não tem e-mail público no GitHub, então isto não pôde ser
> verificado. Se o commit não aparecer vinculado à conta, use a forma noreply:
> `265089929+kennedyeuler@users.noreply.github.com`
> (a pessoal é `18352572+kennedysmartins@users.noreply.github.com`).

### Antes de push

Confira os dois de uma vez, e nunca presuma que o estado de antes continua válido —
a conta ativa é global da máquina e qualquer sessão pode ter trocado:

```bash
gh auth status | grep -A1 'Active account: true'
git config user.email
```

## 8. Convenções de escrita

**Idioma:** notas em PT-BR. Termo técnico fica em inglês, sem tradução forçada —
escreva `connection pooling`, não "pooling de conexão".

**Nome de arquivo:** `kebab-case`, minúsculo, sem espaço nem acento. Prefixo de
data ISO quando a nota é um evento (`2026-07-29-kickoff.md`); sem data quando é
atemporal (`postgres-connection-pooling.md`).

**Frontmatter obrigatório** em toda nota:

```yaml
---
title: Kickoff onboarding revamp
type: meeting          # project | meeting | decision | note | moc | person | daily
client: euler          # euler | b2med | personal | none
status: active         # só em project e decision: active | paused | done | superseded
created: 2026-07-29
tags: [onboarding, ux]
---
```

**Datas sempre absolutas e ISO.** `2026-07-29`, nunca "ontem" ou "semana passada" —
a nota é lida meses depois.

Referência completa de convenções em `_meta/conventions.md`.

## 9. Estrutura

```
inbox/       captura crua, esvazia toda semana. Nada mora aqui.
daily/       log do dia, atravessa contextos
clients/     um diretório por cliente, substrutura idêntica
personal/    life/ (casa, saúde, finanças) e projects/
knowledge/   notas atômicas que atravessam clientes
assets/      imagens, PDFs, anexos
code/        repositórios. Obsidian ignora, git ignora.
archive/     coisa morta, espelhando a estrutura de origem
_meta/       templates, convenções, specs, scripts
```

Cliente novo: rode `_meta/new-client.ps1 -Name <nome>`. Não crie a estrutura na
mão — o script garante que fique idêntica às outras.
