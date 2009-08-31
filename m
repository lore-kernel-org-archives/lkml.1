Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZHaTvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZHaTvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZHaTvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:51:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZHaTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:51:47 -0400
Date: Mon, 31 Aug 2009 15:51:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v15
Message-ID: <20090831195148.GA26130@infradead.org>
References: <1251747693-32354-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251747693-32354-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 09:41:26PM +0200, Jens Axboe wrote:
> Christoph, let me know if there are things you are still not happy
> with and I will reply/address them. Note that this series has only
> received a light testing. This means that it boots and seems to work
> (flushes data on sync and at intervals) and does not corrupt data,
> but it hasn't received a thorough testing yet. That will come tomorrow.
> But I wanted to push this out there, so we can settle the code base
> quickly again.

I'll slowly look over it later.  But I think it would be extremly
helpful if we could get it into -next ASAP for wider testing.

