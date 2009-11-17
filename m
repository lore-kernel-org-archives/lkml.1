Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZKQWPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZKQWPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbZKQWPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:15:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbZKQWPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:15:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Subject: Re: [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
Date: Tue, 17 Nov 2009 23:16:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera> <OWmO9uyC1hM.A.loC.CodALB@chimera> <20091117000911.GA2421@bizet.domek.prywatny>
In-Reply-To: <20091117000911.GA2421@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172316.58298.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Karol Lewandowski wrote:
> On Tue, Nov 17, 2009 at 12:01:19AM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
> > Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
> > Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> > Date		: 2009-09-15 12:05 (63 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4
> 
> Bug is still present in 2.6.32-rc7.

Thanks for the update.

Rafael
