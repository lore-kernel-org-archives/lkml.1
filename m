Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0BBUvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:51:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0BBUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:51:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid context
Date: Tue, 2 Feb 2010 21:52:33 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David John <davidjon@xenontk.org>,
       Luiz Augusto von Dentz <luiz.dentz@gmail.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.lME.FFiZLB@chimera> <1264986406.31341.5.camel@localhost.localdomain>
In-Reply-To: <1264986406.31341.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022152.33465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Marcel Holtmann wrote:
> Hi Rafael,
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
> > Subject		: Bluetooth: sleeping function called from invalid context
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2010-01-12 9:19 (20 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e726b17422bade75fba94e625cd35fd1353e682
> > References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
> 
> you have an outdated email from Luiz and I change it to the right one
> now.

Thanks.  Unfortunately the address is from a commit sign-off and the script
picks it up automatically, so I can't really help it (well, I'd have to
remember to edit this particular message manually each time before posting it,
but I tend to forget).

The entry has been updated with a link to your patch.

Rafael
