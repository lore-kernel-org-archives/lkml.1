Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZHCPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZHCPWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZHCPWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:22:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbZHCPWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:22:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: [Bug #13895] 2.6.31-rc4 - slab entry tak_delay_info leaking ???
Date: Mon, 3 Aug 2009 17:23:10 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.tsB.ocgdKB@chimera> <20090803081916.4189bad4@tux.DEF.witbe.net>
In-Reply-To: <20090803081916.4189bad4@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031723.10649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Paul Rolland wrote:
> Hello Rafael,
> 
> On Sun,  2 Aug 2009 20:58:32 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13895
> > Subject		: 2.6.31-rc4 - slab entry tak_delay_info
> > leaking ??? Submitter	: Paul Rolland <rol@as2917.net>
> > Date		: 2009-07-29 08:20 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124884847925375&w=4
> 
> Still trying to reproduce with kmemleak enabled, but so far no luck.
> 
> Will soon switch to 2.6.31-rc5-no-kmemleak to check if still present.

Thanks for the update.

Rafael
