Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbZE0TrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbZE0TrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbZE0TrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:47:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56209 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZE0TrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:47:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [Bug #13175] sata_nv incompatible with async scsi scan
Date: Wed, 27 May 2009 21:47:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Matthew Wilcox <matthew@wil.cx>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <200905262047.20823.rjw@sisk.pl> <4A1CEC3D.5030908@panasas.com>
In-Reply-To: <4A1CEC3D.5030908@panasas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905272147.11506.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Benny Halevy wrote:
> On May. 26, 2009, 21:47 +0300, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > On Tuesday 26 May 2009, Benny Halevy wrote:
> >> On May. 24, 2009, 22:31 +0300, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >>> This message has been generated automatically as a part of a report
> >>> of regressions introduced between 2.6.28 and 2.6.29.
> >>>
> >>> The following bug entry is on the current list of known regressions
> >>> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> >>> be listed and let me know (either way).
> >> Verified to still exist with 2.6.30-rc7 :-(
> >>
> >> [The bug description is misleading though.  More testing
> >> lead to post-kernel boot problems where initrd cannot find the sata
> >> devices during its init phase]
> > 
> > Thanks for the update.
> > 
> > What description would be better in your opinion?
> 
> How about: initrd fails to find /dev/sda* (sata_nv)

Thanks, updated.

Rafael
