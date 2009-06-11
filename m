Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbZFKTYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbZFKTYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZFKTYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:24:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbZFKTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:24:40 -0400
Date: Thu, 11 Jun 2009 12:23:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Tejun Heo <tj@kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
In-Reply-To: <20090611185200.GZ11363@kernel.dk>
Message-ID: <alpine.LFD.2.01.0906111221391.3573@localhost.localdomain>
References: <20090611111339.GQ11363@kernel.dk> <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain> <20090611182657.GY11363@kernel.dk> <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain> <20090611185200.GZ11363@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Jens Axboe wrote:
> 
> I pulled from his tree, don't think I ever rebased it.

I'm pretty sure you did. That's why 
 (a) you're the committer (because you are)
 (b) the commits aren't the same when I pull, even though the diffs are.

Anyway, it's ok to take an occational patch from another tree, but then it 
needs to be signed off (and no faking of committer data, please) as a 
cherry-pick, not the way you did it.

			Linus
