Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYAGUpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYAGUpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbYAGUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:45:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931AbYAGUpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:45:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Bligh <mbligh@mbligh.org>
Subject: Re: change SCSI owner in bugzilla
Date: Mon, 7 Jan 2008 21:47:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>
References: <20080106161635.GL2082@does.not.exist> <47828CC7.7060106@mbligh.org>
In-Reply-To: <47828CC7.7060106@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801072147.53011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Martin Bligh wrote:
> 
> > Date: Sun, 06 Jan 2008 10:00:33 -0600
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > To: Adrian Bunk <bunk@kernel.org>
> > Cc: Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
> > 	Linus Torvalds <torvalds@linux-foundation.org>,
> > 	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
> > 	Andrew Morton <akpm@linux-foundation.org>,
> > 	Al Viro <viro@ftp.linux.org.uk>
> > Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
> > 
> > On Sun, 2008-01-06 at 17:45 +0200, Adrian Bunk wrote:
> >> Bugzilla for tracking and mailing lists for discussing are not mutually 
> >> exclusive.
> > 
> > I didn't ever say they were.  What I said was we needed the work flow on
> > the mailing lists.
> > 
> >> What about asking the Bugzilla admins to set the default owner of new 
> >> SCSI bugs to linux-scsi@vger.kernel.org?
> >>
> >> This way all SCSI bugs submitted in Bugzilla will automatically be 
> >> forwarded to the linux-scsi mailing list.
> > 
> > Well, I've only been asking for this for the last two years.  If you can
> > actually make it happen, I'd be eternally grateful.
> 
> OK, changed it.
> 
> I don't think this is the right way to do it, as you'll get email for
> every change to every bug until it's assigned, but seeing as that's what
> you asked for, and we can't seem to get vger to take bounces, I guess
> it'll do.
> 
> Let me know if (a) it works OK, and (b) you want the driver ones changed
> over as well.

BTW, would that be possible to forward messages sent to
power-management_other@kernel-bugs.osdl.org to
linux-pm@lists.linux-foundation.org?

Rafael
