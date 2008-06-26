Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYFZHr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYFZHr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYFZHrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:47:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbYFZHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:47:13 -0400
Date: Thu, 26 Jun 2008 03:47:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Clean up stale references to semaphores
Message-ID: <20080626074711.GC7064@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:17PM +1000, Dave Chinner wrote:
> A lot of code has been converted away from semaphores,
> but there are still comments that reference semaphore
> behaviour. The log code is the worst offender. Update
> the comments to reflect what the code really does now.

Looks good.  

