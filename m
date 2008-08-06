Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbYHFPyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbYHFPyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYHFPyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:54:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815AbYHFPya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:54:30 -0400
Date: Wed, 6 Aug 2008 08:53:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates against v2.6.26
Message-Id: <20080806085324.58d65849.akpm@linux-foundation.org>
In-Reply-To: <20080806103903.6b9eec76@hyperion.delvare>
References: <20080801041026.GI3375@mars.solarsys.private>
	<20080806103903.6b9eec76@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 10:39:03 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> Hi Mark, Andrew,
> 
> On Fri, 1 Aug 2008 00:10:27 -0400, Mark M. Hoffman wrote:
> > Hi Linus:
> > 
> > Please pull from:
> > 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release
> > 
> > You'll get what few patches I've managed to look at in the last few months,
> > including a patch to MAINTAINERS which makes it official.  I'm sorry I was
> > not able to keep up - I should have admitted defeat much sooner.
> 
> I'm sad to see you go (and can only hope that you won't leave the
> project entirely). But I would also like to thank you for the good work
> you've done. Even if it was short, everything you did is done and
> that's something you can be proud of.

yup.

> I have a number of hwmon patches in my local kernel tree which I wrote
> and that have been reviewed by a trusted developer, or that have been
> posted to the lm-sensors list and that I have reviewed. I consider
> these ready to go upstream. I plan to gather these into a public tree
> and push them to Linus today or tomorrow. In the future, I will
> probably have such a tree available to be included in linux-next.
> 
> Don't get me wrong, I am _not_ volunteering to become the new hwmon
> subsystem maintainer. Remember, I've been there before and you know how
> it ended. But in the absence of a subsystem maintainer, I don't want
> hwmon patches to be lost (and especially not mine) and I don't think
> that pushing everything to Andrew is a good solution either. So I'm
> just proposing to do my part of the work. But if Andrew really prefers
> to pick all the patches, I am not insisting either.

That would be great, thanks.

But it does mean that I'd prefer that any hwmon patches which I pick up
are merged via that tree if that's OK.  Which all does end up making
you look awfully like an hwmon maintainer..

> In the future, I would like to suggest to have 2 hwmon subsystem
> maintainers instead of 1. Apparently none of us has the time to do all
> the work, but maybe some of us would have the time to do half of it.
> This is the path I took for the i2c subsystem, and while the change is
> still fairly recent, it seems to be working well enough.

Sure.  Having additional people reviewing, testing and generally caring
for changes has practically zero downside.

