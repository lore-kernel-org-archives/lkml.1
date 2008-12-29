Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbYL2PE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbYL2PE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYL2PEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:04:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41817 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYL2PEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:04:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081228200726.7b7078b4.akpm@linux-foundation.org>
References: <20081228200726.7b7078b4.akpm@linux-foundation.org> <8930.1229560221@redhat.com> <20081218142420.GA16728@infradead.org> <20081218123601.11810b7f.akpm@linux-foundation.org> <200812190007.34581.bernd.schubert@fastmail.fm> <20081218152616.a24c013f.akpm@linux-foundation.org> <20081219110539.7e7e230c.sfr@canb.auug.org.au> <20081229144533.4a0ab696.sfr@canb.auug.org.au> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Mon, 29 Dec 2008 15:04:35 +0000
Message-ID: <12273.1230563075@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> And that of course means that many many 2.6.28 patches which I am
> maintaining will need significant rework to apply on top of linux-next,
> and then they won't apply to mainline.  Or that linux-next will not apply
> on top of those patches.  Mainly memory management.

Significant rework to many many patches?  The FS-Cache patches don't have all
that much impact outside of their own directories, AFS and NFS.

> Please drop the NFS tree until after -rc1.
> 
> Guys, this: http://lkml.org/lkml/2008/12/27/173

Okay, that's a reasonable request.

David
