Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZBOOX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZBOOX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZBOOXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:23:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZBOOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:23:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #12496] swsusp cannot find resume device (sometimes)
Date: Sun, 15 Feb 2009 15:23:05 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.6RG.6s0lJB@chimera> <20090214160542.1c668398@infradead.org>
In-Reply-To: <20090214160542.1c668398@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151523.05840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Arjan van de Ven wrote:
> On Sat, 14 Feb 2009 21:38:16 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12496
> > Subject		: swsusp cannot find resume device (sometimes)
> > Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> > Date		: 2009-01-09 12:24 (37 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=123150395731165&w=4
> > Handled-By	: Arjan van de Ven <arjan@infradead.org>
> > Patch		:
> > http://marc.info/?l=linux-kernel&m=123156441218358&w=4
> > http://marc.info/?t=123156453100002&r=1&w=4
> > 
> > 
> 
> it is sad that a patch for a regression that has been available for
> this long still has not been merged.
> 
> Sending me email over and over again does not make the maintainers
> who have the patch in their queues get off their sit-organs any
> faster....

Sorry, this is a automated thing.  Please just discard the messages about
this bug in the future.

The patch has been sent to Len and hopefully it will be merged shortly.

Thanks,
Rafael
