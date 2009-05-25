Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZEYXG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZEYXG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZEYXGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:06:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbZEYXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:06:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
Date: Tue, 26 May 2009 01:06:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard Atterer" <richard@2009.atterer.net>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.51C.SQcGKB@chimera> <200905251448.40907.bzolnier@gmail.com>
In-Reply-To: <200905251448.40907.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260106.41815.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 24 May 2009 21:31:20 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Yep.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13371
> > Subject		: s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
> > Submitter	: Richard Atterer <richard@2009.atterer.net>
> > Date		: 2009-05-16 22:51 (9 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=295f00042aaf6b553b5f37348f89bab463d4a469
> 
> Nope.
> 
> > References	: http://marc.info/?l=linux-kernel&m=124251446428166&w=4
> > Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Casually-Handled-By

OK, updated.

Best,
Rafael
