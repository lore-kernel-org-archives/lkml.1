Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbZHJOwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbZHJOwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZHJOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:52:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZHJOwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:52:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: 2.6.31-rc5-git5: Reported regressions from 2.6.30
Date: Mon, 10 Aug 2009 16:52:53 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <1249914643.4089.3.camel@mulgrave.site>
In-Reply-To: <1249914643.4089.3.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101652.53558.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, James Bottomley wrote:
> On Sun, 2009-08-09 at 22:36 +0200, Rafael J. Wysocki wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13716
> > Subject         : The AIC-7892P controller does not work any more
> > Submitter       : Andrej Podzimek <andrej@podzimek.org>
> > Date            : 2009-07-05 19:23 (36 days old)
> 
> This one sounds like an IRQ routing error, so probably ACPI, but we've
> been totally unsuccessful at getting any further information out of the
> submitter.  Use your own time judgement on this, but if he hasn't been
> responding to you either for 36 days, I'd suggest closing this as
> unresponsive.

Thanks, I've closed it.

Best,
Rafael
