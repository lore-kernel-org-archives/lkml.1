Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbYBUMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbYBUMbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYBUMbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:31:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYBUMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:31:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802201907.40406.phillips@phunq.net>
References: <200802201907.40406.phillips@phunq.net> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 21 Feb 2008 12:31:12 +0000
Message-ID: <19566.1203597072@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> > These patches add local caching for network filesystems such as NFS.
> 
> Have you got before/after benchmark results?

I need to get a new hard drive for my test machine before I can go and get
some more up to date benchmark results.  It does seem, however, that the I/O
error handling capabilities of FS-Cache work properly:-)

David
