Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZEQUhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZEQUhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZEQUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:37:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48584 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZEQUh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:37:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13122] reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
Date: Sun, 17 May 2009 22:36:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Jeff Mahoney <jeffm@suse.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.sNC.mZzDKB@chimera> <alpine.LFD.2.01.0905171213160.3301@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905171213160.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905172236.59424.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Linus Torvalds wrote:
> 
> On Sat, 16 May 2009, Rafael J. Wysocki wrote:
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13122
> > Subject		: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > Date		: 2009-04-16 19:23 (31 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d984561b326cd0fe0d1183d11b9b4fa1d011d21d
> > References	: http://marc.info/?l=linux-kernel&m=123990989515105&w=4
> > Handled-By	: Jeff Mahoney <jeffm@suse.com>
> > Patch		: http://lkml.org/lkml/2009/5/10/91
> 
> The fix should now be merged as b83674c0da6558e357c6b482ccf299eeea77d8ef 
> ("reiserfs: fixup perms when xattrs are disabled")

Thanks, closed.

Rafael
