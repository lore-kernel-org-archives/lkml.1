Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbZFWLMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbZFWLMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZFWLMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:12:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43010 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZFWLMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:12:07 -0400
Date: Tue, 23 Jun 2009 13:12:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: merging the per-bdi writeback patchset
Message-ID: <20090623111209.GZ31415@kernel.dk>
References: <20090623081156.GT31415@kernel.dk> <20090623110933.GA16565@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623110933.GA16565@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23 2009, Christoph Hellwig wrote:
> On Tue, Jun 23, 2009 at 10:11:56AM +0200, Jens Axboe wrote:
> > Hi,
> > 
> > Things are looking good for this patchset and it's been in -next for
> > almost a week without any reports of problems. So I'd like to merge it
> > for 2.6.31 if at all possible. Any objections?
> 
> Last time we discussed this you said you're happy with 2.6.32.  I really
> want to take a more detailed look and put that on the not so urgent list
> because ou didn't seem to rush for .31.  So my vote goes for waiting a
> bit longer.

Yeah, 2.6.32 works for me too, .31 would have been nice though so I
don't have to carry it around anymore. But either is fine, if you and
Andrew want more time to review this stuff, then lets just settle for
.32.

-- 
Jens Axboe

