Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZBYMvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZBYMvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZBYMv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:51:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZBYMv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:51:26 -0500
Date: Wed, 25 Feb 2009 13:51:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem
	wrapping
Message-ID: <20090225125108.GE26273@elte.hu>
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org> <20090224214932.GC12601@elte.hu> <20090224234949.GA1778@cmpxchg.org> <49A4ACAE.4020104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4ACAE.4020104@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Johannes Weiner wrote:
> > No, when the patch was submitted for review, I pointed out the change
> > in semantics and gathered from Tejun's reaction that this wasn't done
> > intentionally.  So the problem is the change itself, not the missing
> > declaration.
> 
> Yeah, I should have regenerated the tree.  Sorry about that.

Queueing up a fix is still worth having of course. That will 
also more fairly document Johannes's review efforts.

	Ingo
