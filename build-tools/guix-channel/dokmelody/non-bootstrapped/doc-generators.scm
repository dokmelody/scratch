;; SPDX-License-Identifier: MIT
;; Copyright (C) 2024 Massimo Zaniboni <mzan@dokmelody.org>

(define-module (dokmelody non-bootstrapped doc-generators)
  #:use-module (ice-9 optargs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix modules)
  #:use-module (gnu packages)
  #:use-module (gnu packages adns)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages check)
  #:use-module (gnu packages code)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pretty-print)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages regex)
  #:use-module (gnu packages rpc)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages unicode)
  #:use-module (gnu packages version-control)

  #:use-module (gnu packages compression)
  #:use-module (gnu packages uml)
  #:use-module (guix download)
  #:use-module (gnu packages java)
  #:use-module (gnu packages compression)
  #:use-module (guix build-system trivial)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system python))

(define-public hugo
  (package
    (name "hugo")
    (version "0.139.3")

    (source
     (origin
       (method url-fetch)
       (uri (format #f
                    "https://github.com/gohugoio/hugo/releases/download/v~a/hugo_~a_linux-amd64.tar.gz"
                    version
                    version))
       (sha256
        (base32
         "0lkna9nr5q9asbk48d7ikhfim8sa5zrzrdvkgjh17xvj9mf2dygw"))))
    (build-system copy-build-system)
    (arguments
      (list
        #:install-plan
          #~'(("hugo" "bin/")
              ("README.md" "share/doc/")
              ("LICENSE" "share/doc/")
              )))
    (home-page "https://gohugo.io/")
    (synopsis "Fast static site generator")
    (description "Hugo takes a directory with content and templates and renders
them into a full HTML website.")
    (license license:asl2.0)))

(define (dita-plugin pname pversion purl phash phome psynopsis plicense)
  (package
    (name pname)
    (version pversion)
    (source (origin
              (method url-fetch)
              (uri purl)
             (sha256 (base32 phash))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let ((out (assoc-ref %outputs "out"))
               (source (assoc-ref %build-inputs "source")))
            (mkdir-p out)
            (copy-file source (string-append out "/package.zip"))))))

            (home-page phome)
            (synopsis psynopsis)
            (description psynopsis)
            (license plicense)))

; TODO this should be compiled first
; TODO replace jars in "lib", with pointer to plantuml libraries and similar
; TODO check how other plugins are compiled, and the final expected format
; TODO test on some demo page, for seiing if it can call plantuml. The package source contains some of them.
(define-public dita-plugin-diagrams
  (package
    (name "dita-plugin-diagrams")
    (version "0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/oxygenxml/dita-ot-diagrams-plugin")
             (commit "275c288d8c3b8de8e9869d01eef1b5e4a762b169")))
       (sha256
        (base32 "1qqqpxycgmpf6drnazxw2nkm9r0qyd3n6ndl7g46gqkd0kb9gb5p"))))

    (native-inputs (list zip))
    (propagated-inputs (list plantuml))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let ((out (assoc-ref %outputs "out"))
               (source (assoc-ref %build-inputs "source"))
               (zip-bin (string-append (assoc-ref %build-inputs "zip") "/bin/zip")))

            (mkdir-p out)
            (chdir source)
            (invoke zip-bin "-r" (string-append out "/package.zip") "." "-x" "out")))))

    (home-page "https://github.com/oxygenxml/dita-ot-diagrams-pluginhome")
    (synopsis "DITA Open Toolkit plugin which allows publishing embedded Plant UML and Mermaid diagrams to HTML and PDF.")
    (description "")
    (license license:asl2.0)))

(define-public dita-ot
  (let ((plugin1
         (dita-plugin
            "plugin1"
            "1.1.0"
            "https://github.com/jason-fox/fox.jason.favicon/archive/refs/tags/v1.1.0.zip"
            "0zk5i3b0n8543q9f3dflydyjvirpdxclv6pcvanwj401liyi820a"
            "https://github.com/jason-fox/fox.jason.favicon"
            "HTML Favicon Plugin for DITA-OT"
            license:asl2.0))

        (plugin2
         (dita-plugin
           "plugin2"
           "1.3.0"
           "https://github.com/jason-fox/fox.jason.extend.css/archive/v1.3.0.zip"
           "0325pbs1rqh3xnamh5dfmxbbws3cjhjvag6hkwza1amqsczvfw3s"
           "https://github.com/jason-fox/fox.jason.extend.css"
           "This is an abstract base DITA-OT Plug-in to extend HTML processing and allow additional plug-ins to add an extra CSS stylesheet to the <header> of each HTML page. By default the plug-in does nothing appart from creating a temporary file extend.css.file - it is designed to be extended so other plugins can add CSS to the blank file."
            license:asl2.0))

        (plugin3
         (dita-plugin
           "plugin3"
           "5.3.4"
           "https://github.com/infotexture/dita-bootstrap/archive/5.3.4.zip"
           "0gjarhwrrxw4jdis9d368ihiv87riq3jgibhig7jisnj6jp2vcsc"
           "https://github.com/infotexture/dita-bootstrap"
           "A plug-in for DITA Open Toolkit that extends the default HTML5 output with a basic Bootstrap template."
           license:asl2.0)))

        (package
       (name "dita-ot")
       (version "4.2.3")
       (source
         (origin
           (method url-fetch)
             (uri (format #f
                          "https://github.com/dita-ot/dita-ot/releases/download/~a/dita-ot-~a.zip"
                          version
                          version))
           (sha256
             (base32
               "0mkjz9fls3r3pp2ralkwrzj6qvd0r1873lyvnwhyfbbfsb0lxkqc"))))
       (native-inputs
        (list unzip
              openjdk
              plugin1 plugin2 plugin3 dita-plugin-diagrams))
       (inputs (list openjdk))
       (build-system copy-build-system)
       (arguments
        (list
          #:phases
            #~(modify-phases %standard-phases
               (add-after 'install 'wrap-executable-and-install-plugins
                  (lambda* (#:key inputs outputs #:allow-other-keys)
                    (let ((out (assoc-ref outputs "out"))
                          (openjdk-bin (string-append (assoc-ref inputs "openjdk") "/bin/java"))
                          (plugin1 (string-append
                                    (assoc-ref inputs "plugin1")
                                    "/package.zip"))
                          (plugin2 (string-append
                                    (assoc-ref inputs "plugin2")
                                    "/package.zip"))
                          (plugin3 (string-append
                                    (assoc-ref inputs "plugin3")
                                    "/package.zip"))
                          (dita-plugin-diagrams (string-append
                                    (assoc-ref inputs "dita-plugin-diagrams")
                                    "/package.zip")))

                      (wrap-program
                        (string-append out "/bin/dita")
                        `("JAVACMD" ":" = (,openjdk-bin)))

                      (chdir out)
                      (setenv "JAVACMD" openjdk-bin)
                      (invoke "bin/dita" "install" plugin1)
                      (invoke "bin/dita" "install" plugin2)
                      (invoke "bin/dita" "install" plugin3)
                      ; TODO (invoke "bin/dita" "install" dita-plugins-diagrams)
                      #t))))))
       (home-page "https://www.dita-ot.org/download")
       (synopsis "DITA Open Toolkti")
       (description "The open-source publishing engine for content authored in the Darwin Information Typing Architecture.")
       (license license:asl2.0))))
