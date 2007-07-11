Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXGKLjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXGKLjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760379AbXGKLjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:39:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53749 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000AbXGKLjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:39:45 -0400
Subject: Re: -mm merge plans for 2.6.23
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070711113553.GA18665@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070711113553.GA18665@lst.de>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 12:39:42 +0100
Message-Id: <1184153982.17833.92.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 13:35 +0200, Christoph Hellwig wrote:
> On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> > romfs-printk-format-warnings.patch
> 
> NACK on this one. 

The rest of it is nacked anyway, until we unify the point and
get_unmapped_area methods of the MTD API.

-- 
dwmw2

