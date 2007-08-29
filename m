Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXH2SIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXH2SIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXH2SIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:08:05 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5378 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbXH2SID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:08:03 -0400
Date: Wed, 29 Aug 2007 20:08:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Message-ID: <20070829180800.GC7932@kernel.dk>
References: <200708291950.14513.arekm@maven.pl> <20070829175458.GA7932@kernel.dk> <200708292004.36426.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708292004.36426.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> On Wednesday 29 of August 2007, Jens Axboe wrote:
> > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > I guess I should sent these here since it looks like not scsi bug anyway.
> >
> > It's stex, right? It seems to have some issues with multiple completions
> > of commands, which craps out the block layer of course.
> 
> Yes, stex. I'm staying with 2.6.19 in that case since it works fine in that 
> version.
> 
> So scsi bug ... 8-)

And you based that conclusion on what exactly?

-- 
Jens Axboe

