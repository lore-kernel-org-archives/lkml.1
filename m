Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXDMWOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXDMWOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXDMWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:14:47 -0400
Received: from pat.uio.no ([129.240.10.15]:47490 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXDMWOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:14:46 -0400
Subject: Re: [NFS] Merge plans for RPC/RDMA? (Was: Re: [PATCH 000 of 14]
	knfsd: Preparation for IPv6 support in NFS server.)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Mike Snitzer <snitzer@gmail.com>
Cc: chuck.lever@oracle.com, NeilBrown <neilb@suse.de>,
       Andrew Morton <akpm@osdl.org>, Roland Dreier <rdreier@cisco.com>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>
References: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Apr 2007 18:14:25 -0400
Message-Id: <1176502465.6394.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.065)
X-UiO-Scanned: 62A4992B85F25E5739BB3EEA56FF884F537D8024
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 276 total 1053687 max/h 7466 blacklist 0 greylist 1 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-13 at 16:47 -0400, Mike Snitzer wrote:
> I must be missing something because I don't see _any_ trace of the
> core RPC over RDMA support (xprtrdma et al), your RPC Transport
> Switch, or any of the other supporting changes in mainline.  Could
> you, or others, please clarify the plan for merging RPC/RDMA?

That would be a question for the actual RPC/RDMA developers (i.e. James
Lentini and Tom Talpey). They haven't submitted any code for review yet.


> Do you mean the NFS/RDMA server code from Tom Tucker of Open Grid
> Computing?  Why wouldn't this code be included?

That too has never been submitted for review AFAIK. Why would we include
it?

Cheers
  Trond

