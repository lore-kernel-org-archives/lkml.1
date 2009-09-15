Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZIOXTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZIOXTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZIOXT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:19:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbZIOXT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:19:28 -0400
Date: Tue, 15 Sep 2009 19:19:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090915231931.GB7636@infradead.org>
References: <200909151645.14256.philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909151645.14256.philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 04:45:13PM +0200, Philipp Reisner wrote:
> Hi Linus,
> 
> Please pull
> git://git.drbd.org/linux-2.6-drbd.git drbd
> 
> DRBD is a shared-nothing, replicated block device. It is designed to
> serve as a building block for high availability clusters and
> in this context, is a "drop-in" replacement for shared storage.
> 
> It has been discussed and reviewed on the list since March,
> and Andrew has asked us to send a pull request for 2.6.32-rc1.

The last thing we need is another bloody raid-reimplementation, coupled
with a propritary on the wire protocol.  NACK as far as I am concerned.

