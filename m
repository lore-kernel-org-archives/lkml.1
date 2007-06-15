Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbXFOM3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbXFOM3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXFOM3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:29:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbXFOM3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:29:37 -0400
Date: Fri, 15 Jun 2007 14:29:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615122921.GA21120@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <200706131946.15714.dhazelton@enter.net> <20070614021619.381331dc@the-village.bc.nu> <200706132129.52736.dhazelton@enter.net> <1181859896.5211.38.camel@shinybook.infradead.org> <20070615114921.GC6269@elte.hu> <1181908678.25228.448.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181908678.25228.448.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> > For example i'd say VMWare's ESX bin-only module is likely derived 
> > from the Linux kernel and should be distributed under the GPL, but 
> > that for example the ATI and nvidia drivers, although being a large 
> > PITA for all of us, are possibly independent works.
> 
> And thus not affected by the GPL _if_ they are distributed as separate 
> works in their own right. But if you bundle them with the kernel into 
> a product, the GPL has something to say about that.

yeah. Section 2 of the GPLv2 takes a permissive (and IMO correct) 
approach here:

  Thus, it is not the intent of this section to claim rights or contest
  your rights to work written entirely by you; rather, the intent is to
  exercise the right to control the distribution of derivative or
  collective works based on the Program.

  In addition, mere aggregation of another work not based on the Program
  with the Program (or with a work based on the Program) on a volume of
  a storage or distribution medium does not bring the other work under
  the scope of this License.

the argument is quite strong that the linking of two independent works 
is "mere aggregation" as well. (as long as they are truly separate 
works)

	Ingo
