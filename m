Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122Ab0AXXNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0AXXNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755Ab0AXXNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:13:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46102 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab0AXXNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:13:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [Bug #15125] hung task - jbd2/dm-1-8 (during raid rebuild)
Date: Mon, 25 Jan 2010 00:14:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.shF.DKMXLB@chimera> <4B5CCE6D.5060402@majjas.com>
In-Reply-To: <4B5CCE6D.5060402@majjas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250014.36889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Michael Breuer wrote:
> On 1/24/2010 5:04 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15125
> > Subject		: hung task - jbd2/dm-1-8 (during raid rebuild)
> > Submitter	: Michael Breuer<mbreuer@majjas.com>
> > Date		: 2010-01-10 21:47 (15 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126316012025978&w=4
> >
> >    
> Not an easy one to recreate. Should probably remain listed for now.

Thanks for the update.

Rafael
