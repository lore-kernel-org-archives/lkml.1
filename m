Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbXHCP3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbXHCP3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbXHCP25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:28:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762305AbXHCP24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:28:56 -0400
Date: Fri, 3 Aug 2007 17:28:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: debian developer <debiandev@gmail.com>
Cc: "T. J. Brumfield" <enderandrew@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: about modularization
Message-ID: <20070803152850.GC13619@elte.hu>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com> <f24d23310708030600o66cbf862y39197bf2ca23d9ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24d23310708030600o66cbf862y39197bf2ca23d9ab@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5030]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* debian developer <debiandev@gmail.com> wrote:

> > 1 - Can someone please explain why the kernel can be modular in 
> > every other aspect, including offering a choice of IO schedulers, 
> > but not kernel schedulers?
> 
> Good question. has been answered in other threads. Linus does'nt like 
> having separate kernel schedulers.

not just Linus, but neither me nor Nick Piggin, nor a ton of other 
kernel hackers agree with that idea, for numerous technical reasons,
as it has been discussed to death already ;-)

and the last but not least point, although they might sound pretty 
similar, there is quite a bit of difference between "IO schedulers" and 
"CPU schedulers", just like there is quite a bit of difference between 
"Paris Hilton" and "The Hilton, Paris" =B-)

	Ingo
