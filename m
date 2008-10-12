Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYJMUjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYJMUjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYJMUjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:39:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55598 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755078AbYJMUjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:39:35 -0400
Date: Sun, 12 Oct 2008 10:53:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Russell King <rmk@arm.linux.org.uk>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, pavel.urban@ct.cz,
       metan@atrey.karlin.mff.cuni.cz, thommycheck@gmail.com, milan@ucw.cz
Subject: Re: 2.6.27-rc8 regression on arm: kernel will no longer boot on
	Sharp Zaurus c-3000
Message-ID: <20081012085340.GA1549@ucw.cz>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz> <1223553647.3194.8.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223553647.3194.8.camel@hammer.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-09 14:00:46, Stanislav Brabec wrote:
> Pavel Machek wrote:
> > ...unfortunately, its kind of hard to debug, as I'm testing kernels
> > using kexec and only see messages late in boot. 2.6.26 works ok.
> 
> Lost patch:
> http://lists.arm.linux.org.uk/lurker/message/20081007.113509.c17e1e65.en.html

Thanks!

> OT: 2.6.26 does not work OK. You need I2C init patch.
 It boots for me :-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
