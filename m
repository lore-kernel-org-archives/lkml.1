Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXEURMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXEURMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbXEURMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:12:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53082 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbXEURMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:12:43 -0400
Date: Mon, 21 May 2007 18:12:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-ID: <20070521171242.GA30854@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
References: <20070521144618.GA6914@redhat.com> <20070521150242.GA25146@infradead.org> <20070521150937.GB6957@redhat.com> <20070521151209.GA25744@infradead.org> <20070521152050.GC6957@redhat.com> <20070521154613.GA27027@infradead.org> <20070521171109.GC9653@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521171109.GC9653@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 01:11:09PM -0400, Dave Jones wrote:
>  > Randy mentioned in bugzilla that 2.4.22 didn't work either, so I'd
>  > be very surprised if 2.4.21 works.
> 
> good point.  I don't see anything obvious in 2.4.22 that would have
> caused a regression, so this sounds suspect.
> I'll close the bugzilla out based on your comments, thanks for looking at it.

Btw, I'd like to take a look at Randy's patches for bigger block sizes,
it might be quite easy to fix the remaining bits.  Does anyone have
a copy since the link doesn't work anymore?
