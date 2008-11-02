Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYKBWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYKBWFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYKBWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:05:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbYKBWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:05:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [Bug #11907] NVRAM being corrupted on ppc64 preventing boot
Date: Sun, 2 Nov 2008 23:10:08 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera> <4xS1r6m15_B.A.2F.3ueDJB@chimera> <18702.8817.634094.493649@cargo.ozlabs.ibm.com>
In-Reply-To: <18702.8817.634094.493649@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811022310.09056.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 2 of November 2008, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> 
> The commit that introduced the problem went into Linus' tree after
> 2.6.27, so it's not a regression from 2.6.26.  In other words, 2.6.27
> doesn't have the problem.  It's a firmware bug in some old firmware
> versions that got triggered by the kernel change, not a kernel bug per
> se.
> 
> The commit has been reverted in Linus' tree now, so there isn't a
> regression from 2.6.27 any more.

Thanks, updated and closed.

Rafael
