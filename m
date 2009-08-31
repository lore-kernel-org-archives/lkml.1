Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZHaM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZHaM7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZHaM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:59:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZHaM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:59:19 -0400
Date: Mon, 31 Aug 2009 08:59:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 03/10] writeback: get rid of pdflush completely
Message-ID: <20090831125920.GB20465@infradead.org>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-4-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251720891-19793-4-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 02:14:44PM +0200, Jens Axboe wrote:
> It is now unused, so kill it off.

I would suggest merging it into the previous patch, instead of keeping
the dead code around a tad longer.
