Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYI3Xj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYI3Xj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYI3Xi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:38:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39673 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753242AbYI3Xiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:38:55 -0400
Date: Wed, 1 Oct 2008 00:25:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Nico Schottelius <nico@schottelius.org>
Subject: Re: [Bug #11220] Screen stays black after resume
Message-ID: <20080930222545.GA15903@ucw.cz>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.9lB.P4q1IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7lIhZC4hCxE.A.9lB.P4q1IB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-09-21 20:54:09, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
> Subject		: Screen stays black after resume
> Submitter	: Nico Schottelius <nico@schottelius.org>
> Date		: 2008-07-31 21:05 (53 days old)
> References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4

This is actually three problems in one :-(.

If you try to suspend with minimum config, will resume still take 30
seconds?

Is the problem still there in 2.6.27-rc7?

Is there chance to bisect it?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
