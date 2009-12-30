Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZL3VjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZL3VjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZL3VjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:39:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZL3VjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:39:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #14887] suspend doesn't work on X200s
Date: Wed, 30 Dec 2009 22:39:28 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Lutomirski <luto@mit.edu>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.Zg.inhOLB@chimera> <20091230111745.GC4489@kernel.dk>
In-Reply-To: <20091230111745.GC4489@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302239.28792.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, Jens Axboe wrote:
> On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14887
> > Subject		: suspend doesn't work on X200s
> > Submitter	: Andrew Lutomirski <luto@mit.edu>
> > Date		: 2009-12-22 0:45 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126144274102396&w=4
> 
> Works fine for me on an x200s. The only issue I seem to have is that
> sometimes it suspends immediately upon resume again, presumably the lid
> close event is re-triggered (or something to that extent). Apart from
> that, 2.6.32 and current -git works fine for me.

Thanks for the info.

Perhaps the bug that Andrew saw has been fixed since then.

I'm changing the stauts of the bug to "resolved".  Andrew, please reopen if
you're still seeing the problem with the current Linus' tree.

Rafael
