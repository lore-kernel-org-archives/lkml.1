Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIWQWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIWQWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZIWQWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:22:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZIWQWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:22:40 -0400
Date: Wed, 23 Sep 2009 18:21:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       jan.kratochvil@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] x86: clean up orig_ax handling
Message-ID: <20090923162147.GE6105@elte.hu>
References: <20090923004651.2D99513F37@magilla.sf.frob.com> <alpine.LFD.2.01.0909221757200.4950@localhost.localdomain> <20090923024049.AA85913F37@magilla.sf.frob.com> <20090923061834.BE13A22@magilla.sf.frob.com> <20090923154118.GB6105@elte.hu> <alpine.LFD.2.01.0909230852530.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909230852530.4950@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 23 Sep 2009, Ingo Molnar wrote:
> > 
> > Linus, this series looks good to me. Do you want to pull this 
> > directly or should we test this for a few days in the x86 tree? 
> > (either solution is fine to me)
> 
> I already pulled it, since I'm used to pulling ptrace fixes from 
> Roland,

Ok, thanks!

	Ingo
