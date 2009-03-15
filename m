Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZCOKpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZCOKpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZCOKpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:45:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbZCOKpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:45:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Graham Murray <graham@gmurray.org.uk>
Subject: Re: [Bug #12444] X hangs following switch from radeonfb console - Bisected
Date: Sun, 15 Mar 2009 11:45:32 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.NXF.F7BvJB@chimera> <87wsardroy.fsf@newton.gmurray.org.uk>
In-Reply-To: <87wsardroy.fsf@newton.gmurray.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151145.32859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009, Graham Murray wrote:
> I am no longer seeing this problem with 2.6.29-rc8-00090g326d851, but I
> have also upgrade various parts of X including the radeon driver to
> version 6.12.0. 

This is a code fix anyway, closing. :-)

> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12444
> > Subject		: X hangs following switch from radeonfb console - Bisected
> > Submitter	: Graham Murray <graham@gmurray.org.uk>
> > Date		: 2009-01-13 14:03 (61 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a

Thanks,
Rafael
