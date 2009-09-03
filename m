Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZICQRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZICQRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZICQRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:17:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbZICQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:17:33 -0400
Date: Thu, 3 Sep 2009 12:17:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090903161734.GA9722@infradead.org>
References: <20090903041429.GA29875@kroah.com> <1251967786.3336.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251967786.3336.19.camel@johannes.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 10:49:46AM +0200, Johannes Berg wrote:
> > 	- vt66* wireless drivers.  These VIA drivers are being actively
> > 	  worked on to get into a much better shape.  Nice job.
> 
> And do they come with their own wireless stack too?

Please don't put in the vendor vt6656 driver, it will conflict with a
proper mac80211 vt6656 driver a group mentored by me will submit late in
the 2.6.32 cycle.

