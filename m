Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbXKMVAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbXKMVAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXKMVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:00:35 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2601 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759380AbXKMVAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:00:34 -0500
Date: Tue, 13 Nov 2007 22:00:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [GIT PATCH] hwmon updates against v2.6.24-rc2
Message-ID: <20071113220030.6dd5e0d7@hyperion.delvare>
In-Reply-To: <20071113131210.GA2674@jupiter.solarsys.private>
References: <20071113131210.GA2674@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, 13 Nov 2007 08:12:10 -0500, Mark M. Hoffman wrote:
> Hi Linus:
> 
> Please pull from:
> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release
> 
> You'll get one new driver, a few cleanups, and a few bugfixes.  This
> takes care of all known regressions; hopefully it's the last you hear
> from me before 2.6.24-final.
> 
> Note: the f75375s/n2100 patches especially are critical to avoid
> possible overheating problems on that platform (yay crappy BIOS).
> 
> All of these patches have spent considerable time in -mm.

Let me have a doubt, considering that the last public -mm kernel was
released over a month ago (October 12th), which is before your previous
pull request (October 14th). I don't think that any of these patches
has been in even one public -mm tree, so in practice they probably
didn't receive any public testing at all.

Now let's hope that nothing breaks.

-- 
Jean Delvare
