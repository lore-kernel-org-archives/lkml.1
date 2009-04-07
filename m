Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZDGT6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZDGT6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZDGT6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:58:01 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56388 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbZDGT6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:58:00 -0400
Date: Tue, 7 Apr 2009 15:57:59 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Message-ID: <20090407195759.GU3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <20090404201820.GA18067@elte.hu> <20090406215034.GD3797@csclub.uwaterloo.ca> <49DB55B9.7030108@rtr.ca> <20090407144801.GR3795@csclub.uwaterloo.ca> <49DBA7AB.7020409@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DBA7AB.7020409@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:21:15PM -0400, Mark Lord wrote:
> Mmm.. now that could be problem.
>
> I wonder if mythfrontend is simply getting paged out of memory,
> until you press a button and then the relevant code has to all
> get paged back in again before it can respond (?).

While the video is playing?  Well it is possible I guess.  I haven't had
it happen in a while, so perhaps that was a mythtv bug that got fixed
since the keyboard worked fine if I switch to vt1 for example.

-- 
Len Sorensen
