Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbZJJSjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbZJJSjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761550AbZJJSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbZJJSjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:39:43 -0400
Date: Sat, 10 Oct 2009 20:38:30 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/28] BKL removal queued patches
In-Reply-To: <20091010153314.827301943@linutronix.de>
Message-ID: <alpine.LFD.2.00.0910102036480.3669@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Oct 2009, Thomas Gleixner wrote:

> Hi all,
> 
> I'm sending out the pending BKL removal patches which I collected so
> far to avoid duplicate work and to solicit review/comments.
> 
> If nobody objects I'd like to keep them in one git branch which is
> going to be included into linux-next.
> 
> Thanks,
> 
> 	tglx

Seems like a great idea to me. I'm applying them all to a private 
git-branch against the latest from Linus to avoid duplicate work.

Please let us know when there is a tip branch we can work with.

John
