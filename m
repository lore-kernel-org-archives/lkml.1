Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXH0VsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXH0VsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765683AbXH0Vc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:32:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51660 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760625AbXH0Vc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:32:27 -0400
Date: Mon, 27 Aug 2007 23:32:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070827213248.GF3398@elf.ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <20070827105801.GA4053@elf.ucw.cz> <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-08-27 22:36:57, Jeff Chua wrote:
> On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > > Hi!
> > >
> > > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > > x60, i386 architecture).
> 
> I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
> and my system still survives.

Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
so cycles at one point.

...or maybe difference is in the .config, or maybe I broken something
in my kernel sources....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
