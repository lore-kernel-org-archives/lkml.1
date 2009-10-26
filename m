Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZJZO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZJZO4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZJZO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:56:36 -0400
Received: from THUNK.ORG ([69.25.196.29]:41317 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZJZO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:56:35 -0400
Date: Mon, 26 Oct 2009 10:56:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Robert Bradbury <robert.bradbury@gmail.com>
Cc: Thomas Backlund <tmb@mandriva.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Updating the LKML bug reporting/updating framework
Message-ID: <20091026145637.GE13941@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Robert Bradbury <robert.bradbury@gmail.com>,
	Thomas Backlund <tmb@mandriva.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <deaa866a0910251559r6c001e6ek553256ac8f81b1f7@mail.gmail.com> <4AE4E026.9070402@mandriva.org> <deaa866a0910260512p1eca02f6k89aa180aec27558d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deaa866a0910260512p1eca02f6k89aa180aec27558d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 08:12:23AM -0400, Robert Bradbury wrote:
> I was unaware of the kernel.org bugzilla database.  Sometimes people
> will go from AT&T UNIX to SGI IRIX to Linux without making a stop at
> kernel.org.  If it comes on a CD and boots relatively easily people
> may not bother with such details.  I think I started using Linux
> around the time I started using Mosaic and that may have been before
> the kernel.org site was as robust as it now appears to be (if it
> existed at all).
> 
> Given the bugzilla database, is the LKML with its high volume and
> noise level (IMO), now largely obsolete [1]?  (I think I a Google
> search may have led me in the direction that it was the place to
> report bugs).

Robert,

Most end users who use a Linux distribution will have a much better
time if they use the support channels (bugzilla, irc, web forums,
etc.) for their particular Linux distribution.  So if you are using
Ubuntu, use the Ubuntu bugzilla and web forums.  If you are using
Fedora, they have their own bugzilla and web forums.  Debian users
have the Debian BTS (Bug Tracking System), as well as many mailing
lists (focused on debian newbies, debian developers, etc.)

The LKML and the kernel bugzilla are best used for people who are
working on the mainline Linux kernel, as opposed to the kernels which
have been snapshotted and customized for each distribution.  Community
distributions, which tend to snapshot every six months, do tend to be
closer to mainline than Enterprise kernels (RHEL, SLES) that snapshot
every 24 months or so, but even some community distributions, such as
Ubuntu, do add a significant number of "value add" (and thus, bugs :-)
to their kernels.

There are also individual sublists for people who are only working on
a specific part of the kernel (i.e., the linux-ext4 mailing list, the
linux-scsi mailing list, etc).

					- Ted
