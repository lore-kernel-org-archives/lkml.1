Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbXLLO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbXLLO6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXLLO6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:58:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXLLO6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:58:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197470515.3019.2.camel@localhost.localdomain>
References: <1197470515.3019.2.camel@localhost.localdomain> <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <25572.1197320887@redhat.com> <25965.1197329769@redhat.com> <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil> 
To: Karl MacMillan <kmacmill@redhat.com>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Dec 2007 14:53:17 +0000
Message-ID: <31067.1197471197@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl MacMillan <kmacmill@redhat.com> wrote:

> That's what I remember as well - I suggested the transition idea and
> then, after discussion, agreed that it wasn't the best approach.

Sigh.

Can you tell me then how to do it now?  I don't know very much about using
SELinux userspace stuff libraries or configuring them.

David
