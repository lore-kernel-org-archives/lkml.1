Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYGQIMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYGQIMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYGQILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:11:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYGQILy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:11:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
In-Reply-To: Andrew Morton's message of  Thursday, 17 July 2008 00:39:59 -0700 <20080717003959.edf6531c.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080717003959.edf6531c.akpm@linux-foundation.org>
Emacs: a learning curve that you can use as a plumb line.
Message-Id: <20080717081121.DEB6015411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 01:11:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's a strange time to be sending this.

I've never managed to understand how the timing of your cycles works
exactly, and I really just work on the "send it when you can" principle.
To be honest all I really know is that stuff is going in now, and that
I think this stuff of mine is ready to go.

> That being said, the impact on existing code is fairly modest and we
> could perhaps slip it into 2.6.27-rc1.  I haven't looked at it yet.

I really hope this can be merged in soon (for 2.6.27).  I do think its
impact is low.  The sooner this goes in, the sooner arch folks can round
out all their bits and the more time folks like me can spend on actually
making something new and interesting happen in this area.

I am happy to do whatever merging/rebasing work helps that happen the
soonest.  If there is a different GIT tree to branch a rebase from,
that is easy for me to do.


Thanks,
Roland

