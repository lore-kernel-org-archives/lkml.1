Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0BOU7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:59:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36478 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab0BOU7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:59:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [Bug #14482] kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Date: Mon, 15 Feb 2010 22:00:12 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Backlund <tmb@mandriva.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <20100208095943.GJ14551@chipmunk> <20100215162452.GA22823@chipmunk>
In-Reply-To: <20100215162452.GA22823@chipmunk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152200.12332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010, Alexander Clouter wrote:
> Hi,
> 
> * Alexander Clouter <alex@digriz.org.uk> [2010-02-08 09:59:43+0000]:
> >
> > * Thomas Backlund <tmb@mandriva.org> [2010-02-01 17:47:42+0200]:
> > >
> > > 01.02.2010 02:43, Rafael J. Wysocki skrev:
> > >> This message has been generated automatically as a part of a report
> > >> of regressions introduced between 2.6.31 and 2.6.32.
> > >>
> > >> The following bug entry is on the current list of known regressions
> > >> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > >> be listed and let me know (either way).
> > >>
> > >>
> > >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
> > >> Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
> > >> Submitter	: Alexander Clouter<alex@digriz.org.uk>
> > >> Date		: 2009-10-23 10:30 (101 days old)
> > >> References	: http://lkml.org/lkml/2009/10/23/50
> > >>
> > >
> > > Afaik this is the same issue as the one referenced here:
> > >
> > > http://lkml.org/lkml/2010/1/28/292
> > >
> > > The patch in the above thread should fix the issue.
> > >
> > I'm getting my hands on some not-in-production-state equipment to test 
> > this with, so bear with me :)
> > 
> I can confirm this patch fixes the problem I was seeing.  Once applied I 
> could no longer OOP's my kernel.

The patch has already been merged, so the bug is closed.

Rafael
