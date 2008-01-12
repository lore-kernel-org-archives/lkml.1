Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbYALWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbYALWBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYALWBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:01:15 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58485 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbYALWBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:01:15 -0500
Date: Sun, 13 Jan 2008 00:00:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc7-git4: Reported regressions from 2.6.23
Message-ID: <20080112220022.GD17276@does.not.exist>
References: <200801122205.34871.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801122205.34871.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 10:05:34PM +0100, Rafael J. Wysocki wrote:
> [RFC: Would that be useful if I sent regression-fixing patches, CCed to the
> appropriate maintainers/lists, along with the reports?]
>...

I don't think sending the patches around brings much advantage.

But I always also Cc'ed all submitters, maintainers and all people 
somehow involved with one or more of the regressions.

This sometimes required splitting the regression lists into 5-7 emails 
due to some vger rule of dropping emails with IIRC >= 30 recipients, but 
the required grouping of regressions also had the advantage that you 
often have regressions that might or might not be related grouped and 
discussed together.

And if you want to push people to work on regressions or get fixes 
into Linus' tree spamming their INBOX'es with personal copies of 
regression reports sometimes gets regressions fixed faster...

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

