Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbXIQNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbXIQNIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXIQNIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:08:23 -0400
Received: from verein.lst.de ([213.95.11.210]:51917 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbXIQNIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:08:21 -0400
Date: Mon, 17 Sep 2007 15:08:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: convert to generic sys_ptrace
Message-ID: <20070917130803.GA4578@lst.de>
References: <20070908191257.GA5075@lst.de> <20070915011150.0439a432.akpm@linux-foundation.org> <20070915081437.GA5251@lst.de> <20070915013619.07722b24.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915013619.07722b24.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 01:36:19AM -0700, Andrew Morton wrote:
> I just did a successful gcc-4.1.0 alpha allmodconfig build with 2.6.23-rc5
> plus 44 patches which are in or are targetted for 2.6.23:

Yeah, things seem to be in better shape now.

