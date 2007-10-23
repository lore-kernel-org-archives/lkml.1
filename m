Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbXJWQRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbXJWQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJWQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:17:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39858 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXJWQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:17:11 -0400
Date: Tue, 23 Oct 2007 09:13:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Dan Williams <dcbw@redhat.com>,
       Luis Correia <luis.f.correia@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>, mwallis@serialmonkey.com
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Message-ID: <20071023091352.0dbad002@laptopd505.fenrus.org>
In-Reply-To: <200710222352.57543.IvDoorn@gmail.com>
References: <20071020184100.GA11640@elf.ucw.cz>
	<1193067896.30205.9.camel@localhost.localdomain>
	<20071022211325.GF28190@elf.ucw.cz>
	<200710222352.57543.IvDoorn@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 23:52:57 +0200
Ivo van Doorn <ivdoorn@gmail.com> wrote:

> On Monday 22 October 2007, Pavel Machek wrote:
> > Hi!
> > 
> > > > > This device is NOT a Ralink USB wifi adapter!
> > > > > 
> > > > > Get the windows driver in this link and see for yourself.
> > > > > http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> > > > > (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))
> > > > 
> > > > Thanks a lot. With some patches, I got driver from conitech.it
> > > > to compile and partly work on 2.6.23. I can now transmit
> > > > packets but not yet receive them.
> > > > 
> > > > (use Makefile.26 instead of Makefile)
> > > 
> > > I couldn't find any license info immediately visible; are you
> > > sure it's GPL?
> > 
> > Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.
> 
> That doesn't say much, some manufacturers add that line to their
> driver just to prevent the module loader complaining about a non-GPL
> driver...

no they don't.. nobody is that stupid.
