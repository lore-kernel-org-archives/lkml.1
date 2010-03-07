Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0CGKHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 05:07:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0CGKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 05:07:48 -0500
Date: Sun, 7 Mar 2010 05:07:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       david@fromorbit.com, aelder@sgi.com
Subject: Re: UML XFS link error list_sort
Message-ID: <20100307100744.GA22637@infradead.org>
References: <alpine.DEB.2.00.1003062118240.19862@parag-laptop> <4B931C96.7070703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B931C96.7070703@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 07:25:10PM -0800, Randy Dunlap wrote:
> I posted a patch for xfs to select LIST_SORT (kconfig symbol)
> so that the library is built for it (xfs).

Can you just send it directly to Linus instead of waiting for the
next pull request?

