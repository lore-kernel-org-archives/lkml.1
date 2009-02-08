Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZBHWGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZBHWGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZBHWF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:05:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39936 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbZBHWFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:05:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.29-rc4: Reported regressions from 2.6.28
Date: Sun, 8 Feb 2009 23:04:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <alpine.LFD.2.00.0902081354150.3048@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902081354150.3048@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902082304.53585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Linus Torvalds wrote:
> 
> On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12669
> > Subject		: 2.6.28.4 regression: mmap fails if mlockall used
> > Submitter	: Sami Farin <safari-kernel@safari.iki.fi>
> > Date		: 2009-02-08 10:52 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123409037423068&w=4
> 
> Oh, Hugh just sent a patch, and it's now commit 
> d5b562330ec766292a3ac54ae5e0673610bd5b3d. Sadly this just missed -rc4 by 
> something like 20 minutes..

Yes, I saw the Hugh's message right after sending the report.

Bug closed.

Thanks,
Rafael
