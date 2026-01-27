# 🌌 Antigravity Kit (JZ e RM Edition)

> **A fusão definitiva entre o `Awesome Skills` e o `Antigravity Kit`. 255+ Skills, 20 Agentes e 11+ Workflows em um único ambiente de alta performance.**

---

## 🐣 O que é este Kit?

Este repositório é uma versão consolidada e otimizada do ecossistema Antigravity. Ele combina a vasta biblioteca de habilidades (skills) da comunidade com a orquestração multi-agente para transformar seu assistente de IA em uma agência digital completa.

**Diferenciais desta versão:**
- ✅ **Portabilidade Total:** Scripts refatorados para funcionar em qualquer máquina sem caminhos fixos.
- ✅ **Sem Dependência de Git:** Sincronização automática via download de ZIP para ambientes restritos.
- ✅ **Híbrido (PowerShell + Node):** Comandos nativos para Windows ou via NPM para devs web.

---

## 🚀 Quick Install (Unified JZ-RM Edition)

Escolha o modo que melhor se adapta ao seu fluxo de trabalho:

### 🌍 Opção A: Instalação Global (Recomendado)
*O Kit fica em uma pasta central do sistema e você vincula seus projetos a ele.*
```bash
# Tudo em um comando: Instala global, unifica e linka o projeto
npx github:Academico-JZ/antigravity-jz-rm init

# Ou instale permanentemente:
npm install -g github:Academico-JZ/antigravity-jz-rm
ag-jz-rm init
```

### 📁 Opção B: Instalação Local (Apenas no Workspace)
*O Kit e as skills são baixados diretamente para dentro da pasta `.agent/` do projeto atual.*
```bash
npx github:Academico-JZ/antigravity-jz-rm init --local
```
*(Ideal para projetos isolados ou que exigem versões específicas das skills sem afetar o resto do sistema)*

---

## 🏗️ Como vincular a um novo projeto

1. Vá para a pasta do seu projeto.
2. Execute o script de linkagem:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\antigravity\kit\scripts\setup_workspace.ps1"
   ```
3. **Pronto!** O Antigravity já está ativo e ciente das suas regras através do arquivo `.agent/GEMINI.md`.

---

## 🛠️ Comandos Slash (Workflows)

| Comando | Descrição |
| :--- | :--- |
| `/plan` | Cria um plano técnico detalhado sem escrever código. |
| `/brainstorm` | Processo de discovery socrático para validar ideias. |
| `/create` | Orquestra a criação de uma nova aplicação do zero. |
| `/debug` | Modo de depuração sistemática com análise de causa raiz. |
| `/ui-ux-pro-max` | Foco em estética premium e animações. |

---

## 🔄 Sincronização

Mantenha suas skills sempre atualizadas baixando as novidades dos repositórios originais:
```bash
python .agent/scripts/sync_kits.py
```

---

## 🤝 Créditos
Inspirado pelos trabalhos de **[sickn33](https://github.com/sickn33)** e **[vudovn](https://github.com/vudovn)**.
Refatorado e modularizado por **[Academico-JZ](https://github.com/Academico-JZ)** e **[RMMeurer](https://github.com/rmmeurer)**.

> Este projeto opera sob a licença MIT, respeitando as liberdades dos códigos originais.
