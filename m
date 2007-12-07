Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXLGUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXLGUcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbXLGUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:31:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbXLGUb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:31:56 -0500
Date: Fri, 7 Dec 2007 21:31:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, ak@suse.de, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Message-ID: <20071207203129.GA21879@elte.hu>
References: <200711280121.18376.lenb@kernel.org> <20071204163946.63ac73ce.akpm@linux-foundation.org> <20071205094837.GB17911@elte.hu> <200712062141.05195.lenb@kernel.org> <m1mysmqprt.fsf@ebiederm.dsl.xmission.com> <20071207202613.GA18700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207202613.GA18700@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > Attached below is my patch from last time I was looking at this 
> > problem, it doesn't quite apply but it is gives a good idea of where I 
> > think we should go.
> 
> merged it up to x86.git - see below. Alan, have no tried to build, let 
> alone boot it. Does it look good to you?

s/Alan/Alas

	Ingo
