Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0CMGxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:53:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59081 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754273Ab0CMGxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:53:02 -0500
Date: Sat, 13 Mar 2010 07:52:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
 deprecation)
Message-ID: <20100313065254.GF12554@elf.ucw.cz>
References: <20100303075944.GA23354@comet.dominikbrodowski.net>
 <20100303083010.GA22928@flint.arm.linux.org.uk>
 <20100305120746.646126b9@lxorguk.ukuu.org.uk>
 <20100310204546.GA1394@ucw.cz>
 <20100310210015.GB16230@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310210015.GB16230@isilmar.linta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-03-10 22:00:15, Dominik Brodowski wrote:
> Hey,
> 
> On Wed, Mar 10, 2010 at 09:45:46PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > So you believe that disabling the button in the graphical environment
> > > > to allow PCMCIA cards to be removed (such as CF cards) - leaving the
> > > > user to merely pull out the CF card, while the FS is mounted, is a
> > > > good idea?
> > > 
> > > Do any graphical environments even support the ancient user space
> > > pcmcica helper stuff ? I can't find any evidence they do but I realise
> > 
> > Yes; qtopia shipped with zaurus sl-5500 (collie), and very probably
> > opie and gpe...
> > 
> > Sharp needed operating system for the handheld, and yes it supported
> > all the hw.
> 
> So qtopia still uses the PCMCIA ioctl? Or is it some custom add-on code by
> zaurus? I'd very much like to see some more source code, what parts of
> the IOCTL it uses etc. pp. Or at least some pointers...

Well, Alan asked about "any graphical environments even support the
ancient user space pcmcica helper stuff", and yes I believe there are
some. I probably have one on ancient collie that's lying
somewhere. Not sure about sources, I never used those heavily.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
