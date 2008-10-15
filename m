Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbYJOKR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbYJOKR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYJOKRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:17:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33123 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYJOKRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:17:49 -0400
Date: Wed, 15 Oct 2008 12:17:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@Opfer-Online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: 2.6.27-rc8 regression on arm: kernel will no longer boot on Sharp Zaurus c-3000
Message-ID: <20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz> <1223553647.3194.8.camel@hammer.suse.cz> <20081009142351.GA4697@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009142351.GA4697@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Oct 09, 2008 at 02:00:46PM +0200, Stanislav Brabec wrote:
> > Pavel Machek wrote:
> > > ...unfortunately, its kind of hard to debug, as I'm testing kernels
> > > using kexec and only see messages late in boot. 2.6.26 works ok.
> > 
> > Lost patch:
> > http://lists.arm.linux.org.uk/lurker/message/20081007.113509.c17e1e65.en.html
> 
> Not really lost.  I asked for it, but it didn't arrive in time for the
> upcoming merge window.
> 
> However, since it is a regression, as identified by Pavel, it is -rc
> material, not merge window material which isn't clear from the thread
> or the problem description.
> 
> So, let's get it in for -final.

Thanks for the effort, but it looks like it did not make it, right?

Anyway, thanks for the patch, it worked for me. I will scream if
2.6.28-rc1 does not work.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
