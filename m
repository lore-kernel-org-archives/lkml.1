Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbXH1Tde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbXH1Tde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763146AbXH1TWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:22:53 -0400
Received: from verein.lst.de ([213.95.11.210]:56611 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763389AbXH1TWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:22:51 -0400
Date: Tue, 28 Aug 2007 21:22:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: clameter@sgi.com
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [35/36] Large blocksize support for ext2
Message-ID: <20070828192209.GB13883@lst.de>
References: <20070828190551.415127746@sgi.com> <20070828190736.220951776@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828190736.220951776@sgi.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 12:06:26PM -0700, clameter@sgi.com wrote:
> Hmmm... Actually there is nothing additional to be done after the earlier
> cleanup of the macros. So just modify copyright.

So you get a copyright line for some trivial macro cleanups?  Please
drop this patch and rather put your copyright into places where you
actually did major work..

