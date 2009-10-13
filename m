Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZJMObv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZJMObv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZJMObu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:31:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48447 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZJMObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:31:49 -0400
Date: Tue, 13 Oct 2009 10:27:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>, Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [Bug #14278] New message "NOHZ: local_softirq_pending 08" at
	each ping request
Message-ID: <20091013142726.GA2747@tuxdriver.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <r-4Wjt4coy.A.VeE.Bbl0KB@chimera> <200910121515.49393.mb@bu3sch.de> <200910122349.39408.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910122349.39408.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:49:39PM +0200, Rafael J. Wysocki wrote:
> On Monday 12 October 2009, Michael Buesch wrote:
> > On Monday 12 October 2009 00:22:00 Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14278
> > > Subject		: New message "NOHZ: local_softirq_pending 08" at each ping request
> > > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > > Date		: 2009-09-30 18:12 (12 days old)
> > > Handled-By	: Michael Buesch <mb@bu3sch.de>
> > 
> > I think John or Johannes is handling it, as my patch was rejected.
> > 
> > > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23220
> 
> Johannes, what's the status here?

Johannes posted a patch here:

	http://marc.info/?l=linux-wireless&m=125525657120789&w=2

It is on my merge train, but it hasn't gone to Linus (or Dave) just
yet -- probably today.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
