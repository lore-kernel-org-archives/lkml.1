Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZG0JQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZG0JQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZG0JQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:16:30 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:40711 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZG0JQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:16:29 -0400
Date: Mon, 27 Jul 2009 11:16:23 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Eric Miao <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #13833] Kernel Oops when trying to suspend with ubifs
	mounted on block2mtd mtd device
Message-ID: <20090727091623.GA16229@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	David Brownell <david-b@pacbell.net>,
	David Woodhouse <David.Woodhouse@intel.com>,
	Eric Miao <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.gfC.QHObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.gfC.QHObKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).


Well, the patch reverting the commit still applies to 2.6.31-rc4, so
I assume the issue persists,but I have not tried an unpatched
2.6.31-rc4.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13833
> Subject		: Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
> Submitter	: Tobias Diedrich <ranma@tdiedrich.de>
> Date		: 2009-07-15 14:20 (12 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=15bce40cb3133bcc07d548013df97e4653d363c1
> References	: http://marc.info/?l=linux-kernel&m=124766049207807&w=4
> 		  http://marc.info/?l=linux-kernel&m=124704927819769&w=4
> 

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
