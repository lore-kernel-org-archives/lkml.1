Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432Ab0AKWKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab0AKWKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326Ab0AKWKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:10:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35561 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0AKWKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:10:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: 2.6.33-rc3-git3: Reported regressions from 2.6.32
Date: Mon, 11 Jan 2010 23:10:20 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
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
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <20100111214603.GA4335@emergent.ellipticsemi.com>
In-Reply-To: <20100111214603.GA4335@emergent.ellipticsemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112310.21048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Nick Bowler wrote:
> On 23:27 Sun 10 Jan     , Rafael J. Wysocki wrote:
> > This message contains a list of some regressions from 2.6.32, for which there
> > are no fixes in the mainline I know of.  If any of them have been fixed already,
> > please let me know.
> > 
> > If you know of any other unresolved regressions from 2.6.32, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> 
> Here are two that I don't see in the list:
> 
>  * LVDS downclocking breaks on G45/thinkpad T500
> 
>      LKML: http://lkml.org/lkml/2009/12/26/40
>      FDO:  http://bugs.freedesktop.org/show_bug.cgi?id=25809

Added this one.

>  * Receive failure in et131x (Alan Cox sent me a patch for this but
>                               it's not in mainline yet)
> 
>      LKML: http://lkml.org/lkml/2009/12/29/210

This one is a staging driver, so I'm not going to list it.

Thanks,
Rafael
