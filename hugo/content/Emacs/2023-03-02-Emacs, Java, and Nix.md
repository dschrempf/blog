+++
title = "Emacs, Java, and Nix — An interesting journey"
author = ["Dominik Schrempf"]
description = "A declarative Java development setup in Emacs using a Nix Flake"
date = 2023-03-02T00:00:00+01:00
keywords = ["Emacs", "Java", "Nix", "Nix Flakes", "LSP", "jdtls", "jdt-language-server"]
categories = ["Emacs"]
type = "post"
draft = false
+++

Do you want to use Emacs for Java development? I suggest using the language
server protocol with [`lsp-mode`](https://github.com/emacs-lsp/lsp-mode) and [`lsp-java`](https://github.com/emacs-lsp/lsp-java) together with the [Eclipse JDT
language server](https://github.com/eclipse/eclipse.jdt.ls) (`jdtls`). And do you also want a declarative development
environment without surprises? Use [Nix Direnv](https://github.com/nix-community/nix-direnv), [envrc.el](https://github.com/purcell/envrc), and a [Nix Flake](https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html)! I
assume familiarity with these concepts. In the following, I will focus on the
Java-related Emacs setup.

The reason of this post is that I have stumbled upon problems when using a
declarative, project-specific configuration. In particular, `lsp-java` uses a
global variable `lsp-java-server-install-dir` which specifies the installation
directory of `jdtls`. Further, it uses global workspace and configuration
directories which are [`jdtls` specific settings](https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line); we want those to be
project-specific.

But first things first. The following snippet defines a minimalist Nix Flake
that provides a development environment for Java:

```nix
# File 'flake.nix'.
{
  description = "Java development environment";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells.default = with pkgs; mkShell {
          packages = [
            # Gradle, Java development kit, and Java language server.
            gradle
            jdk
            jdt-language-server
          ];
          # Environment variable specifying the plugin directory of
          # the language server 'jdtls'.
          JDTLS_PATH = "${jdt-language-server}/share/java";
        };
      }
    );
}
```

We also set up a directory environment file, and use it:

<a id="code-snippet--envrc"></a>
```sh
echo "use flake" > .envrc
direnv allow
direnv reload
```

However, the language server will not work yet. We need to tell `lsp-java` about
the location of `jdtls` and how to run it. This has proven to be difficult, if
not arduous. The solution, however, is pretty easy.

1.  Use the wrapper script shipped with `jdtls` instead of a manual `java
       --lots-of-options` invocation like so:
    ```emacs-lisp
    (after! lsp-java
      (defun lsp-java--ls-command ()
        (list "jdt-language-server"
              "-configuration" "../config-linux"
              "-data" "../java-workspace")))
    ```

    -   `after!` is a [Doom Emacs](https://github.com/doomemacs/doomemacs) macro that executes code after loading a feature.
        You can use other constructs, if you like.
    -   The function `lsp-java--ls-command` provides a list of strings which are
        concatenated and executed when running the language server. Here, we use
        the wrapper script `jdt-language-server`, and only specify the
        project-specific configuration and workspace directories. We put them in
        the parent directory of the Java project, because, well, [see this weird
        Stack Overflow answer](https://stackoverflow.com/a/53404328/3536806).

2.  Set `lsp-java-server-install-dir` in a hook using the environment variable
    `JDTLS_PATH` set by the Nix Flake shell:
    ```emacs-lisp
    (after! cc-mode
      (defun my-set-lsp-path ()
        (setq lsp-java-server-install-dir (getenv "JDTLS_PATH")))
      (add-hook 'java-mode-hook #'my-set-lsp-path))
    ```

Like so, everything works like a charm, and my experience with `lsp-java` has
been great so far! We can have different versions of `jdtls` for different
projects, and they do not even interfere with each other. Wow.

If you want, you can now set up a demo project from within Emacs using
`lsp-java-spring-initializer`. After setting up the `demo` project, the
directory structure is:

```text
/home/dominik/Scratch/java
├── config-linux   -- Created by =jdtls=, see above.
├── demo           -- Demo project.
├── .direnv
├── .envrc
├── flake.lock
├── flake.nix
├── .git
├── .gitignore
└── java-workspace -- Created by =jdtls=, see above.

5 directories, 4 files
```

In conclusion, we have a project-specific, declarative Java development setup.
However, there is still some local state and cache created by `Gradle` or
`Maven`, depending on which build tool you use. For example, I do have a
`~/.gradle` directory with lots of artifacts... If you know how to tell Gradle
or Maven to be project-specific, let me know!
