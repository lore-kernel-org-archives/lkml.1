Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbYARN41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbYARN41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbYARN4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:56:20 -0500
Received: from waste.org ([66.93.16.53]:57894 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbYARN4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:56:19 -0500
Subject: Re: 2.6.24-rc8-mm1
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080117210858.11eeab29.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <1200604207.3839.3.camel@cinder.waste.org>
	 <1200619758.4001.0.camel@cinder.waste.org>
	 <20080117210858.11eeab29.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 07:55:29 -0600
Message-Id: <1200664529.4001.27.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 21:08 -0800, Andrew Morton wrote:
> On Thu, 17 Jan 2008 19:29:18 -0600 Matt Mackall <mpm@selenic.com> wrote:
> 
> > 
> > On Thu, 2008-01-17 at 15:10 -0600, Matt Mackall wrote:
> > > On Thu, 2008-01-17 at 02:35 -0800, Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> > > 
> > > Hmm. On my Thinkpad R51, this gives me:
> > > 
> > > Uncompressing linux... Ok, booting kernel.
> > > 
> > > ..and nothing more with the attached .config.
> > 
> > Also, both mainline git and x86.git build and boot fine.
> 
> Tried your config on the old PIII.  Boots OK.
> 
> Then tried it on the Vaio and the machine instantly stops with blinking
> leds.  But it also does this with mainline.  You use pentium-M and so do I
> on that machine.  Odd.

Hmm, I don't think I was getting the blinking LEDs, so I suspect mine
was dying even earlier, perhaps in setup.s.

-- 
Mathematics is the supreme nostalgia of our time.

