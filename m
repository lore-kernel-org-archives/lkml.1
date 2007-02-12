Return-Path: <linux-kernel-owner+w=401wt.eu-S965359AbXBLUVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbXBLUVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965292AbXBLUVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:21:07 -0500
Received: from 1wt.eu ([62.212.114.60]:2376 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965359AbXBLUVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:21:06 -0500
Date: Mon, 12 Feb 2007 21:20:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: Gerhard Mack <gmack@innerfire.net>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212202012.GA22344@1wt.eu>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <1171147026.19894.16.camel@nigel.suspend2.net> <20070211064636.GA12171@1wt.eu> <Pine.LNX.4.64.0702120752420.3824@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702120752420.3824@mtl.rackplans.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 07:59:40AM -0500, Gerhard Mack wrote:
> On Sun, 11 Feb 2007, Willy Tarreau wrote:
> 
> > On Sun, Feb 11, 2007 at 09:37:06AM +1100, Nigel Cunningham wrote:
> > > On Sat, 2007-02-10 at 23:20 +0100, Rafael J. Wysocki wrote:
> > 
> > Many people also have Linux on their notebooks, but as a dual-boot. You
> > read the word ? "dual-boot". It means that they cleanly shutdown their
> > system every time they don't use it anymore, and they won't know what
> > OS they'll use next time.
> 
> Please tell me your joking.  Linux' crappy suspend support is a common 
> reason people give me for not wanting Linux anywhere near their laptops.  

No, I'm not kidding. The most annoyed ones are those who don't have serial
ports and who need those annoying USB adapters. But fortunately, not all
of them need to access router consoles :-)

> I have a single boot laptop that's somewhat of a mobile debugging station 
> that needs Linux and I absolutely hate it.  Right now my laptop takes far 
> too long to boot and even if it didn't I wish I could suspend.

Probably that you got the wrong laptop. If you buy an ultra-thin with highly
proprietary hardware, it may be hard. But if you choose in profesionnal ranges,
there is rarely any problem. I have a compaq nc8000 on which everything works
fine, and it boots in about 20 seconds. Other people I know have Toshibas,
NECs, Dells and IBMs and are happy with them. My previous VAIO was a dirty
crap that I would never recommend to anybody though.

> I'm actually a huge Linux fan.. I use it exclusively on my server and on 
> my PC but if I get another laptop I will probably run something else on 
> it.  Linux is just too annoying for that use.

Everyone has different needs, that's all.

Sorry, but I fell like we're becoming a bit off-topic here.

Regards,
Willy

