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

### Software Dependencies

With the exception of `go-task`, software dependencies and versions are verified with Task before a 
given task runs.

#### go-task

`go-task` is required to operate this repository.

Quick-install for Linux users:

```shell
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
```

*Make sure ~/.local/bin is in your PATH.*

For fruity and breezy systems, [browse to go-tasks' documentation.](https://taskfile.dev/installation/)

#### jq/yq

These utilities are used to read and set various parameters in JSON and YAML files.

#### openssl 3.0.0+ -- DONT MISS THIS ONE!

**Don't miss this one.** If I didn't bold this text, you'd probably skip this over because openssl is ubiquitous everywhere, right?
However, check your version of openssl with `openssl version`. Unless you have a very recent distro (ie.Ubuntu 22.04 or newer) 
you're probably running openssl 1.x.x.

#### Docker 

Docker is used to generate container images that are then converted to VM images using this kool utility.

Task will verify that docker is installed **and working** before proceeding with docker-related shenanigans.

Sorry, I can only squeeze so many CRIs into my head at once, so other container runtimes aren't supported .

### Infrastructure Dependencies

On my home network, I use a dedicated netgate router running pfSense along with managed switches and VLANs, which
gives me a great deal of control over DHCP and DNS.

#### DHCP

You must be able to statically assign IP addresses to VMs on your network through a common DHCP server.

#### DNS Split-Horizon (or custom local zone)

You must have authoritative control of a DNS domain. This can be accomplished via registering a domain OR
with a custom DNS server that can either perform split-horizon resolution of an existing domain or host 
a local-only domain for you.

All compute products generated in this repository will have an assigned hostname.

**Note** that as required by [per RFC 1918](https://www.rfc-editor.org/rfc/rfc1918), some DNS resolvers will reject
queries resolving to private networks (such as 192.168.x.x) with `NXDOMAIN` or `SERVFAIL.` These DNS resolvers will likely
provide a mechanism to override this functionality.

## Components

### Certificate Hierarchy

The configuration for a certificate hierarchy is contained within the `ca` folder.

Cryptographic products contained within this directory are used for signing, encipherment and 
authentication.

![Hierarchy Diagram](https://github.com/vsysio-bgould/kubesprout/blob/main/ca/CA%20hierarchy.png?raw=true)

A multilevel tiered hierarchy is established to more closely model what would likely exist in an 
enterprise setting.

In this hierarchy, each cluster has its own intermediate certificate authority, that is itself
authorized by a parent intermediate "Clusters" CA, itself authorized by a root CA. This pattern
enables selective revocation of certificates through the offline distribution of a
certificate revocation list ("CRL"). Provision is also made for OCSP stapling should one desire
an online revocation mechanism.

**This directory employs a configuration file** that must be renamed from `config.conf.sample` to
`config.conf` before OpenSSL can be run. Documentation of options are contained within this file.