Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYBKQyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYBKQyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYBKQyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:54:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYBKQyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:54:46 -0500
Date: Mon, 11 Feb 2008 17:54:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v8,
Message-ID: <20080211165401.GB3112@elte.hu>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <47B07AAC.9080802@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B07AAC.9080802@siemens.com>
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


* Jan Kiszka <jan.kiszka@siemens.com> wrote:

> Ingo Molnar wrote:
> > In any case, if there are any open issues we are very much ready and 
> > willing to address them now or after any potential upstream merge of 
> > this codebase. This has meanwhile become one of the best-reviewed pieces 
> > of kernel code in living memory ;-)
> > 
> 
> I spotted one... :)

thanks, applied :-) Merged, uploaded the updated tree to the usual 
place. New tip of head is 59b64c80d706ae3504ccc76a9c00cdfea4a10701.

	Ingo
