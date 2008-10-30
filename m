Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYJ3Klq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYJ3Klq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYJ3Kli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:41:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41860 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYJ3Kli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:41:38 -0400
Date: Thu, 30 Oct 2008 11:41:37 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, randy.dunlap@oracle.com,
       ukleinek@strlen.de
Subject: Re: [PATCH 1/8] Add scripts/get_maintainer.pl
Message-ID: <20081030104136.GB32389@atrey.karlin.mff.cuni.cz>
References: <1224803366-6478-1-git-send-email-joe@perches.com> <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com> <20081027155254.a710c779.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027155254.a710c779.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > $ scripts/get_maintainer.pl
> > usage: ./scripts/get_maintainer.pl [options] patchfile
> >        ./scripts/get_maintainer.pl [options] -f file
> > version: 0.12
> 
> Example output would be nice to see.  Hopefully it is in the
> 
> 	Joe Perches <joe@perches.com>
> 
> form, ready to be pasted into an email client?
> 
> otoh, we'll sometimes also want the
> 
> 	joe@perches.com,akpm@linux-foundation.org
> 
> form for use by scripts.
> 
> 
> Also, this:
> 
>  MAINTAINERS | 1096 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 1094 insertions(+), 2 deletions(-)
> 
> isn't practical for me or Stephen to carry, I'm afraid.  That's
> probably the most-patched file in the kernel.  This will need to be a
> direct you->Linus thing.
> 
> I think the feature is sorely needed and will prove useful.

Would you be willing to merge the scripts etc, leaving only
MAINTAINERS file for direct merge with Linus, preferably at the -rc5
or something?

Are you willing to Ack the change to MAINTAINERS file? 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
