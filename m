Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXLCT3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXLCT3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXLCT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:29:08 -0500
Received: from verein.lst.de ([213.95.11.210]:38053 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbXLCT3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:29:07 -0500
Date: Mon, 3 Dec 2007 20:28:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: overdue items in feature-removal-schedule
Message-ID: <20071203192850.GA13761@lst.de>
References: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.881 () BAYES_44,SUBJ_HAS_UNIQ_ID
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 11:58:07AM -0500, Erez Zadok wrote:
> There are 29 listed items in feature-removal-schedule.txt.  11 of those have
> dates or kernel versions that have passed, including this one:
> 
> What:	remove EXPORT_SYMBOL(kernel_thread)
> When:	August 2006

We still haven't managed to kill all intree modular users of this.
I'll be gone as soon as that happens.  It might be worth updating the
file to idicate exactly that.

