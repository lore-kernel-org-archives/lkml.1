Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbYJRS2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbYJRS2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 14:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYJRS2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 14:28:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40239 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750824AbYJRS2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 14:28:04 -0400
Date: Sat, 18 Oct 2008 20:07:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Russell King <rmk@arm.linux.org.uk>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, metan@ucw.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: 2.6.27-git6: no longer compiles on zaurus
Message-ID: <20081018180734.GC1483@ucw.cz>
References: <20081017101557.GA10850@ucw.cz> <s5h3aivze81.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3aivze81.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-10-17 12:51:42, Takashi Iwai wrote:
> At Fri, 17 Oct 2008 12:15:58 +0200,
> Pavel Machek wrote:
> > 
> > Hi!
> > 
> > ...it should be easy to fix.... but I can't find cpu_is_pxa21x in the
> > headers....?
> 
> It was removed.  The build error was already fixed in the latest Linus
> tree (although warnings are not yet).


Thanks!
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
