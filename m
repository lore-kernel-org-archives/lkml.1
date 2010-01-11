Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071Ab0AKTzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0AKTzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947Ab0AKTzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:55:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34954 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0AKTzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:55:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
Date: Mon, 11 Jan 2010 20:56:18 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <b170af451001110449w134af1f9we804205a5febcaca@mail.gmail.com>
In-Reply-To: <b170af451001110449w134af1f9we804205a5febcaca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001112056.19042.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Rafał Miłecki wrote:
> 2010/1/10 Rafael J. Wysocki <rjw@sisk.pl>:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14747
> > Subject         : bisected 2.6.32 regression: synaptics touchpad doesn't work
> > Submitter       : François Valenduc <francois.valenduc@tvcablenet.be>
> > Date            : 2009-12-06 11:16 (36 days old)
> 
> Not sure if this is hackish or not, but some patch exists.

Thanks, updated.

Well, I guess the hackish is rather inevitable in this particular case ...

Rafael
