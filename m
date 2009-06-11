Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbZFKQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbZFKQI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZFKQIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:08:52 -0400
Received: from muru.com ([72.249.23.125]:50351 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZFKQIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:08:51 -0400
X-Greylist: delayed 1635 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 12:08:51 EDT
Date: Thu, 11 Jun 2009 15:41:38 +0000
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611154138.GA31856@muru.com>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk> <20090611140038.GB11199@atomide.com> <20090611140624.GS795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611140624.GS795@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 03:06:24PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 11, 2009 at 07:00:39AM -0700, Tony Lindgren wrote:
> > You suggested pulling each set as they get reviewed into some omap branch
> > in your tree, do you want to try that the next merge window?
> 
> If we're following Alan's suggestion, then as I see it you're entirely
> responsible for tracking what's in OMAP, getting it into linux-next and
> (I guess) ultimately sending Linus a pull request for it during the
> merge window.  I just become someone who can put their oar into reviewing
> OMAP patches as and when.
> 
> So the question is: do you want to give this a go?

How about this:

- We post patches for review to the related lists like always

- You and others ack nak as usual

- If you want more time to look at something, you reply with a comment

- I wait few days and if no comments, pile them into for-next

- I send a pull request to you to keep things coordinated for arm

- If you want something merged earlier, you let know and send pull
  request

I'm flexible, and willing to try other things if that helps you.
But I think we (as arm community) should coordinate the arm patches
ourselves. So I'd rather see you pull in stuff and send it to
Linus rather than bug Linus with a pull request for stuff that
he may not care too much about.

Cheers,

Tony
