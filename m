Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbXHUXgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbXHUXgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXHUXgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:36:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755464AbXHUXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:36:23 -0400
Date: Tue, 21 Aug 2007 16:36:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: richard kennedy <richard@rsk.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-Id: <20070821163614.ad85a341.akpm@linux-foundation.org>
In-Reply-To: <fa9p6n$kvh$1@sea.gmane.org>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<fa9p6n$kvh$1@sea.gmane.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 15:56:07 +0000 (UTC)
richard kennedy <richard@rsk.demon.co.uk> wrote:

> On Thu, 09 Aug 2007 22:42:54 -0700, Andrew Morton wrote:
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-
> rc2/2.6.23-rc2-mm2/
> > 
> > - Various problems from 2.6.23-rc2-mm1 were fixed
> > 
> > 
> > 
> > Boilerplate:
> > 
> > - See the `hot-fixes' directory for any important updates to this
> > patchset.
> > 
> > - To fetch an -mm tree using git, use (for example)
> > 
> >   git-fetch
> >   git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git
> >   tag v2.6.16-rc2-mm1 git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1
> > 
> Hi Andrew,

Please always do reply-to-all.  Otherwise you end up thinking that you're
being ignored ;)

> the git tree you mentioned in the boilerplate doesn't seem to have been 
> updated in about 7 weeks.
> 2.6.22-rc6-mm1 is the last tag I can see on the summary page. Is 
> something broken ?

Yes, the software which auto-imports -mm into git appears to have broken
a few weeks ago.  Matthias has been informed, but I guess he is busy.
