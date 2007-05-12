Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbXELTcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbXELTcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXELTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:32:07 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3187 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXELTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:32:06 -0400
Date: Sat, 12 May 2007 20:31:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070512193144.GA30703@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pete Zaitcev <zaitcev@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
	Andrew Morton <akpm@osdl.org>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz> <1178550653.11851.191.camel@pmac.infradead.org> <20070507194949.GB3981@ucw.cz> <20070507222311.4589fc8a@the-village.bc.nu> <20070512100321.c54f3dbe.zaitcev@redhat.com> <20070512202700.44afe993@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512202700.44afe993@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 08:27:00PM +0100, Alan Cox wrote:
> > One peculiar thing I have observed is how all this "UTF-8 in names"
> > nonsense is being pushed by western Europeans. Why? That's because
> > their umlauts are grandfathered in, and because English speakers _can_
> > read their names approximately, simply by ignoring all the strokes
> > above the letter (or, in Norwegians and Polaks cases, going through
> > the letter). So do not try to pretend that "correctness" has anything
> > to do with your demands.
> 
> I find your comments racist and insulting. I trust you will be
> apologizing. The most clear example of where it would be polite to
> include names spelt properly are the Asian countries. They may well (and
> most do) choose to include a transliteration.

Given that people can't be bothered to spell names which fall within
the 7-bit ASCII space correctly, I think all this is very much a
pipedream.

And yes, at the end of the day, it comes down to lazyness and whether
people can be bothered to take the care required to get names correctly
spelt.  Much of my personal experience has been that the majority of
people DO NOT seem to CARE about correctly spelling names.

Or maybe people just like repeatedly insulting me.

While you can arm people with the tools to allow them to do what you
desire (to spell peoples names correctly), at the end of the day I
think you'll find that most people will just not bother.  It's a
nice idea though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
