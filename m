Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXFZRIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXFZRIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXFZRIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:08:13 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2265 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbXFZRIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:08:12 -0400
Date: Tue, 26 Jun 2007 19:08:27 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
In-Reply-To: <20070626161857.GA7178@elte.hu>
Message-ID: <Pine.LNX.4.64.0706261858350.1817@scrub.home>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org>
 <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
 <Pine.LNX.4.64.0706252356400.1817@scrub.home>
 <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
 <20070626161857.GA7178@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Jun 2007, Ingo Molnar wrote:

Another BTW before someone takes this seriously:

> ( whether there is any correlation between a decade long fundamental
>   suckage and stagnation of the Linux time and NTP subsystem and Roman's
>   decade long negative feedback presence in that area of code is left up
>   to the reader. :)

That's complete bullshit.

> This current ... interesting piece of Roman about a _single_ trivial 
> unlikely() branch in do_gettimeofday() borders on the ridiculous. My 
> patch might be wrong for various reasons, but that single
> 'if (unlikely())' statement is not one of those reasons =B-)

That's even more nonsense, that wasn't what my mail was about and Andrew 
understood me correctly, so you could have too.

Ingo, I at least know that I'm difficult to deal with and try to take this 
into account, which is hard for me, but you don't even seem to know what 
kind of ass you are towards people who don't suck up to you (I guess you 
simply get away with it far too often).

bye, Roman
