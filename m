Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbZDGRlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbZDGRlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZDGRlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:41:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37902 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZDGRlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:41:08 -0400
Date: Tue, 7 Apr 2009 19:41:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       gentuu@gmail.com
Subject: Re: [GIT PULL] block updates for 2.6.30-rc1
Message-ID: <20090407174107.GA5178@kernel.dk>
References: <20090407113909.GS5178@kernel.dk> <a4423d670904070444p75bb8811p779ca9ed12719df4@mail.gmail.com> <20090407114923.GT5178@kernel.dk> <alpine.LFD.2.00.0904070837420.27889@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904070837420.27889@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07 2009, Linus Torvalds wrote:
> 
> 
> On Tue, 7 Apr 2009, Jens Axboe wrote:
> > > I sent you a fix for loop device.
> > > http://patchwork.kernel.org/patch/15763/
> > 
> > I missed that the thread had the loop fix as well. I've included it now,
> > looks fine to me. Linus, the new diffstat is now:
> 
> No, I still see the old diffstat. Did you forget to push out?

Ehm yep, it appears so... It's pushed now.

-- 
Jens Axboe

