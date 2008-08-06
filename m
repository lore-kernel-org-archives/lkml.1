Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYHFSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYHFSDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYHFSDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:03:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25496 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbYHFSDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:03:13 -0400
Date: Wed, 6 Aug 2008 20:03:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates against v2.6.26
Message-ID: <20080806200301.6597e42d@hyperion.delvare>
In-Reply-To: <20080806085324.58d65849.akpm@linux-foundation.org>
References: <20080801041026.GI3375@mars.solarsys.private>
	<20080806103903.6b9eec76@hyperion.delvare>
	<20080806085324.58d65849.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 6 Aug 2008 08:53:24 -0700, Andrew Morton wrote:
> On Wed, 6 Aug 2008 10:39:03 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > I have a number of hwmon patches in my local kernel tree which I wrote
> > and that have been reviewed by a trusted developer, or that have been
> > posted to the lm-sensors list and that I have reviewed. I consider
> > these ready to go upstream. I plan to gather these into a public tree
> > and push them to Linus today or tomorrow. In the future, I will
> > probably have such a tree available to be included in linux-next.
> > 
> > Don't get me wrong, I am _not_ volunteering to become the new hwmon
> > subsystem maintainer. Remember, I've been there before and you know how
> > it ended. But in the absence of a subsystem maintainer, I don't want
> > hwmon patches to be lost (and especially not mine) and I don't think
> > that pushing everything to Andrew is a good solution either. So I'm
> > just proposing to do my part of the work. But if Andrew really prefers
> > to pick all the patches, I am not insisting either.
> 
> That would be great, thanks.
> 
> But it does mean that I'd prefer that any hwmon patches which I pick up
> are merged via that tree if that's OK.  Which all does end up making
> you look awfully like an hwmon maintainer..

No, that's not OK, sorry. This goes beyond what I can offer at this
point in time.

I offered to push selected patches to Linus, with no other guarantee
than the fact that said patches have been carefully reviewed and are
believed to be correct. I do not have the time to do more than that.

If this isn't OK with you, then I will have to withdraw my proposal.
It's up to you.

-- 
Jean Delvare
