Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbYDOTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbYDOTzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbYDOTzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:55:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49148 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbYDOTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:55:31 -0400
Date: Tue, 15 Apr 2008 21:56:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: Re: w35und: add softmac interface
Message-ID: <20080415195603.GE4994@elf.ucw.cz>
References: <20080414224740.GA31431@elf.ucw.cz> <20080415002826.GC4270@tuxdriver.com> <20080415070923.GA13767@elf.ucw.cz> <20080415132845.GA11789@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415132845.GA11789@tuxdriver.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Actually you are about month early to the party ;-). We are trying to
> > clean up winbond usb wireless driver, so that it can think about
> > inclusion in kernel.
> > 
> > http://code.google.com/p/winbondport/
> > 
> > Unfortunately, original driver carries its own 802.11 stack with it;
> > that needs to be stripped down. (And then code needs to be rewritten
> > due to horrible coding style).
> 
> I see...OK.
> 
> Did you get any legal advice regarding whether or not
> MODULE_LICENSE("GPL") was sufficient to proclaim the driver as covered
> by the GPL?

I dislike talking to lawyers, do not have any easily physically
reachable, and believe the case is pretty clear...

...plus, we plan to rewrite the driver, anyway...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
