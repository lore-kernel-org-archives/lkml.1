Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZHCUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZHCUzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZHCUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:55:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZHCUzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:55:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13770] System freeze on XFS filesystem recovery on an external disk
Date: Mon, 3 Aug 2009 22:55:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jean-Luc Coulon" <jean.luc.coulon@gmail.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.OpD.ZdgdKB@chimera> <alpine.DEB.2.01.0908031331190.5831@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0908031331190.5831@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032255.54907.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Christian Kujau wrote:
> On Sun, 2 Aug 2009 at 20:58, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13770
> > Subject		: System freeze on XFS filesystem recovery on an external disk
> > Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> > Date		: 2009-07-14 10:31 (20 days old)
> 
> Jean-Luc points out in http://bugzilla.kernel.org/show_bug.cgi?id=13770#c4
> 
>   > I thought it was a regression but doing quite intensive tests, I had a
>   > problem with 2.6.30 as well and eventually the system was frozen.
> 
> So, maybe it can be dropped from the regression list?

For now I moved it to the list of regressions introduced between 2.6.29 and
2.6.30.

Thanks,
Rafael
