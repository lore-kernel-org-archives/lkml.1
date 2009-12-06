Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbZLFStn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbZLFStn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbZLFStl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:49:41 -0500
Received: from www.tglx.de ([62.245.132.106]:52781 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933945AbZLFStk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:49:40 -0500
Date: Sun, 6 Dec 2009 19:49:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT pull] bkl core patches for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912061044530.3560@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912061948220.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain> <alpine.LFD.2.00.0912061044530.3560@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Linus Torvalds wrote:
> On Sun, 6 Dec 2009, Thomas Gleixner wrote:
> > 
> > Please pull the latest bkl-core-for-linus git tree from:
> 
> Hmm. Seeing this, I wonder: has anybody kept track of the reiserfs bkl 
> removal?

Yes, Frederic has his own git tree for that, which I reviewed and
monitored. Frederic, what's the latest status ?

Thanks,

	tglx
