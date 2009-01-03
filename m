Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbZACPHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbZACPHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZACPHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:07:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52191 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZACPG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:06:59 -0500
Date: Sat, 3 Jan 2009 16:06:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
Message-ID: <20090103150634.GA28693@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495F7D27.8020104@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> > Once we have figured out the CPU-hotplug lockdep splat (possibly due 
> > to Mike's changes not yours) i'll send it to Linus. Thanks,
> > 
> > 	Ingo
> 
> Thanks!  Am working on that now.

do you suspect any of the commits? I'm bisecting it right now but if you 
have bisected it already i wont repeat it.

	Ingo
