Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXFOLtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXFOLtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXFOLtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:49:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbXFOLth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:49:37 -0400
Date: Fri, 15 Jun 2007 13:49:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615114921.GC6269@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <200706131946.15714.dhazelton@enter.net> <20070614021619.381331dc@the-village.bc.nu> <200706132129.52736.dhazelton@enter.net> <1181859896.5211.38.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181859896.5211.38.camel@shinybook.infradead.org>
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

> Who cares about whether the module is a derivative work? That's only 
> relevant when you distribute the module as a separate work. When you 
> ship a combined work including both the kernel and the module in 
> question, it's a _whole_ lot easier to interpret the GPL.

i fully support the notion you articulate, that whether bin-only modules 
are part of a derivative work of the kernel or whether they are 
independent works is not an automatic thing at all. The answer is: "it 
depends, talk to your lawyer". For example i'd say VMWare's ESX bin-only 
module is likely derived from the Linux kernel and should be distributed 
under the GPL, but that for example the ATI and nvidia drivers, although 
being a large PITA for all of us, are possibly independent works.

but lets note that this is irrelevant to the Tivo argument. Tivo is not 
using bin-only modules AFAIK, all their source code is available for 
download. (their kernel source is totally uninteresting by the way - 
they have some weird crap IDE controller with hacks that will never go 
upstream.)

	Ingo
