Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZLKJRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZLKJRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZLKJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:16:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42051 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601AbZLKJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:16:55 -0500
Date: Fri, 11 Dec 2009 09:18:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091211091843.0a543136@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	<6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	<alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
	<20091210235835.20e2269d@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I realize that you have some emotional attachments to Red Hat, but ask 
> yourself (and answer honestly): what would you think if some random other 
> distro was packaging tens of thousands of lines of kernel code and not 
> apparently working at trying to get them upstream?

Like Ubuntu does for a load of stuff and did for years ? I'd like to see
stuff get upstream yes. The point you seem to be missing is you are
ranting at the wrong people. I want to see it upstream too, but if you
must shout at people do it productively at the right target.

I would be cross if they were controlling and hiding it, but its sitting
in a public repository, its maintained by a collection of people one of
whom happens to work for Red Hat and anyone can grab it. It's vastly
easier to get hold of than the userspace for some of the stuff in kernel.

However the fundamental point stands. The only people who can sign it off
are the people who wrote it. Those are the rules. Red Hat didn't write the
code, Red Hat cannot sign it off however much you rant at them. You also
previously said you don't want to merge stuff when the authors don't want
it merged. If you like I can also dig out some Torvalds quotes about not
wanting to dictate to distros.

If you want to progress this then

- Starting talking to the project *authors*
- Help them decide what to do about the firmware stuff
- If need be get the Linux Foundation, Red Hat and other relevant lawyers
  and people on a phone call with you so that legal issues can get
  discussed and you can shout at them as necessary too.

I am not privy to what the lawyers think on this one. But I'd bet that
the only way you'll get a full answer is in conjunction with lawyers
speaking to lawyers, and the only way you'll get a sign off is when the
lawyers say "yes". Anything else would be rather irresponsible.

> And it's possible that other distros are doing the same thing. I happen to 
> know that Fedora does it (and has been doing it for at least a year), 
> because I happen to have an Intel development machine that runs Fedora and 

F11 certainly shipped some bits of it for 2D support. I am not sure if
F10 shipped a purely userspace set up. Neither had it enabled as the
default driver - they used "nv" or "vesa" depending upon the card.

> was shipped by Intel with an nVidia card (and has a power supply that 
> craps out if you don't use several hundred watts of power, so I can't 
> change it to something more power-efficient - seriously).

Alan
