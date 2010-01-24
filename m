Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822Ab0AXXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0AXXFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343Ab0AXXFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:05:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0AXXFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:05:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
Date: Mon, 25 Jan 2010 00:06:09 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <len.brown@intel.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Zhang Rui <rui.zhang@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.QkH.LZMXLB@chimera> <b170af451001241444u449d5be6i194b825ff7f5e02e@mail.gmail.com>
In-Reply-To: <b170af451001241444u449d5be6i194b825ff7f5e02e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001250006.10039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Rafał Miłecki wrote:
> 2010/1/24 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15096
> > Subject         : Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
> > Submitter       : Rafał Miłecki <zajec5@gmail.com>
> > Date            : 2010-01-20 23:15 (5 days old)
> 
> Still should be, didn't hear about any fix, didn't see any.

Thanks for the update.

Rafael
