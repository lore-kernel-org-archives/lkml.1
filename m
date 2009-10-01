Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZJAS70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZJAS70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZJAS7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:59:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44398 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZJAS7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:59:25 -0400
Date: Thu, 1 Oct 2009 20:59:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block updates for 2.6.32-rc
Message-ID: <20091001185928.GV14918@kernel.dk>
References: <20090930174109.GD14918@kernel.dk> <alpine.LFD.2.01.0910011143100.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910011143100.6996@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01 2009, Linus Torvalds wrote:
> 
> 
> On Wed, 30 Sep 2009, Jens Axboe wrote:
> > 
> > This looks huge, but it's mostly a cciss driver update and the addition
> > of drbd. I would have submitted this before -rc1, but Plumbers got in
> > the way.
> 
> I'm perfectly happy to pull drbd, but please do it for the next merge 
> window. There's been enough discussion about it that I think we'll be 
> better off giving it some time.

Alright, your call. I'll move the drbd driver to a for-2.6.33 branch.
The tracing bits are already gone, this will give them plenty of time to
kill the connector bits too.

-- 
Jens Axboe

