Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZGVWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZGVWT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZGVWT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:19:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbZGVWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:19:58 -0400
Date: Wed, 22 Jul 2009 15:17:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <pierre@ossman.eu>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-Id: <20090722151744.fffd7bf5.akpm@linux-foundation.org>
In-Reply-To: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 15:36:01 +0200
Pierre Ossman <pierre@ossman.eu> wrote:

> I'm afraid the time has come for me to step down as maintainer for the
> MMC/SD/SDIO subsystem and for someone else to take over the rudder. It
> is no secret that I haven't been able to give the maintainer role the
> resources it required, and as a result it has gone from being a fun
> hobby to a burdensome chore. I was hoping it was a temporary slump, but
> this has been the norm for over a year now, so it's time for me to
> throw in the towel.
> 
> I don't have any clear nominees for a replacement, but if you feel that
> you are in a position to take over the maintainer role then please
> raise your hand.
> 
> I only have a few patches in my queue right now and I can push those
> off to Linus before I quit. There are however a lot of unhandled
> messages that need attention. I can provide a list once a successor has
> been named.
> 
> I realise that you have put a lot of time and effort into the patches
> you send me and I am truly sorry that I haven't been able to handle
> them better. Hopefully me stepping down means that we get someone who
> can actually take care of everything in a timely manner.
> 
> I haven't decided what to do with the sdhci maintainership yet. Right
> now I only know I need a break and freeing myself from the MMC
> maintainer role is the first step. Hopefully I can return as a
> developer in the future.
> 

Thanks, Pierre.

Until and unless someone else steps up I can act as maintainer of last
resort for MMC.  As I'm presently doing for fbdev, hwmon, rtc, spi,
gpio, i2o and about 1000 other identifiable subsystems.

Fortunately, MMC doesn't appear to have its own mailing list so I'll
actually get to see the patches.  I do monitor a couple of
subsystem-specific lists (fbdev, hwmon) but the delays can be awful - a
month or two.


When it comes to subsystems about which I have little knowledge I tend
to work as follows:

- scan the patch to see if anything stands out to my inexperienced eye

- if possible, comment on it to make a bit of noise and to let the
  submitter and others know that a) someone has looked at it and b)
  there's a chance that it'll be merged.

- try to identify some people who might have an interest in the patch
  and/or who might have related experience which would help them review
  this one effectively.

So if someone finds themselves cc'ed on an MMC email from myself,
please do take a bit of time to pass an eye across it, and let us know
that you have done so - it really helps.

