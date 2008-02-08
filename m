Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYBHVvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYBHVvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYBHVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:51:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55211 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751278AbYBHVvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:51:43 -0500
Date: Fri, 8 Feb 2008 22:51:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208215155.GL12923@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802072340.06138.rjw@sisk.pl> <20080208211346.GC12923@elf.ucw.cz> <200802082341.58107.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802082341.58107.maximlevitsky@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I remember that I did about 1500 reboots to try to fix this.
> (According to hard disk's 'smart' statistics)

Poor you.

> Suggestion: the speaker usually is quite loud, thus it can be annoying to use
> for morse code or so.
> Why not to use keyboard leds for this purpose?
> (USB keyboard probably isn't an option, but user can always pull an old PC keyboard
> out of closet, and use it)

IIRC keyboard leds are quite hard to drive, plus decoding audible
morse is easier than blinkenlights...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
