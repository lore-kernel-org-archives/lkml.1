Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYDZLBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYDZLBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYDZLBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:01:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46453 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYDZLBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:01:07 -0400
Date: Sat, 26 Apr 2008 14:00:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: If you want me to quit I will quit
Message-ID: <20080426110044.GB2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1209190455.14173.13.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [BUILDFIX PATCH] au0828: debug is a poor global identifier

Another issue for which I already sent a (slightly different) patch.

Why not check the mailing list before duplicating work? [1]

And if you e.g. discover next that our x86 userspace headers in
2.6.25 (sic) are fucked up guess who already sent a patch last 
weekend... [2]

Why do other people get over 100 checkpatch fixes into the tree at once 
or Linus applies patches directly bypassing the maintainers (like the 
one you sent just before [3], which I've also already sent before [4]) 
but my patches bitrot forever?

And Linus didn't even bother to answer what the correct path for my 
patches is. [5]

My current record is sending a patch 7 times (and still counting) 
without it getting applied anywhere. [6]

And if anyone has doubts in the quality of my patches try to find
commits of me in Linus' tree that introduced any bugs - you most 
likely won't find 3 buggy commits among my last 500 commits.

Guys, this is neither a kindergarten nor the right place for corporate 
mobbing games. If you want to get rid of me simply say so and I'll 
immediately unsubscribe and stop bothering you with patches.

Really annoyed
Adrian

[1] http://lkml.org/lkml/2008/4/25/376
[2] http://lkml.org/lkml/2008/4/20/181
[3] http://lkml.org/lkml/2008/4/25/511
[4] http://lkml.org/lkml/2008/4/24/523
[5] http://lkml.org/lkml/2008/4/2/369
[6] http://lkml.org/lkml/2008/4/21/523
    http://lkml.org/lkml/2008/4/21/577

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

