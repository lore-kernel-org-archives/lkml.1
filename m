Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbZJLVsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbZJLVsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbZJLVsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:48:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36420 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287AbZJLVsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:48:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Buesch <mb@bu3sch.de>, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #14278] New message "NOHZ: local_softirq_pending 08" at each ping request
Date: Mon, 12 Oct 2009 23:49:39 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "John W. Linville" <linville@tuxdriver.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <r-4Wjt4coy.A.VeE.Bbl0KB@chimera> <200910121515.49393.mb@bu3sch.de>
In-Reply-To: <200910121515.49393.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122349.39408.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Michael Buesch wrote:
> On Monday 12 October 2009 00:22:00 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14278
> > Subject		: New message "NOHZ: local_softirq_pending 08" at each ping request
> > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > Date		: 2009-09-30 18:12 (12 days old)
> > Handled-By	: Michael Buesch <mb@bu3sch.de>
> 
> I think John or Johannes is handling it, as my patch was rejected.
> 
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23220

Johannes, what's the status here?

Rafael
