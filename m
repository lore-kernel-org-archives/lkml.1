Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZGGLOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZGGLOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZGGLNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:13:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZGGLNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:13:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #13673] HIGHMEM64G causes hang in PCI init on 32-bit x86
Date: Tue, 7 Jul 2009 13:14:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Matthew Wilcox" <matthew@wil.cx>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.HoE.b0oUKB@chimera> <19027.4815.420637.375450@pilspetsen.it.uu.se>
In-Reply-To: <19027.4815.420637.375450@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071314.05338.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Mikael Pettersson wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13673
> > Subject		: HIGHMEM64G causes hang in PCI init on 32-bit x86
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-06-26 15:59 (11 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linu=
> > x-2.6.git;a=3Dcommit;h=3D95ee14e4379c5e19c0897c872350570402014742
> > References	: http://marc.info/?l=3Dlinux-pci&m=3D124615181602643&w=3D4
> > Handled-By	: H. Peter Anvin <hpa@zytor.com>
> 
> Fixed in 2.6.31-rc2.

Thanks, closed.

Best,
Rafael
