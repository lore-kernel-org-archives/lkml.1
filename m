Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbZLQIQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbZLQIQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763362AbZLQIQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:16:00 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50283 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761139AbZLQIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:16:00 -0500
Date: Thu, 17 Dec 2009 17:15:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: convert to asm-generic/hardirq.h
Message-ID: <20091217081554.GB20425@linux-sh.org>
References: <20090804145529.GL20487@lst.de> <20090805071828.GA8415@linux-sh.org> <20091217081048.GB11571@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217081048.GB11571@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:10:48AM +0100, Christoph Hellwig wrote:
> On Wed, Aug 05, 2009 at 04:18:28PM +0900, Paul Mundt wrote:
> > On Tue, Aug 04, 2009 at 04:55:29PM +0200, Christoph Hellwig wrote:
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > Applied, thanks.
> 
> Did this cause problems in the end?  Still doesn't seem to be in Linus'
> tree.

Nope, it was in Linus' tree for awhile, but then I needed to add an
nmi_count and had to switch back to an arch-specific one.
