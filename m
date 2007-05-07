Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXEGQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXEGQDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXEGQDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:03:03 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4174 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965536AbXEGQDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:03:00 -0400
Date: Mon, 7 May 2007 11:38:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dan Williams <dcbw@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re: Please pull 'libertas' branch of wireless-2.6)
Message-ID: <20070507153848.GD5125@tuxdriver.com>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070507104117.GA31601@infradead.org> <1178539423.3032.24.camel@localhost.localdomain> <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463F443A.5000306@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 11:22:34AM -0400, Jeff Garzik wrote:

> Open source is about release early, release often.  Not "hide code in a 
> dark corner until Christoph thinks it is perfect."  We have high 
> standards for upstream merged code, but that standard is not perfection. 
>  Perfect is the enemy of good.
> 
> I would rather see the libertas-2.6 git changes pulled into upstream, 
> and am not inclined to revert a WORKING DRIVER at this point, a driver 
> that is actively maintained and has seen quite a bit of improvement 
> since it initially appeared.

Perhaps I was a bit hasty.  Given Dan's response I thought that I
had missed something.

But, you are right -- the driver works now, and Dan and company are
sure to be around to keep working on it.

> Plus, that leaves the kernel history less polluted.

Consider the request withdrawn.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
