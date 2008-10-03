Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYJCTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYJCTkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYJCTkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:40:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYJCTkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:40:01 -0400
Date: Fri, 3 Oct 2008 15:38:10 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/32] Swap over NFS - v19
Message-ID: <20081003153810.5dd0a33e@bree.surriel.com>
In-Reply-To: <20081002124748.638c95ff.akpm@linux-foundation.org>
References: <20081002130504.927878499@chello.nl>
	<20081002124748.638c95ff.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 12:47:48 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 02 Oct 2008 15:05:04 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Let's get this ball rolling...
> 
> I don't think we're really able to get any MM balls rolling until we
> get all the split-LRU stuff landed.  Is anyone testing it?  Is it good?

I've done some testing on it on my two test systems and have not
found performance regressions against the mainline VM.

As for stability, I think we have done enough testing to conclude
that it is stable by now.

-- 
All rights reversed.
