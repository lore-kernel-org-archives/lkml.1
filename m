Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYHFIjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYHFIjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbYHFIjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:39:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12932 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYHFIjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:39:21 -0400
Date: Wed, 6 Aug 2008 10:39:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates against v2.6.26
Message-ID: <20080806103903.6b9eec76@hyperion.delvare>
In-Reply-To: <20080801041026.GI3375@mars.solarsys.private>
References: <20080801041026.GI3375@mars.solarsys.private>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Andrew,

On Fri, 1 Aug 2008 00:10:27 -0400, Mark M. Hoffman wrote:
> Hi Linus:
> 
> Please pull from:
> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release
> 
> You'll get what few patches I've managed to look at in the last few months,
> including a patch to MAINTAINERS which makes it official.  I'm sorry I was
> not able to keep up - I should have admitted defeat much sooner.

I'm sad to see you go (and can only hope that you won't leave the
project entirely). But I would also like to thank you for the good work
you've done. Even if it was short, everything you did is done and
that's something you can be proud of. Especially given the conditions
in which you started in this new role - please forgive me for that.

> To all lm-sensors/hwmon developers: please resend/CC patches to Andrew.

I have a number of hwmon patches in my local kernel tree which I wrote
and that have been reviewed by a trusted developer, or that have been
posted to the lm-sensors list and that I have reviewed. I consider
these ready to go upstream. I plan to gather these into a public tree
and push them to Linus today or tomorrow. In the future, I will
probably have such a tree available to be included in linux-next.

Don't get me wrong, I am _not_ volunteering to become the new hwmon
subsystem maintainer. Remember, I've been there before and you know how
it ended. But in the absence of a subsystem maintainer, I don't want
hwmon patches to be lost (and especially not mine) and I don't think
that pushing everything to Andrew is a good solution either. So I'm
just proposing to do my part of the work. But if Andrew really prefers
to pick all the patches, I am not insisting either.

In the future, I would like to suggest to have 2 hwmon subsystem
maintainers instead of 1. Apparently none of us has the time to do all
the work, but maybe some of us would have the time to do half of it.
This is the path I took for the i2c subsystem, and while the change is
still fairly recent, it seems to be working well enough.

-- 
Jean Delvare
