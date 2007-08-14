Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXHNJm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXHNJm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXHNJmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:42:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbXHNJmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:42:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <462850.65153.qm@web36605.mail.mud.yahoo.com>
References: <462850.65153.qm@web36605.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 14 Aug 2007 10:39:57 +0100
Message-ID: <1079.1187084397@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> With Smack you can leave the label alone, raise CAP_MAC_OVERRIDE,
> do your business of setting the label correctly, and then drop
> the capability. No new hooks required.

That sounds like a contradiction.  How can you both leave it alone and set it?

David
