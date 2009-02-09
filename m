Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZBICdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZBICdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZBICcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:32:51 -0500
Received: from kroah.org ([198.145.64.141]:56557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753765AbZBICcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:32:51 -0500
Date: Sun, 8 Feb 2009 18:27:00 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12496] swsusp cannot find resume device (sometimes)
Message-ID: <20090209022700.GA10979@kroah.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gWH.s30jJB@chimera> <20090208163817.6a53d026@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208163817.6a53d026@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 04:38:17PM -0800, Arjan van de Ven wrote:
> On Sun,  8 Feb 2009 20:21:39 +0100 (CET)
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
> > Date		: 2009-01-09 12:24 (31 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=123150395731165&w=4
> > Handled-By	: Arjan van de Ven <arjan@infradead.org>
> > Patch		:
> > http://marc.info/?l=linux-kernel&m=123156441218358&w=4
> > http://marc.info/?t=123156453100002&r=1&w=4
> > 
> > 
> 
> the patches are in -mm waiting for gregkh to pick them up and push...

Ok, I'm totally confused now, care to point out exactly which ones I
should be picking up and pushing?

thanks,

greg "i'm slow, humor me" k-h
