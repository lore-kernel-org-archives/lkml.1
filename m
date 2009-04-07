Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbZDGVG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbZDGVG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZDGVGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:06:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47788 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZDGVGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:06:49 -0400
Date: Tue, 7 Apr 2009 23:09:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [Bug #12871] usb bluetooth crashes system
Message-ID: <20090407210946.GK3278@elf.ucw.cz>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.dO.aGn2JB@chimera> <1239088599.19390.27.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239088599.19390.27.camel@violet>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-04-07 09:16:39, Marcel Holtmann wrote:
> Hi Rafael,
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12871
> > Subject		: usb bluetooth crashes system
> > Submitter	: Pavel Machek <pavel@ucw.cz>
> > Date		: 2009-03-10 11:23 (28 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123668450400940&w=4
> 
> please have this re-tested against 2.6.30-rc1 then we can work on
> figuring out which patch might have fixed it. I think it is fixed now,
> but I could be also wrong here.

2.6.30-rc1 does not seem to be out (according to kernel.org); I can
test the latest git if that helps?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
