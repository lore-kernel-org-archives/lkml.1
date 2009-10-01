Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZJAKlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZJAKlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZJAKlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:41:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58727 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbZJAKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:41:13 -0400
Date: Thu, 1 Oct 2009 12:41:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, stable@kernel.org
Subject: Re: [stable] [patch for 2.6.31-stable] zaurus c3000 aka spitz: fix
	resume
Message-ID: <20091001104110.GB2159@elf.ucw.cz>
References: <20090930203251.GA1893@ucw.cz> <20090930232757.GA17069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930232757.GA17069@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-30 16:27:57, Greg KH wrote:
> On Wed, Sep 30, 2009 at 10:32:52PM +0200, Pavel Machek wrote:
> > 
> > 
> > Spitz resume was broken for year or likely two, and it would be very
> > nice to fix it for 2.6.31-stable release. One liner is below...
> > 
> > It is in 2.6.32-rc1/2, with some more signoffs...
> 
> Now queued up.

Thanks.

> Next time please let me know what the git commit id is for the patch,
> it's necessary for me to be able to include it in the -stable tree.

Ook, will try to remember.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
