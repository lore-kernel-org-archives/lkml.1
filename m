Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZBWOhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZBWOhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZBWOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:36:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZBWOg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:36:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug #12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Mon, 23 Feb 2009 15:36:19 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arthur Jones <ajones@riverbed.com>, C Sights <csights@fastmail.fm>,
       Eric Sandeen <sandeen@redhat.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.UsB.m50lJB@chimera> <20090223122248.GD19739@mit.edu>
In-Reply-To: <20090223122248.GD19739@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231536.20878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Theodore Tso wrote:
> On Sat, Feb 14, 2009 at 09:50:20PM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
> > Subject		: journal activity on inactive partition causes inactive harddrive spinup
> > Submitter	: C Sights <csights@fastmail.fm>
> > Date		: 2008-12-14 11:39 (63 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
> > Handled-By	: Eric Sandeen <sandeen@redhat.com>
> > 
> 
> The fix for this has landed in mainline as commit 02ac59 for ext3, and
> commit 9eddac for ext4.
> 
> Rafael, I've marked the bug closed in BZ for your convenience.

Thanks a lot!

Best,
Rafael
