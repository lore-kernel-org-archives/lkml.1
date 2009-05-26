Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZEZSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZEZSrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZEZSrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:47:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbZEZSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:47:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [Bug #13175] sata_nv incompatible with async scsi scan
Date: Tue, 26 May 2009 20:47:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Matthew Wilcox <matthew@wil.cx>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.NgD.lQcGKB@chimera> <4A1C1B08.2080600@panasas.com>
In-Reply-To: <4A1C1B08.2080600@panasas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905262047.20823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Benny Halevy wrote:
> On May. 24, 2009, 22:31 +0300, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Verified to still exist with 2.6.30-rc7 :-(
> 
> [The bug description is misleading though.  More testing
> lead to post-kernel boot problems where initrd cannot find the sata
> devices during its init phase]

Thanks for the update.

What description would be better in your opinion?

Rafael
