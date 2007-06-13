Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbXFMUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbXFMUNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXFMUNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:13:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2806 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753283AbXFMUNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:13:14 -0400
Date: Wed, 13 Jun 2007 19:53:30 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Schwartz <davids@webmaster.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: PC speaker
Message-ID: <20070613195329.GC8273@ucw.cz>
References: <20070612161951.69e54751@the-village.bc.nu> <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >I'd say impossible. Just disconnect it from the motherboard.
> > >
> > > The days when hardware *relied* on software (hence, where software
> > > could damage hardware) are over.
> 
> > Nice theory but you can destroy or render useless a fair amount of PC
> > hardware via software, usually because the thing is *DESIGNED* that way
> > for convenience. (Flash update interfaces without jumpers, locking
> > interfaces for drives etc)
> 
> Other great examples are hardware that allows you to control voltages, fan
> speeds, and operating frequencies. Sometimes you can overvoltage it directly
> and blow it immediately. Other times, you can increase the voltage and
> operating frequency and decrease the fan speed to the point where it stops
> spinning. This is possible on many modern graphics cards and CPUs.

Not true for cpus; try it before spreading FUD. Thermal protection
will kill the machine when cpu goes over 95C or so.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
