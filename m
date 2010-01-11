Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191Ab0AKUK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0AKUK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090Ab0AKUK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:10:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35084 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0AKUK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:10:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [Bug #15031] bug in fs/btrfs/ordered-data.c:672
Date: Mon, 11 Jan 2010 21:11:34 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Yan, Zheng" <yanzheng@21cn.com>, Chris Mason <chris.mason@oracle.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.0sG.6MlSLB@chimera> <20100111003839.GA6216@Pilar>
In-Reply-To: <20100111003839.GA6216@Pilar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112111.34494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Carlos R. Mafra wrote:
> On So 10.Jan'10 at 23:32:57 +0100, Rafael J. Wysocki wrote:
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15031
> > Subject		: bug in fs/btrfs/ordered-data.c:672
> > Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> > Date		: 2010-01-02 11:32 (9 days old)
> > References	: http://lkml.org/lkml/2010/1/2/17
> > Handled-By	: Yan, Zheng <yanzheng@21cn.com>
> > Patch		: http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03686.html
> 
> I am using the patch above since Zheng pointed it out to me and the bug
> no longer appears. But it is not in mainline yet.

Thanks for the update.

Rafael
