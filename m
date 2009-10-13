Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbZJMUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbZJMUtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbZJMUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:49:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZJMUta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:49:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14278] New message "NOHZ: local_softirq_pending 08" at each ping request
Date: Tue, 13 Oct 2009 22:50:01 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Michael Buesch <mb@bu3sch.de>, Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christian Casteyde <casteyde.christian@free.fr>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <200910122349.39408.rjw@sisk.pl> <20091013142726.GA2747@tuxdriver.com>
In-Reply-To: <20091013142726.GA2747@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132250.01858.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, John W. Linville wrote:
> On Mon, Oct 12, 2009 at 11:49:39PM +0200, Rafael J. Wysocki wrote:
> > On Monday 12 October 2009, Michael Buesch wrote:
> > > On Monday 12 October 2009 00:22:00 Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14278
> > > > Subject		: New message "NOHZ: local_softirq_pending 08" at each ping request
> > > > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > > > Date		: 2009-09-30 18:12 (12 days old)
> > > > Handled-By	: Michael Buesch <mb@bu3sch.de>
> > > 
> > > I think John or Johannes is handling it, as my patch was rejected.
> > > 
> > > > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23220
> > 
> > Johannes, what's the status here?
> 
> Johannes posted a patch here:
> 
> 	http://marc.info/?l=linux-wireless&m=125525657120789&w=2
> 
> It is on my merge train, but it hasn't gone to Linus (or Dave) just
> yet -- probably today.
> 
> Hth!

Yes, it does, I've updated the bug entry with the link to the Johannes' patch.

Thanks,
Rafael
