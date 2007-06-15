Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbXFOU2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbXFOU2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXFOU2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:28:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40577 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbXFOU2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:28:12 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070615202054.GA590@elte.hu>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706142144.15695.dhazelton@enter.net>
	 <1181895924.25228.319.camel@pmac.infradead.org>
	 <200706150458.29943.dhazelton@enter.net>
	 <1181899064.25228.342.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
	 <1181930204.25228.590.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org>
	 <1181936955.5211.62.camel@shinybook.infradead.org>
	 <20070615202054.GA590@elte.hu>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 21:28:32 +0100
Message-Id: <1181939312.5211.77.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 22:20 +0200, Ingo Molnar wrote:
> That boundary is indeed fuzzy, because life is fuzzy too and the 
> possibilities are virtually unlimited. But one thing is pretty sure: as 
> long as some component is merely put alongside of a larger body of work, 
> even if that component has no life of its own without _some_ larger body 
> of work, that component is not necessarily part of a collective work and 
> does not necessarily fall under the GPL.

Not _necessarily_ a collective work. But not necessarily _not_ a
collective work either.

> For driver blobs that are shared between Windows and Linux it would be 
> hard to argue that they are derived from the Linux kernel. 

You're back to the 'derived work' thing again, which wasn't relevant.

> Merely linking to some larger body of work does not necessarily mean
> that the two become a collective work. No matter how much the FSF is
> trying to muddy the waters with the LGPL/GPL.

I think it's quite clear that the intent of the GPL _is_ to 'muddy the
waters', as you put it, and to indicate that bundling stuff together
_should_ put the non-derived parts under the GPL too; at least in some
circumstances. But still, nothing's true until it's ruled by a court.

-- 
dwmw2

