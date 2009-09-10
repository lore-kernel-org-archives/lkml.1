Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZIJGzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZIJGzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZIJGzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:55:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:58649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZIJGzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:55:42 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090909122006.GA18599@kernel.dk>
References: <20090907141458.GD24507@elte.hu>
	 <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk>
	 <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins>
	 <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk>
	 <20090909122006.GA18599@kernel.dk>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 08:55:38 +0200
Message-Id: <1252565738.7205.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 14:20 +0200, Jens Axboe wrote:
> 
> One thing I also noticed is that when I have logged in, I run xmodmap
> manually to load some keymappings (I always tell myself to add this to
> the log in scripts, but I suspend/resume this laptop for weeks at the
> time and forget before the next boot). With the stock kernel, xmodmap
> will halt X updates and take forever to run. With BFS, it returned
> instantly. As I would expect.

Can you provide a little more detail (I'm a xmodmap n00b), how does one
run xmodmap and maybe provide your xmodmap config?

