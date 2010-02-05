Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0BEPrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:47:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0BEPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:47:50 -0500
Date: Fri, 5 Feb 2010 10:47:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20100205154748.GA11469@infradead.org>
References: <20090925122556.2f8bd939@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925122556.2f8bd939@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:25:56PM +0200, Arjan van de Ven wrote:
> >From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 25 Sep 2009 12:20:57 +0200
> Subject: [PATCH] perf_core: provide a kernel-internal interface to get to performance counters

So this patch got accepted into mainline a while ago, without a user
ever beeing presented, nevermind actually included in mainline.  Time
to revert providing these useless exports and dead code?

