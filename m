Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0CJUuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:50:01 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44560 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757098Ab0CJUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:50:00 -0500
Date: Wed, 10 Mar 2010 21:45:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, torvalds@osdl.org, akpm@osdl.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
	deprecation)
Message-ID: <20100310204546.GA1394@ucw.cz>
References: <20100303075944.GA23354@comet.dominikbrodowski.net> <20100303083010.GA22928@flint.arm.linux.org.uk> <20100305120746.646126b9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305120746.646126b9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So you believe that disabling the button in the graphical environment
> > to allow PCMCIA cards to be removed (such as CF cards) - leaving the
> > user to merely pull out the CF card, while the FS is mounted, is a
> > good idea?
> 
> Do any graphical environments even support the ancient user space
> pcmcica helper stuff ? I can't find any evidence they do but I realise

Yes; qtopia shipped with zaurus sl-5500 (collie), and very probably
opie and gpe...

Sharp needed operating system for the handheld, and yes it supported
all the hw.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
