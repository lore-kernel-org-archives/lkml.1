Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0BBUzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:55:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0BBUzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:55:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidjon@xenontk.org
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
Date: Tue, 2 Feb 2010 21:55:43 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.NbF.2FiZLB@chimera> <4B669F8F.1030402@xenontk.org>
In-Reply-To: <4B669F8F.1030402@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022155.44016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, David John wrote:
> On 02/01/2010 06:13 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
> > Subject		: i915: Commit 0e442c60 causes flickering
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2009-12-09 17:26 (54 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> > References	: http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> > Handled-By	: David John <davidjon@xenontk.org>
> > Patch		: http://patchwork.kernel.org/patch/75423/
> > 
> > 
> > 
> 
> Hi Rafael,
> 
> The patch fixing this has not been merged yet, so the bug should still
> be listed.

Thanks for the update, I'll close the bug when I see the patch in the Linus'
tree.

Rafael
