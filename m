Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXGELC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXGELC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXGELCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:02:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3743 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757973AbXGELCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:02:21 -0400
Date: Thu, 5 Jul 2007 10:15:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Message-ID: <20070705101514.GD3984@ucw.cz>
References: <200706221607.33274.nigel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221607.33274.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have recently begun to try and use suspend to ram more, and have an 
> intermittent problem. Actually, it's a couple of (possibly related) problems, 
> but I'll start with the one that's easiest.
> 
> Sometimes, when I resume, the keyboard stops responding. I then need to hold 
> down the power button for 4 seconds. At the next boot, things are still not 
> right. The i8042 controller seems to be confused about it's mode, because I 
> get the following differences in dmesg to a 'normal' boot:

If confusion persist after 4 seconds hard power down... then you h ve
hw/BIOS problem. Complain to whoever is manufacturing that beast.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
