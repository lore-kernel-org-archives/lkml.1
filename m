Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbXJVTVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbXJVTVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXJVTVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:21:45 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18083 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXJVTVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:21:44 -0400
Date: Mon, 22 Oct 2007 21:21:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_exec_internal crash at boot in -git22
Message-ID: <20071022192138.GG16425@kernel.dk>
References: <200710222008.08095.ak@suse.de> <20071022182645.GE16425@kernel.dk> <200710222117.00521.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710222117.00521.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007, Andi Kleen wrote:
> On Monday 22 October 2007 20:26:45 Jens Axboe wrote:
> > On Mon, Oct 22 2007, Andi Kleen wrote:
> > > 
> > > One of the systems tested in autoboot crashes at boot with with -git22.
> > > This is a AMD 2 socket Opteron NUMA system.
> > > 
> > > The tester was a little flakey and happened to hit the x86-merge-broke-
> > > compilation window, so the last good data point I have is 2.6.23-rc9.
> > 
> > Andi, can you test with this patch applied?
> > 
> > http://brick.kernel.dk/sg-git.patch
> Sorry was a mistake (cue: there is no 2.6.23-git22 yet). It turned out
> to be an old broken kernel. Current -git seems to boot.
> Sorry for the noise.

OK, all for the better :-)

-- 
Jens Axboe

