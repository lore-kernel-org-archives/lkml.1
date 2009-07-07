Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZGGLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZGGLgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZGGLgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:36:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZGGLgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:36:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andres Freund <andres@anarazel.de>
Subject: Re: 2.6.31-rc2: Reported regressions from 2.6.30
Date: Tue, 7 Jul 2009 13:36:51 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907070325.51439.andres@anarazel.de>
In-Reply-To: <200907070325.51439.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071336.53308.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Andres Freund wrote:
> Hi Rafael,
> 
> On Tuesday 07 July 2009 01:42:09 Rafael J. Wysocki wrote:
> > If you know of any other unresolved regressions from 2.6.30, please let me
> > know either and I'll add them to the list.  Also, please let me know if any
> > of the entries below are invalid.
> There is also http://lkml.org/lkml/2009/6/30/398 : Soft-Lockup/Race in 
> networking in 2.6.31-rc1+195 (possibly caused by netem)

Thanks, added to the list.

Best,
Rafael
