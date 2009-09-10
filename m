Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZIJG6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZIJG6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZIJG6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:58:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56411 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbZIJG6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:58:54 -0400
Date: Thu, 10 Sep 2009 08:58:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910065856.GL18599@kernel.dk>
References: <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252565738.7205.29.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 14:20 +0200, Jens Axboe wrote:
> > 
> > One thing I also noticed is that when I have logged in, I run xmodmap
> > manually to load some keymappings (I always tell myself to add this to
> > the log in scripts, but I suspend/resume this laptop for weeks at the
> > time and forget before the next boot). With the stock kernel, xmodmap
> > will halt X updates and take forever to run. With BFS, it returned
> > instantly. As I would expect.
> 
> Can you provide a little more detail (I'm a xmodmap n00b), how does one
> run xmodmap and maybe provide your xmodmap config?

Will do, let me get the notebook and strace time it on both bfs and
mainline.

-- 
Jens Axboe

