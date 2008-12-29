Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYL2O1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYL2O1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYL2O10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:27:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51992 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbYL2O1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:27:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081229144533.4a0ab696.sfr@canb.auug.org.au>
References: <20081229144533.4a0ab696.sfr@canb.auug.org.au> <8930.1229560221@redhat.com> <20081218142420.GA16728@infradead.org> <20081218123601.11810b7f.akpm@linux-foundation.org> <200812190007.34581.bernd.schubert@fastmail.fm> <20081218152616.a24c013f.akpm@linux-foundation.org> <20081219110539.7e7e230c.sfr@canb.auug.org.au> 
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Mon, 29 Dec 2008 14:26:31 +0000
Message-ID: <11990.1230560791@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> What was the result of discussions around FS-Cache?  I ask because it
> reappeared in linux-next today via the nfs tree (merged into that on Dec
> 24 and 25) ...

That is the result of discussions during the kernel summit in Portland.  The
discussion here is about whether Andrew agrees with adding the patches or not,
as far as I can tell.  There are a number of people/companies who want them;
there is Andrew who does not.

David
