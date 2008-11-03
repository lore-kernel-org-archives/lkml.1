Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYKCJTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYKCJTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYKCJTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:19:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35636 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbYKCJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:19:23 -0500
Date: Mon, 3 Nov 2008 10:19:22 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11835] 2.6.27-git8: max1111_read_channel and corgi_ssp_ads7846_putget missing
Message-ID: <20081103091922.GB28982@atrey.karlin.mff.cuni.cz>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.xbC.tV5AJB@chimera> <20081027085640.GC30526@atrey.karlin.mff.cuni.cz> <200810271246.08373.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810271246.08373.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday, 27 of October 2008, Pavel Machek wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.27.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11835
> > > Subject		: 2.6.27-git8: max1111_read_channel and corgi_ssp_ads7846_putget missing
> > > Submitter	: Pavel Machek <pavel@suse.cz>
> > > Date		: 2008-10-20 12:10 (6 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=122450475101945&w=4
> > 
> > ...seems to be fixed in 2.6.28-rc1. Unfortunately, resulting kernel
> > still will not boot :-(.
> 
> -rc2 should be better at that. :-)

Unfortunately it is not :-(.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
