Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbZF2X36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbZF2X36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZF2X3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:29:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZF2X3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:29:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Bug #13653] system hangs after resume from suspend to disk, mce related
Date: Tue, 30 Jun 2009 01:30:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.EED.DJASKB@chimera> <4A480E54.3060405@jp.fujitsu.com>
In-Reply-To: <4A480E54.3060405@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300130.27909.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Hidetoshi Seto wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13653
> > Subject		: system hangs after resume from suspend to disk, mce related
> > Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date		: 2009-06-21 19:02 (8 days old)
> > References	: http://lkml.org/lkml/2009/6/21/86
> > Handled-By	: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> > Patch		: http://patchwork.kernel.org/patch/32062/
> 
> The patch above, in /32062/, is for another bug related to timer
> migration (waring message reported with check_interval=1).
> 
> Real patch for this bug is:
>  http://patchwork.kernel.org/patch/31907/

Thanks, updated.

Best,
Rafael
