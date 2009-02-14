Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZBNTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZBNTxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 14:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZBNTxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 14:53:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43690 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZBNTxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 14:53:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Date: Sat, 14 Feb 2009 20:53:01 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gUG.420jJB@chimera> <20090214142915.GE26628@mini-me.lan>
In-Reply-To: <20090214142915.GE26628@mini-me.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142053.02389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009, Theodore Tso wrote:
> On Sun, Feb 08, 2009 at 08:21:42PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12604
> > Subject		: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
> > Submitter	: Jan Kara <jack@suse.cz>
> > Date		: 2009-01-30 1:23 (10 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31a12666d8f0c22235297e1c1575f82061480029
> > References	: http://marc.info/?l=linux-kernel&m=123327862901800&w=4
> > 
> 
> Note: this has been fixed in mainline as of 2.6.29-rc5, in commit
> 3a4c6800.  So this bug can be closed now...

The bug has been closed already.

Thanks,
Rafael
