Return-Path: <linux-kernel-owner+w=401wt.eu-S933487AbZLOT1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbZLOT1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbZLOT1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:27:45 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60733 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933487AbZLOT1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:27:32 -0500
Date: Tue, 15 Dec 2009 19:27:14 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Li Hong <lihong.hi@gmail.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: linux-next: manual merge of the mips tree with Linus' tree
Message-ID: <20091215192714.GB18592@linux-mips.org>
References: <20091215102046.6fc8faa8.sfr@canb.auug.org.au>
 <4B273A32.5020407@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B273A32.5020407@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:26:42AM +0100, Michal Simek wrote:

> >Today's linux-next merge of the mips tree got a conflict in
> >scripts/recordmcount.pl between commits
> >e2d753fac5b3954a3b6001f98479f0435fe7c868 ("tracing: Correct the check for
> >number of arguments in recordmcount.pl") and
> >7d241ff0567b9503d79ee775c40927d09b509f83 ("microblaze: ftrace: Add
> >dynamic trace support") from Linus' tree and commits
> >84bc2d35f211a83e806711c94f78a227c4810848 ("MIPS: Tracing: Add an endian
> >argument to scripts/recordmcount.pl") and
> >b2b11a5cb24b8f234bc4746dc40722b01fa45a43 ("MIPS: Tracing: Add dynamic
> >function tracer support") from the mips tree.
> >
> >These conflicts are now between Linus' tree and the mips tree so, Ralf,
> >you should be able to fix them up by merging with Linus' tree.
> >
> >I have fixed them up (see below) (for the first pair of commits above, I
> >used the mips tree version) and can carry the fix for a while.
> 
> Yes, because I sent pull request to Linus and he added Microblaze
> patches to his tree. Sorry for this additional work but you had
> chance to pull your tree first.

No problem.   That's sorted and new pull rq is out.

  Ralf
