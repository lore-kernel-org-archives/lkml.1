Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZHJOKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZHJOKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZHJOKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:10:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZHJOKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:10:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Brown <neilb@suse.de>
Subject: Re: [Bug #13944] MD raid regression
Date: Mon, 10 Aug 2009 16:11:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mike Snitzer" <snitzer@redhat.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.RyC.aj1fKB@chimera> <19071.30809.398179.900584@notabene.brown>
In-Reply-To: <19071.30809.398179.900584@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101611.07170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Neil Brown wrote:
> On Sunday August 9, rjw@sisk.pl wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes, it still should be listed.  The first patch didn't quite fix it.
> A second one probably does.

Thanks for the update.

Is the patch listed below the right one?

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13944
> > Subject		: MD raid regression
> > Submitter	: Mike Snitzer <snitzer@redhat.com>
> > Date		: 2009-08-05 15:06 (5 days old)
> > Handled-By	: NeilBrown <neilb@suse.de>
> > Patch		: http://patchwork.kernel.org/patch/39521/

Rafael
