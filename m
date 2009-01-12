Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZALUWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZALUWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZALUWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:22:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZALUWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:22:38 -0500
Date: Mon, 12 Jan 2009 15:22:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090112202237.GA27636@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151915.df138883.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106151915.df138883.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:19:15PM -0800, Andrew Morton wrote:
> Well that's a drop-it-all-and-start again scale of thing.
> 
> Rodolfo, do you have sufficient information here?

I think the core is pretty solid and the few things mentioned there
can be easily fixed up even after the initial merge.

pps-documentation-programs-and-examples.patch and
pps-userland-header-file-for-pps-api.patch should just be dropped
for now.
