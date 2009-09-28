Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZI1EWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZI1EWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZI1EWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:22:48 -0400
Received: from ozlabs.org ([203.10.76.45]:36845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZI1EWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:22:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PULL] lguest & virtio
Date: Mon, 28 Sep 2009 12:20:25 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
References: <200909232235.15076.rusty@rustcorp.com.au> <20090926150124.GA11623@lst.de>
In-Reply-To: <20090926150124.GA11623@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909281220.26266.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 12:31:24 am Christoph Hellwig wrote:
> What happend to the patch to drop the virt/non-rotational flag?

I pushed it back; I realize now you still wanted that one, it was
"Subject: virtio_blk: set QUEUE_ORDERED_DRAIN by default" you wanted to
reconsider.

Will send separately now...
Rusty.
