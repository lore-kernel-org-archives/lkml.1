Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZJBRbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZJBRbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbZJBRbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:31:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbZJBRbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:31:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.32-rc1-git2: Reported regressions from 2.6.31
Date: Fri, 2 Oct 2009 19:32:27 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera> <1254469139.3531.19.camel@ht.satnam> <4AC5F975.6060505@s5r6.in-berlin.de>
In-Reply-To: <4AC5F975.6060505@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021932.27789.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Stefan Richter wrote:
> Jaswinder Singh Rajput wrote:
> > If you add one more entry say "Suspected commit :" then it will be great
> > and will solve regressions much faster.
> 
> Will?  Might.

In fact I add the "First-Bad-Commit" annotation where there is a bisection
result or it's possible to fix things by reverting a specific commit.

> > You can request submitter to
> > submit 'suspected commit' by git bisect and also specify git bisect
> > links like : (for more information about git bisect check
> > http://kerneltrap.org/node/11753)
> 
> I disagree.  A reporter should only be asked to bisect (using git or
> other tools) /if/ a developer determined that bisection may speed up the
> debugging process or is the only remaining option to make progress with
> a bug.
> 
> It would be wrong to steal a reporter's valuable time by asking for
> bisection before anybody familiar with the matter even had a first look
> at the report.

Agreed.

Thanks,
Rafael
