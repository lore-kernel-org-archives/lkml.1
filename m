Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZFGVM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZFGVM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZFGVMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:12:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZFGVMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:12:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marc Dionne <marc.c.dionne@gmail.com>
Subject: Re: [Bug #13423] JMicron SATA controller not available
Date: Sun, 7 Jun 2009 23:13:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yu Zhao <yu.zhao@intel.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.2oG.IZ7KKB@chimera> <4A2BDB64.6020404@gmail.com>
In-Reply-To: <4A2BDB64.6020404@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072313.20448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Marc Dionne wrote:
> On 06/07/2009 05:52 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13423
> > Subject		: JMicron SATA controller not available
> > Submitter	: Marc Dionne<marc.c.dionne@gmail.com>
> > Date		: 2009-05-26 22:56 (13 days old)
> > References	: http://lkml.org/lkml/2009/5/26/687
> > Handled-By	: Yu Zhao<yu.zhao@intel.com>
> > Patch		: http://lkml.org/lkml/2009/5/27/402
> 
> I verified that the bug is still there in mainline from this morning.
> 
> The fix is part of this pull request:
> 	http://lkml.org/lkml/2009/6/6/148
> so hopefully it will make it in before the final release.

Thanks for the update.

Best,
Rafael
