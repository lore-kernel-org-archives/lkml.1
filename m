Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZBPVxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZBPVxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBPVw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:52:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZBPVw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:52:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Graham Murray <graham@gmurray.org.uk>
Subject: Re: [Bug #12444] X hangs following switch from radeonfb console - Bisected
Date: Mon, 16 Feb 2009 22:52:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A._pG.Lt0lJB@chimera> <87k57quv4t.fsf@newton.gmurray.org.uk>
In-Reply-To: <87k57quv4t.fsf@newton.gmurray.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162252.49451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Graham Murray wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
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
> > Date		: 2009-01-13 14:03 (33 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
> 
> I am still seeing the problem with 2.6.29-rc5

Thanks for the update.

Rafael
