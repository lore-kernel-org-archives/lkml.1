Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbXLLPAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbXLLPAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXLLPAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:00:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbXLLPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:00:00 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Karl MacMillan <kmacmill@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <31067.1197471197@redhat.com>
References: <1197470515.3019.2.camel@localhost.localdomain>
	 <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <25572.1197320887@redhat.com>
	 <25965.1197329769@redhat.com>
	 <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil>
	 <31067.1197471197@redhat.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 12 Dec 2007 09:59:30 -0500
Message-Id: <1197471570.3019.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-12 at 14:53 +0000, David Howells wrote:
> Karl MacMillan <kmacmill@redhat.com> wrote:
> 
> > That's what I remember as well - I suggested the transition idea and
> > then, after discussion, agreed that it wasn't the best approach.
> 
> Sigh.
> 
> Can you tell me then how to do it now?  I don't know very much about using
> SELinux userspace stuff libraries or configuring them.
> 

I don't have enough context anymore to help with design, but I can help
with the actual usage of the libraries if you have specific questions.

Karl

