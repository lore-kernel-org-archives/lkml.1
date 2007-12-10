Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbXLJXo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbXLJXo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXLJXos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:44:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbXLJXor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:44:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <370690.53043.qm@web36615.mail.mud.yahoo.com>
References: <370690.53043.qm@web36615.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 10 Dec 2007 23:44:18 +0000
Message-ID: <25991.1197330258@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> That happens to me when interfaces are described in SELinux terms. I
> still don't care much for multiple contexts, and I don't have a good
> grasp of how you'll deal with Smack, or any LSM other than SELinux.

Me neither.  I understand SELinux somewhat, though it's got a lot of wibbly
bits, and WinNT's security system, but I have no experience of the other
stuff.

> Just as Stephen mentions, I also don't see the generality that a change
> of this magnitude really ought to provide.

Perhaps it should be a specific interface, solely for cachefiles's use then.

David
