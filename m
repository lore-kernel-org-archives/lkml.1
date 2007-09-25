Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbXIYT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbXIYT2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXIYT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:28:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXIYT23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:28:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19445.1190748021@lwn.net>
References: <19445.1190748021@lwn.net>
To: corbet@lwn.net (Jonathan Corbet)
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 04/22] CRED: Request a credential record for a kernel service 
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 25 Sep 2007 20:27:10 +0100
Message-ID: <24448.1190748430@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> wrote:

> The comment describes a "dentry" argument, but the actual function does
> not have that argument.

oops.  Yeah, I decided I didn't want that there.

David
