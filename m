Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXJVVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXJVVN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXJVVNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:13:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48344 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXJVVNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:13:18 -0400
Date: Mon, 22 Oct 2007 23:13:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Williams <dcbw@redhat.com>
Cc: Luis Correia <luis.f.correia@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       mwallis@serialmonkey.com
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Message-ID: <20071022211325.GF28190@elf.ucw.cz>
References: <20071020184100.GA11640@elf.ucw.cz> <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com> <20071022000919.GB29024@elf.ucw.cz> <1193067896.30205.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193067896.30205.9.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This device is NOT a Ralink USB wifi adapter!
> > > 
> > > Get the windows driver in this link and see for yourself.
> > > http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> > > (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))
> > 
> > Thanks a lot. With some patches, I got driver from conitech.it to
> > compile and partly work on 2.6.23. I can now transmit packets but not
> > yet receive them.
> > 
> > (use Makefile.26 instead of Makefile)
> 
> I couldn't find any license info immediately visible; are you sure it's
> GPL?

Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
