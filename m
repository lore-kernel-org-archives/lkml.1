Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZFKUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZFKUES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZFKUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:04:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54593 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZFKUEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:04:08 -0400
Date: Thu, 11 Jun 2009 22:04:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
Message-ID: <20090611200410.GA11363@kernel.dk>
References: <20090611111339.GQ11363@kernel.dk> <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain> <20090611182657.GY11363@kernel.dk> <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain> <20090611185200.GZ11363@kernel.dk> <alpine.LFD.2.01.0906111221391.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111221391.3573@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11 2009, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Jens Axboe wrote:
> > 
> > I pulled from his tree, don't think I ever rebased it.
> 
> I'm pretty sure you did. That's why 
>  (a) you're the committer (because you are)
>  (b) the commits aren't the same when I pull, even though the diffs are.
> 
> Anyway, it's ok to take an occational patch from another tree, but then it 
> needs to be signed off (and no faking of committer data, please) as a 
> cherry-pick, not the way you did it.

I just looked up the offending commits, and you are right. I must have
rebased early on, after having pull some of the patches from Tejun. My
bad, wont repeat!

-- 
Jens Axboe

