Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYHXTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYHXTX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYHXTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:23:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39995 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbYHXTXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:23:44 -0400
Date: Sun, 24 Aug 2008 22:23:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080824192252.GB1627@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241201090.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808241201090.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 12:03:37PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11356
> > Subject		: Linux 2.6.27-rc3 - build failure: undefined reference to `.lockdep_count_forward_deps'
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2008-08-16 19:11 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121891396320127&w=4
> 
> Hmm. Wasn't this already confirmed to be fixed by commit
> df60a8441866153d691ae69b77934904c2de5e0d? 
> 
> At least Adrian sent out an email saying "Confirmed, bug closed.", but 
> bugzilla seems to disagree and still show it as open.

There were two different reports, Rafael opened a bug for each, and I 
missed that there were two open bugs for the same issue.

The one I closed was #11344.

I've now closed #11356 as a duplicate of #11344.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

