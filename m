Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbYEFAV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbYEFAV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYEFAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:21:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbYEFAVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:21:34 -0400
Date: Tue, 6 May 2008 02:21:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, andi@lisas.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506002114.GB22499@elte.hu>
References: <20080505053935.GA15734@rhlx01.hs-esslingen.de> <20080505073030.GI3350@elte.hu> <20080506095122.860796f6.sfr@canb.auug.org.au> <20080505.165501.62584352.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505.165501.62584352.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 6 May 2008 09:51:22 +1000
> 
> > I (and I assume Andrew) have been carrying them since then but noone 
> > took them up.  I guess (as Andrew pointed out to me) I should have 
> > pushed them.
> 
> So what should I do now?
> 
> I have Ingo's IRDA PNP fixes in my net-2.6 tree and that's already 
> publicly visible, so I'd need to add revert changesets if people want 
> me to remove it.

i have no problem with the revert - Bjorn Helgaas found and fixed the 
buglet first.

	Ingo
