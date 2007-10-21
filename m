Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbXJUJVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbXJUJVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXJUJVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:21:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60857 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXJUJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:21:31 -0400
Date: Sun, 21 Oct 2007 11:21:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha
	subnotebook
Message-ID: <20071021092138.GC25270@elf.ucw.cz>
References: <20071020184100.GA11640@elf.ucw.cz> <200710210012.37547.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710210012.37547.IvDoorn@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> > 0x6206... I hope that to be compatible with
> > net/wireless/rt2x00/rt73usb.c .
> 
> Is there any reason you assume it is a rt73usb device,
> or are you just making wild guesses about what the chipset is?

Wild guess. I've seen 18e8:6XXX being handled by rt73usb, so..

> > [Sidenote: could we add some real author info into rt73usb.c?]
> 
> You mean expanding the project name to the full list of developers in
> the project? I don't see any need for that.

At least put name and email of lead developer there, or something.

I do not think "copyright sourceforge project" is okay thing to do --
unless the sf project legaly exists and you did some paperwork.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
