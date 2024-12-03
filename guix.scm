
(use-modules
  ((guix licenses) #:prefix license:)
  (guix packages)
  (guix download)
  (guix gexp)
  (guix git-download)
  (guix build-system copy)
  (guix build-system gnu)
  (guix utils)
  (gnu packages)
  (gnu packages bash)
  (gnu packages base)
  (gnu packages admin)
  (gnu packages autotools)
  (gnu packages base)
  (gnu packages commencement)
  (gnu packages docker)
  (gnu packages php)
  (gnu packages python)
  (gnu packages rsync)
  (gnu packages sync)
  (gnu packages rust-apps)
  (gnu packages uml)
  (dokmelody non-bootstrapped doc-generators)
  (dokmelody non-bootstrapped rust-apps))

(define %source-dir (dirname (current-filename)))

(package
    (name "scratch")
    (version "0.1")
    (source (local-file %source-dir #:recursive? #t))
    (build-system copy-build-system)
    (inputs
     (list
        ; project management
        jujutsu
        gnu-make
        just

        ; needed for generating documentation
        hugo
        dita-ot
        plantuml
        python
        php
        rsync

        ; MAYBE
        docker-cli
        ))
    (synopsis "Dokmelody/scratch project")
    (description
     "Some scratch and experimental code about Dokmelody")
    (home-page "https://scratch.dokmelody.org")
    (license license:expat))
