Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXIQUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXIQUDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbXIQUC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:02:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbXIQUC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:02:56 -0400
Date: Mon, 17 Sep 2007 22:01:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Oleg Verych <olecom@flower.upol.cz>, Roman Zippel <zippel@linux-m68k.org>,
       Rob Hussey <robjhussey@gmail.com>, efault@gmx.de,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917200156.GA11814@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917112707.GA24583@elte.hu> <E1IXMXf-0000uG-ID@flower> <20070917194342.GB20271@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917194342.GB20271@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> On Mon, Sep 17, 2007 at 09:45:59PM +0200, Oleg Verych wrote:
> > The copy list, removed by Ingo is restored. Playing fair game, Willy!
> 
> Sorry Oleg, I don't understand why you added me to this thread. And I 
> don't understand at all what your intent was :-/
> 
> I've left others Cc too since they wonder like me.

i'm wondering too.

in my posted debugging answer, instead of replying privately to Rob, i 
have also Cc:-ed lkml and ck-list. (perhaps i shouldnt even have Cc:-ed 
the lists, as my posted debugging questions and suggestions were mostly 
relevant to Rob and to me - but it's better to keep such things archived 
on the lists, if someone wants to read them. In the first mail i also 
Cc:-ed Mike and Peter who changed the scheduler recently - but i dropped 
them after my first reply when it became apparent that it's not their 
changes that are affected. With all lists still Cc:-ed, so that people 
can follow it if they really want to.)

I'd expect any new results to be posted by Rob to everyone he wishes to 
send them to - like he did it in the past.

Or is Oleg perhaps complaining about the fact that i Cc:-ed this back to 
both affected email lists, for everyone to read? Would be a weird 
argument.

	Ingo
