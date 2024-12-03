;; SPDX-License-Identifier: MIT
;; Copyright (C) 2024 Massimo Zaniboni <mzan@dokmelody.org>

(define-module (dokmelody non-bootstrapped rust-apps)
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
  #:use-module (gnu packages ssh)
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

(define-public jujutsu
  (package
    (name "jujutsu")
    (version "0.23.0")
    (source
     (origin
       (method url-fetch)
       (uri (format #f
                    "https://github.com/martinvonz/jj/releases/download/v~a/jj-v~a-x86_64-unknown-linux-musl.tar.gz"
                    version
                    version))
       (sha256
        (base32
         "0x4m1a1kr3ylqc5171qnkjcjgl9m9wihyw9rfbrsdk86zckvrp35"))))
    (build-system copy-build-system)
    (arguments
      (list
        #:install-plan
          #~'(("jj" "bin/")
              ("README.md" "share/doc/")
              ("LICENSE" "share/doc/")
              )))
   (inputs (list zstd libgit2 libssh2))
   (home-page "https://github.com/martinvonz/jj")
   (synopsis "Version control system for software projects")
   (description "This package provides @code{jj}: a Git-compatible DVCS
with some features of Mercurial & Sapling (e.g. a domain language to select commits),
and Darcs (e.g. conflict resolutions are first-class objects in its model).")
   (license license:asl2.0)))
