Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbZJMUjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbZJMUjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760930AbZJMUjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:39:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43782 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760915AbZJMUjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:39:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: [Bug #14264] ehci problem - mouse dead on scroll
Date: Tue, 13 Oct 2009 22:39:52 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0910131132150.3169-100000@iolanthe.rowland.org> <200910131755.20166.volkerarmin@googlemail.com>
In-Reply-To: <200910131755.20166.volkerarmin@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132239.52666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Volker Armin Hemmann wrote:
> On Dienstag 13 Oktober 2009, Alan Stern wrote:
> > On Mon, 12 Oct 2009, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.30 and 2.6.31.
> > >
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > > be listed and let me know (either way).
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14264
> > > Subject		: ehci problem - mouse dead on scroll
> > > Submitter	: Volker Armin Hemmann <volkerarmin@googlemail.com>
> > > Date		: 2009-09-12 7:46 (30 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125274202707893&w=4
> > > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > 
> > This is probably a hardware problem in the mouse or the Logitech
> > receiver.  It affected both EHCI and OHCI, and it was not reproducible
> > with a different mouse.  But Volker hasn't reported any results since
> > the end of September.
> > 
> > Volker, another good test would be to try plugging your mouse into
> > someone else's computer.
> > 
> > Alan Stern
> > 
> 
> yeah, that is a problem - I am pretty 'alone' in regard of linux users. I know 
> very few, and they have either only servers without X or run some stable 
> distributions with old kernels.
> 
> It is probably hardware related. I have tried two other mice and both were ok. 
> Both had a lesser resolution and were slower, but that shouldn't make any 
> difference.

OK, I'm closing the bug.

Thanks,
Rafael
