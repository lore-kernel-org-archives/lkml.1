Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbXFIWyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbXFIWyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXFIWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 18:54:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55809 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbXFIWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 18:54:45 -0400
Date: Sun, 10 Jun 2007 00:54:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070609225421.GA20521@elf.ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070609131604.GM2649@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609131604.GM2649@lug-owl.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-06-09 15:16:04, Jan-Benedict Glaw wrote:
> On Sat, 2007-06-09 15:08:17 +0200, Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > Starting beeper as soon as ACPI sleep returns is very useful in
> > debugging "apparently dead" machines. If it beeps at all, it makes
> > sense to start playing with CMOS tracer.
> 
> I'd even go so far and implement it unconditionally.

Well, try it; it is too annoying to be unconditional.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
