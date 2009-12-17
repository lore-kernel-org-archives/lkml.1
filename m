Return-Path: <linux-kernel-owner+w=401wt.eu-S1764087AbZLQIKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764087AbZLQIKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbZLQIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:10:53 -0500
Received: from verein.lst.de ([213.95.11.210]:41304 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbZLQIKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:10:52 -0500
Date: Thu, 17 Dec 2009 09:10:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Paul Mundt <lethal@linux-sh.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: convert to asm-generic/hardirq.h
Message-ID: <20091217081048.GB11571@lst.de>
References: <20090804145529.GL20487@lst.de> <20090805071828.GA8415@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805071828.GA8415@linux-sh.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 04:18:28PM +0900, Paul Mundt wrote:
> On Tue, Aug 04, 2009 at 04:55:29PM +0200, Christoph Hellwig wrote:
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> Applied, thanks.

Did this cause problems in the end?  Still doesn't seem to be in Linus'
tree.
