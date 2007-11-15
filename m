Return-Path: <linux-kernel-owner+w=401wt.eu-S1764897AbXKOVVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897AbXKOVVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbXKOVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:21:31 -0500
Received: from trinity.fluff.org ([89.145.97.151]:50433 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763429AbXKOVV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:21:29 -0500
X-Greylist: delayed 3851 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 16:21:29 EST
Date: Thu, 15 Nov 2007 20:16:56 +0000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Mark Lord <liml@rtr.ca>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, Natalie Protasevich <protasnb@gmail.com>,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071115201656.GD11305@trinity.fluff.org>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <20071113181053.GB1356@flint.arm.linux.org.uk> <20071113182516.250de873@the-village.bc.nu> <20071113223437.GG1356@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113223437.GG1356@flint.arm.linux.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
From: Ben Dooks <ben@trinity.fluff.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:34:37PM +0000, Russell King wrote:
> On Tue, Nov 13, 2007 at 06:25:16PM +0000, Alan Cox wrote:
> > > Given the wide range of ARM platforms today, it is utterly idiotic to
> > > expect a single person to be able to provide responses for all ARM bugs.
> > > I for one wish I'd never *VOLUNTEERED* to be a part of the kernel
> > > bugzilla, and really *WISH* I could pull out of that function.
> > 
> > You can. Perhaps that bugzilla needs to point to some kind of
> > arm-maintainers@vger.kernel.org list for the various ARM platform
> > maintainers ?
> 
> That might work - though it would be hard to get all the platform
> maintainers to be signed up to yet another mailing list, I'm sure
> sufficient would do.

As long as it would just be bug reports, I'm sure that most of us
could be persuaded to subscribe. Adding another list for general
discussions is probably not going to be read, the current list
provides more than enough to keep us busy.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

