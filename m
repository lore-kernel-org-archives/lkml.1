Return-Path: <linux-kernel-owner+w=401wt.eu-S1763779AbYJJUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763779AbYJJUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761739AbYJJUBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:01:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54994 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380AbYJJUBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:01:36 -0400
Date: Fri, 10 Oct 2008 22:01:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [GIT PULL] block changes for 2.6.28
Message-ID: <20081010200101.GI19428@kernel.dk>
References: <20081010080916.GV19428@kernel.dk> <alpine.LFD.2.00.0810101100190.3503@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810101100190.3503@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Linus Torvalds wrote:
> 
> 
> On Fri, 10 Oct 2008, Jens Axboe wrote:
> > 
> > Please pull from:
> > 
> >         git://git.kernel.dk/linux-2.6-block.git for-2.6.28
> 
> Pulled, but...
> 
> Please don't do changelog entries like this:
> 
> > Jens Axboe (27):
> >       block: revert part of d7533ad0e132f92e75c1b2eb7c26387b25a583c1
> 
> ok, so it had an explanation, but still. That shortlog entry isn't exactly 
> helpful, is it?

Hmm yes, I guess the explanation in the shortlog entry and the commit id
in the changelog would have made more sense.

-- 
Jens Axboe

