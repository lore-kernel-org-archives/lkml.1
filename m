Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZJZWKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZJZWKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZJZWKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:10:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60809 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZJZWKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:10:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14375] Intel(R) I/OAT DMA Engine init failed
Date: Mon, 26 Oct 2009 23:12:21 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.bIH.qre5KB@chimera> <a4423d670910261457o2e1ccb7t768199dfd9985270@mail.gmail.com>
In-Reply-To: <a4423d670910261457o2e1ccb7t768199dfd9985270@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262312.21298.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Alexander Beregalov wrote:
> 2009/10/26 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14375
> > Subject         : Intel(R) I/OAT DMA Engine init failed
> > Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> > Date            : 2009-10-02 9:46 (25 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125447680016160&w=4
> > Handled-By      : Dan Williams <dan.j.williams@intel.com>
> > Patch           : http://patchwork.kernel.org/patch/51808/
> 
> When I patch reiserfs the bug goes to libata, it means ioatdma works
> and libata does not. It looks like inaccurate work with memory
> somewhere, but I do not know how to find it.
> I cannot reproduce it since 2.6.32-rc3 and I do not see any bugs since then.

Since you can't reproduce it with -rc3 and later, I'm going to close it now.
Please reopen if the problem reappears.

Best,
Rafael
