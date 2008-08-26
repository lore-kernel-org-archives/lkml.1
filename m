Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbYHZTKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbYHZTKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbYHZTKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:10:35 -0400
Received: from [93.163.65.50] ([93.163.65.50]:17551 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759610AbYHZTKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:10:34 -0400
Date: Tue, 26 Aug 2008 21:10:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits
Message-ID: <20080826191031.GQ20055@kernel.dk>
References: <20080826070640.GR20055@kernel.dk> <alpine.LFD.1.10.0808261009180.3363@nehalem.linux-foundation.org> <20080826185636.GP20055@kernel.dk> <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26 2008, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Aug 2008, Jens Axboe wrote:
> > 
> > I'll move those 1-2 patches to the 2.6.28 branch and resubmit the rest
> > for you.
> 
> You will *delete* the absolute crap locking patch, that has no way of 
> being even 2.6.28 material.

Yeah, I thought that was obvious, I'll bounce it back to the Xen folks.

> And you need to be a whole lot more careful.

Noted, I'll stick to the straight and narrow.

-- 
Jens Axboe

