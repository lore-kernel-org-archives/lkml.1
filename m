Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbXIUXW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbXIUXW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbXIUXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:22:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXIUXWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:22:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46F3F8BF.1030404@redhat.com>
References: <46F3F8BF.1030404@redhat.com> <20070921144703.8323.50492.stgit@warthog.procyon.org.uk> <20070921144815.8323.77745.stgit@warthog.procyon.org.uk>
To: Peter Staubach <staubach@redhat.com>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 14/22] NFS: Use local caching
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 22 Sep 2007 00:22:36 +0100
Message-ID: <10249.1190416956@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Staubach <staubach@redhat.com> wrote:

> Did I miss the section where the modified semantics about which
> mounted file systems can use the cache and which ones can not
> was implemented?

Yes.

David
