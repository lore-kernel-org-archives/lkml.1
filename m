Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKUNdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKUNdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYKUNc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:32:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48579 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbYKUNcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:32:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121001744.90a45e68.akpm@linux-foundation.org>
References: <20081121001744.90a45e68.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144215.10667.81594.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/45] FS-Cache: Provide an add_wait_queue_tail() function [ver #41]
Date: Fri, 21 Nov 2008 13:32:14 +0000
Message-ID: <25501.1227274334@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > Provide an add_wait_queue_tail() function to add a waiter to the back of a
> > wait queue instead of the front.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Please update the changelog to explain the reason for this change.

I'll ditch the patch instead.  I'm not using the function now.

David
