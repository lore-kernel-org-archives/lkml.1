Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbYHNT2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbYHNT2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYHNT1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:27:55 -0400
Received: from verein.lst.de ([213.95.11.210]:44349 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYHNT1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:27:54 -0400
Date: Thu, 14 Aug 2008 21:27:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: Re: UBIFS updates for 2.6.27
Message-ID: <20080814192739.GA15950@lst.de>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:17:29PM +0300, Artem Bityutskiy wrote:
> Hi,
> 
> Christoph asked me to send UBIFS patches here before I put them
> to Linux next.
> 
> The following are patches we plan to send to Linus before 2.6.27
> is out. Some of the patches are not fixes, but because UBIFS is
> new and 2.6.27 will be its first release, we think it is OK to
> merge "non-fix" patches for UBIFS as an exception.
> 
> Christoph, I do not send NFS patch for now because I'd like to
> work on it some more, taking into account your suggestions.

Ok.  The other patch looks good to me from a quick glance.  BTW,
-fsdevel might be a better list than lkml for fs patches review.

