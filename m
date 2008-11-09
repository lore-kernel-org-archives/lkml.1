Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbYKIXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbYKIXZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYKIXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:25:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45498 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbYKIXZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:25:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [Bug #11925] cdrom: missing compat ioctls
Date: Mon, 10 Nov 2008 00:29:10 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.3XG.z4zFJB@chimera> <jeiqqwjyis.fsf@sykes.suse.de>
In-Reply-To: <jeiqqwjyis.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811100029.11044.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Andreas Schwab wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11925
> > Subject		: cdrom: missing compat ioctls
> > Submitter	: Andreas Schwab <schwab@suse.de>
> > Date		: 2008-10-31 14:02 (10 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33c2dca4957bd0da3e1af7b96d0758d97e708ef6
> > Handled-By	: Andreas Schwab <schwab@suse.de>
> > Patch		: http://marc.info/?l=linux-kernel&m=122548923531545&w=2
> 
> The patch has been picked up by akpm.

OK, but has it been merged into mainline already?

Rafael
