Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYKIXA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYKIXA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYKIXAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:00:15 -0500
Received: from mail.suse.de ([195.135.220.2]:49781 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbYKIXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:00:13 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11925] cdrom: missing compat ioctls
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	<wnN9HICUAgP.A.3XG.z4zFJB@chimera>
X-Yow: Yow!  I'm out of work...I could go into shock absorbers...or SCUBA
 GEAR!!
Date: Mon, 10 Nov 2008 00:00:11 +0100
In-Reply-To: <wnN9HICUAgP.A.3XG.z4zFJB@chimera> (Rafael J. Wysocki's message
	of "Sun, 9 Nov 2008 18:59:12 +0100 (CET)")
Message-ID: <jeiqqwjyis.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11925
> Subject		: cdrom: missing compat ioctls
> Submitter	: Andreas Schwab <schwab@suse.de>
> Date		: 2008-10-31 14:02 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33c2dca4957bd0da3e1af7b96d0758d97e708ef6
> Handled-By	: Andreas Schwab <schwab@suse.de>
> Patch		: http://marc.info/?l=linux-kernel&m=122548923531545&w=2

The patch has been picked up by akpm.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
