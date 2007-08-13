Return-Path: <linux-kernel-owner+w=401wt.eu-S1031213AbXHMRBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031213AbXHMRBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030385AbXHMQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:35:52 -0400
Received: from pat.uio.no ([129.240.10.15]:38938 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030290AbXHMQfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:35:48 -0400
Subject: Re: [PATCH] [344/2many] MAINTAINERS - NFS CLIENT
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187022827.10249.95.camel@localhost>
References: <46bffb13.g6PWKhDCxXTpAZFm%joe@perches.com>
	 <1187022387.6628.16.camel@heimdal.trondhjem.org>
	 <1187022827.10249.95.camel@localhost>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 12:35:40 -0400
Message-Id: <1187022940.6628.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.101)
X-UiO-Scanned: 1A9BCE6412C0575D5E068CB50AB2344AE56A3469
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 371 total 3223918 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 09:33 -0700, Joe Perches wrote:
> On Mon, 2007-08-13 at 12:26 -0400, Trond Myklebust wrote:
> > I'm not planning on taking over the maintainership of nfsd or
> > fs/nfsctl.c anytime soon.
> > 
> > However fs/lockd, include/linux/lockd/ is missing, as is
> > include/linux/sunrpc and net/sunrpc/
> 
> Saved as:
> 
> NFS CLIENT
> P:	Trond Myklebust
> M:	trond.myklebust@fys.uio.no
> L:	linux-kernel@vger.kernel.org
> S:	Maintained
> F:	fs/lockd/
> F:	fs/nfs/
> F:	fs/nfs_common/
> F:	net/sunrpc/
> F:	include/linux/lockd/
> F:	include/linux/nfs*
> F:	include/linux/nfsd/
           ^^^^^^^^^^^^^^^^^^ This needs to go
> F:	include/linux/sunrpc/
> 

Otherwise it would appear to be OK.

Trond

