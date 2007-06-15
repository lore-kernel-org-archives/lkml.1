Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbXFOL6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbXFOL6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXFOL6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:58:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58382 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXFOL6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:58:14 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070615114921.GC6269@elte.hu>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706131946.15714.dhazelton@enter.net>
	 <20070614021619.381331dc@the-village.bc.nu>
	 <200706132129.52736.dhazelton@enter.net>
	 <1181859896.5211.38.camel@shinybook.infradead.org>
	 <20070615114921.GC6269@elte.hu>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 12:57:58 +0100
Message-Id: <1181908678.25228.448.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 13:49 +0200, Ingo Molnar wrote:
> i fully support the notion you articulate, that whether bin-only modules 
> are part of a derivative work of the kernel or whether they are 
> independent works is not an automatic thing at all. The answer is: "it 
> depends, talk to your lawyer".

I was actually trying to avoid the question altogether. It's not that
interesting, largely because the answer is indeed 'talk to your lawyer'.

> For example i'd say VMWare's ESX bin-only module is likely derived
> from the Linux kernel and should be distributed under the GPL, but
> that for example the ATI and nvidia drivers, although being a large
> PITA for all of us, are possibly independent works.

And thus not affected by the GPL _if_ they are distributed as separate
works in their own right. But if you bundle them with the kernel into a
product, the GPL has something to say about that.

> but lets note that this is irrelevant to the Tivo argument. Tivo is not 
> using bin-only modules AFAIK,

Right. It was a digression, which I picked up on because people were
talking about derived works in the context of modules again, and missing
the point that the most _obvious_ GPL violation with modules doesn't
actually involve those modules being a derived work at all.

-- 
dwmw2

