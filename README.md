# Kubesprout Introductory Self-Learning Project

## Purpose

The purpose of this repository is to version (and document) my journey with
learning Kubernetes at a deeper level. In my opinion, becoming proficient in
designing multipurpose platforms that run on Kubernetes requires vastly more 
knowledge than what can be provided through certifications such as CKA.

It's mainly for my own purposes, but if somebody finds it useful for their own purposes, hey, send me coffee.
I like coffee =)

## Legal

Products in this repository adopt the "MIT License." Please see the
"LICENSE" file for the legalese. Note that I'm not an attorney and I can only recommend
 you seek out independent legal advice for any issues with this repository or the
products contained therein.

Note that further releases of this repository may be later relicensed under
different terms. 

Additionally, "Kubesprout" is a fictitious name I spitballed for this project. I'm just some poor
shmuck that couldn't afford a proper tradename search, so if I'm accidentally infringing on
a trade name, I will rename this repository and the products contained within upon request from a 
legal representative of the entity possessing the Kubesprout tradename.

## Prerequisites

`go-task` is required to operate this repository.

Quick-install for Linux users:

```shell
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
```

*Make sure ~/.local/bin is in your PATH.*

For fruity and breezy systems, [browse to go-tasks' documentation.](https://taskfile.dev/installation/)

## Components

### Certificate Hierarchy

The configuration for a certificate hierarchy is contained within the `ca` folder.

Cryptographic products contained within this directory are used for signing, encipherment and 
authentication.

![Hierarchy Diagram]("/ca/CA hierarchy.png")

A multilevel tiered hierarchy is established to more closely model what would likely exist in an 
enterprise setting.

In this hierarchy, each cluster has its own intermediate certificate authority, that is itself
authorized by a parent intermediate "Clusters" CA, itself authorized by a root CA. This pattern
enables selective revocation of certificates through the offline distribution of a
certificate revocation list ("CRL"). Provision is also made for OCSP stapling should one desire
an online revocation mechanism.

**This directory employs a configuration file** that must be renamed from `config.conf.sample` to
`config.conf` before OpenSSL can be run. Documentation of options are contained within this file.