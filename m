Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYJBTtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYJBTtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYJBTtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:49:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093AbYJBTtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:49:06 -0400
Date: Thu, 2 Oct 2008 12:47:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/32] Swap over NFS - v19
Message-Id: <20081002124748.638c95ff.akpm@linux-foundation.org>
In-Reply-To: <20081002130504.927878499@chello.nl>
References: <20081002130504.927878499@chello.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Oct 2008 15:05:04 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Let's get this ball rolling...

I don't think we're really able to get any MM balls rolling until we
get all the split-LRU stuff landed.  Is anyone testing it?  Is it good?

